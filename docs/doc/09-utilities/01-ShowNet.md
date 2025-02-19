___
## ShowNet Interpeter
The ShowNet interpreter lists *connection networks* for the currently open *context* as text in the *console window*.  For the purposes of explaining ShowNet, a context can be either a *component assembly* or a *test bench*.  The results produced by ShowNet are analogous to a netlist generated from the currently open context.

On the GME canvas, *connections* are drawn as a line between two endpoints.  These endpoints can be *ports*, such as schematic pins, or *connectors*.  Both endpoints of a connection must be the same type, either both ports, or both connectors. ShowNet shows both types of connection networks: 

1. Port networks, that represent connections between ports, and 
2. Connector networks, that represent connections between connectors.

For example, in **Figure 1**, there is a first connection shown between the ***GND*** schematic pins of the ***POWER_AND_GROUND*** *connector* and the ***U1*** component, and a second connection shown between the ***GND*** schematic pin of the ***U1*** component and its ***MODE*** schematic pin.  But, although two connections are shown, the same signal is going to all three of these pins, and they are all connected together.

![image](images/12-03-1.2V_POWER_ENABLED_REG.png) 

*Figure 1: The 1.2V_POWER_ENABLED_REG Component Assembly*
___


Mathematically speaking, "connected to" in CyPhy acts as a transitive relationship, in that if one endpoint is connected to a second, and the second is connected to a third, then this implies the first is connected to the third. So, a connection network is the set of endpoints transitively "connected to" each other.

In **Figure 1** the two ***GND*** pins and the ***MODE*** pin in are all part of the same connection network.  In a project that used this component assembly, there would likely be pins in other component assemblies also connected to this electrical network, but ShowNet only lists pins in the currently opened context.

ShowNet is helpful whenever the context's connections are hard to follow.  Examples include:
- When the circuit is too large to inspect without scrolling,
- When connections are dense, or
- When there are many endpoints in a connection network.

In all of these cases, ShowNet can make it easier to determine the context's connection networks.

### Quick Start

Using ShowNet is actually quite simple.  **Figure 2** shows the areas of interest on the GME screen.

![image](images/12-03-ShowNet-Diagram-Marked.png) 

*Figure 2: Shownet Areas of Interest on the GME screen*
___

Before using ShowNet, please open your project in GME, and open your context in the GME canvas. One way to open your context in the GME canvas is to left-double-click the mouse on the context's listing in the *GME Browser* window.

Then, to run ShowNet, just left-click on the ShowNet icon in the *component toolbar* to generate the results in the *console window*.  **Figure 3** shows an enlarement of the ShowNet icon.

![image](images/12-03-ShowNet-Icon.png) 

*Figure 3: An Enlargement of the ShowNet Icon*
___

### Results
Sample results from using ShowNet are shown in **Figure 4** below.


![image](images/12-03-Results.png) 

*Figure 4: Sample ShowNet Results*
___

These results in black text were obtained from using ShowNet on the ***1.2V_POWER_ENABLED_REG*** component assembly shown in **Figure 1**.  The green line numbers were added later, to aid the discussion.

The results consist of:
1. a startup message (line 1), 
2. a listing of the port networks (lines 2-15), 
3. a listing of the connector networks (line 16), and
4. an ending message (line 17).

Since the component assembly of **Figure 1** contains no connector networks, only a header (line 16) is shown for them, confirming none were found. But, if the component assembly did have connector networks, they would have been
listed in a similar way as the port networks, which are described next.

#### Listing of Port Networks

The listing of port networks begins with a header (line 2) that summarizes the port network information. This header includes the number of port networks found in the context, and the name of the context.

After the port network header, each port network is described in turn (lines 3-15). 

Each port network description starts with a line consisting of the signal name and a colon, (lines 3, 7, 10, and 13), followed by lines each describing an endpoint in the network (lines 4-6, 8-9, 11-12, and 14-15).

The signal names are automatically generated by ShowNet, typically from the longest pin name in the network. ShowNet ensures that signal names are unique within the current context.

Following the signal name comes a list of the connected endpoint desriptions, one per line (lines 4-6, 8-9, 11-12, and 14-15).

Using line 4 of **Figure 2** as a specific example, these endpoint description lines consist of:
1. some periods to indent the text,
2. the name of the port (GND),
3. the port's kind (SchematicModelPort),
4. the words "of the"
5. the name of the owner of the port (POWER_AND_GROUND),
6. the owner's kind (Connector).

### Practical Example
As a practical example using a more-complex component assembly, consider the one shown in **Figure 5** below.


![image](images/12-03-HostComm-Flawed.png) 

*Figure 5: A More-Complex Component Assembly*
___

The component assembly in **Figure 5** is similar to the ***HostComm*** ARA prototype component assembly, but **it has a connection flaw** that is hard to identify by visual inspection of **Figure 5**.  The ShowNet results shown in **Figure 6** below make it easier to see the problem.

![image](images/12-03-HostCommFlawedResults.png) 

*Figure 6: ShowNet Results for the More-Complex Component Assembly*
___

In **Figure 6** signal names are listed in alphabetical order, and there are two separate port networks that look like a ground signal: "10_GND" (lines 7-25) and "GND" (lines 29-33).  If a user knew there was supposed to only be one ground signal in the project, they'd likely realize that a connection was missing between those two ground-signal port networks. Compared to examining  **Figure 5**, the ShowNet results make  it easier to identify this network connection problem.

### Suggested Exercises

Users are encouraged to try the ShowNet interpreter for themselves with contexts containing connector networks and with workspace contexts. ShowNet doesn't make any changes to the model, so it's safe to experiment with it.
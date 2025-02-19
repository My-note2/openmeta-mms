.. _fea_create_openmeta_component:

Building a CAD Component
------------------------

In this first section, we will build a 3D component. Engineers often use
multiple types of analysis software to test their designs. This practice
takes time; you need to learn each piece of software and compose a model
for each one that will test for a parameter. However, OpenMETA
tools allow you to run multiple types of analyses by composing just one
model.

In the OpenMETA tools, we start a design by instantiating
components and joining their interfaces, yielding a **Component
Assembly**. We call this process *composition*. From this composed
design, we can generate new models and run analyses.

First we must create a component for the Creo model we wish to test.
This process breaks down into the following steps:

1. :ref:`create_component`
2. :ref:`reference_creo`
3. :ref:`add_objects`
4. :ref:`make_connections`

.. _create_component:

Creating a New OpenMETA Component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A component houses the Creo part reference, as well as defining objects for the Model. This is the smallest piece of the FEA TestBench hierarchy, so it must be developed first.

1. In your **GME Browser**, open the *RootFolder* by left-clicking
   the plus box to the left of the name.
2. Right-click the **RootFolder** and choose :menuselection:`Insert Folder
   --> Component Assembly`.
3. Right-click the **RootFolder** and choose :menuselection:`Insert Folder
   --> Components`.
4. Right-click the new **Component** folder and choose :menuselection:`Insert
   model --> Component`.
5. Rename the component **Simple\_Cube**.
6. Double left-click **Simple\_Cube** to open the blank component
   canvas.
7. Located on the left is the **Part Browser**; left-click the **Solid
   Modeling** tab.
8. Locate the **Property** object, left-click the image then drag and
   drop it onto the workspace.

.. note:: Make sure you're using the Property object, not the Complex Metric.

9. Click on the word "Property" and rename it **PTC\_Material\_Name**.
10. Click the empy box in the *Property* and type
    ALUMINUM\_ALLOY\_6061\_T6.

.. figure:: images/IMAGE_1.png
   :alt: Solid Modeling Demo

This will be used later when defining the material type for the mesher and solver software.

.. _reference_creo:

Reference the Creo Model
^^^^^^^^^^^^^^^^^^^^^^^^

1. Select the Component Authoring Tool |METALINK_BUTTON| from
   the top tool bar.
2. Select the **Add CAD** tile.
3. Navigate through :menuselection:`components --> zc3hnmz3 --> CAD` and select the
   Creo versioned file **creo\_demo.prt**.

.. |METALINK_BUTTON| image:: images/cat_tool.png
   :width: 24px

.. note:: This process may take a few seconds as it converts the key
   features of the Creo Model into objects to be used by GME.

Now you should see a CADModel that is populated with
**CUBE\_CENTER\_REF, SURF\_REF\_BOTTOM, SURF\_REF\_TOP,
SURF\_REF\_RIGHT, SURF\_REF\_LEFT, SURF\_REF\_BACK,** and **SURF\_REF\_FRONT**.
These are points on the center of every face of the cube in the Creo model.

.. figure:: images/IMAGE_1_5.png
   :alt: Solid Modeling Demo

While they are defined in the model, they have not yet been defined in our
component.

1. Connect (Ctrl+2) the **PTC_Material_Name** to the Parameter with the matching
   name in the `CAD Model`. (If this CAD Model Parameter is not visible,
   make sure the canvas ``Aspect`` is set to **All**.)
2. Select the `Solid Modeling` tab of the **Part Browser**.
3. Drag and drop the **point** object into the component workspace.
4. Repeat this process 6 more times (one for every reference point on
   the model) and rename all points to match the names of the points in
   the CREO model.
5. Enter **connect mode** (Ctrl+2) and connect all these points to their
   corresponding points as **Port Composition** in the CADModel.

.. figure:: images/IMAGE2.png
   :alt: Solid Modeling Demo

.. _add_objects:

Add Necessary Objects
^^^^^^^^^^^^^^^^^^^^^

We have now **Exposed** these points for future use. Next we need to add
objects to help Patran, the meshing software, understand what is
happening. Patran/Nastran need to know the normal directions of the
faces used and the material orientation for each face as well. This is
determined by the **Face** and **Material Contents** objects.

Face
''''

1. Drag and drop the **Face** object from the *Solid Modeling* tab of the *Part
   Browser* into the component workspace.
2. Double click the **Face** object to edit it.
3. Add one **Direction\_Reference\_Point** and one **ReferencePoint**
   (put the Direction point above the Reference point to make future
   steps more visible).
4. Back in the **Simple_Cube** canvas, copy and paste 6 more of these
   edited faces (one for every point in the model)
5. Rename these faces as "Face\_Ref\_Front, Face\_Ref\_Back, ..."

After completing these steps, your **Simple_Cube** component should be ordered
similar to the following image.

.. note:: Descending order is important here as it will make later steps
   much more intuitive.

.. figure:: images/IMAGE3.png
   :alt: Solid Modeling Demo

Material Contents
'''''''''''''''''

1. Drag and drop the **MaterialContents** object from the *Solid Modeling* tab of
   the **Part Browser** into the component workspace.
2. Double click the MaterialContents object to edit it.
3. Add the **MaterialLayer, End\_direction,** and **Start\_Direction**
   atoms aligned as shown below.
4. Select the MaterialLayer atom, and click the **Attributes tab** in
   the *Object Inspector* on the left.
5. Set all values as shown below.

.. figure:: images/IMAGE4.png
   :alt: Solid Modeling Demo

6. Back in the **Simple_Cube** canvas, copy and paste 6 more of these
   edited MaterialContents (one for every point in the model).
7. Rename these faces as "MaterialContents\_Front,
   MaterialContents\_Back, ... etc".

After completing these steps, your component should be ordered like the
following image.

.. note:: Descending order is important here as it will make later steps
   much more intuitive.

.. figure:: images/IMAGE5.png
   :alt: Solid Modeling Demo

.. _make_connections:

Making Connections
^^^^^^^^^^^^^^^^^^

Now that we have all the necessary objects for the mesher and solver to
fully define the model, we need to make the appropriate connections
in our component. This can be done several ways, but the process
described below produces the cleanest outcome.

Face Objects
''''''''''''

1. Enter into Connection mode (Ctrl+2), and connect the
   **Reference\_Point** "Ref" of **Face\_Ref\_Front** to
   **SURF\_REF\_FRONT** exposed from the **CADModel**.

.. note:: All connections in the component building process will be port
          composition connections.

2. Repeat this step for every *Face Reference* so that they all connect
   to the same name in the CADModel.

.. figure:: images/IMAGE6.png
   :alt: Solid Modeling Demo

.. note:: Make sure that for all the faces, the **Normal Direction** option is
          listed as **Away_Reference_point**.

.. figure:: images/IMAGE6_5.png
   :alt: Solid Modeling Demo

We have just assigned a reference to each face so that they connect to a
real point in the model. Now we need to assign a direction for every
point so that Patran/Nastran knows where the **normal** of each face
points. We will need to use a point in the center of the cube so that
every vector can be described as **Normal Away From** in the *Object
Inspector* under the **Attributes** tab. You could just connect the
*DirectionReferencePoint* of each face to the **Cube\_Center\_Ref**, but
this would lead to a messy model with many connections. The cleanest way
to do this is to *Chain* the *DirectionReferencePoints* together.

3. Connect the **Direction\_Reference\_Point** "Dir" of **Face\_Ref\_Front** to
   **Direction\_Reference\_Point** "Dir" of Face\_Ref\_Back.

.. figure:: images/IMAGE7.png
   :alt: Solid Modeling Demo

4. Repeat this process from "Dir" to "Dir" ascending to the last "Face\_Ref\_..."
   object.
5. Connect the **Direction\_Reference\_Point** "Dir" of **Face\_Ref\_Center** to
   **Cube\_Center\_Ref** on the CADModel.

The Component should now look like this:

.. figure:: images/IMAGE8.png
   :alt: Solid Modeling Demo

We have completed the face reference portion of the Component, so all
that remains is connecting the MaterialContents.

Material Contents Objects
'''''''''''''''''''''''''

We will follow a lot of the same steps used to connect the *Faces Objects* but
this process is slightly different.

1. Enter into Connection mode (Ctrl+2), and connect the **Start Point**
   "Sta" of **MaterialContents\_Front** to **ReferencePoint** "Ref" of
   **Face\_Ref\_Front**.
2. Connect the **End Point** "End" of **MaterialContents\_Front** to
   **Start Point** "Sta" of *MaterialContents\_Back*.

.. figure:: images/IMAGE9.png
   :alt: Solid Modeling Demo

We have now *Chained* the **MaterialContents\_Front** to both
**Face\_Ref\_Front** and to **MaterialContents\_Back**. Now
**MaterialContents\_Front** starts at **Face\_Ref\_Front** in the
CADModel as shown by the *Chain* from **MaterialContents\_Front** to
**Face\_Ref\_Front** to **SURF\_REF\_FRONT** in the CADModel.

3. Repeat step 2 for each material face so that they are connected as
   shown.

4. Connect the **End Point** "End" of **MaterialContents\_Center** to
   **Cube_Center_Ref** in the CADModel.

.. figure:: images/IMAGE10.png
   :alt: Solid Modeling Demo

5. Connect **MaterialContents_Front** to **Face\_Ref\_Front**.

.. figure:: images/IMAGE10_5.png
   :alt: Solid Modeling Demo

6. Repeat this step for each *MaterialContents* and its corresponding *Face_Ref*.

.. figure:: images/IMAGE10_75.png
   :alt: Solid Modeling Demo

Now all of the MaterialContents objects are connected as needed. They
reference the same point as their corresponding face object, and point
in the direction of the previous Material Contents Object to the
**Cube\_Center\_Ref**.

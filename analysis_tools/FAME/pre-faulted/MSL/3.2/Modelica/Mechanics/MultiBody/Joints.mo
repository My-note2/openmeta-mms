// processed by FAME Modelica Library Fault-Augmentor [version 19011]

within Modelica.Mechanics.MultiBody;

package Joints
 "Components that constrain the motion between two frames"
 extends Modelica.Icons.Package;

 import SI = Modelica.SIunits;

 model Prismatic
  "Prismatic joint (1 translational degree-of-freedom, 2 potential states, optional axis flange)"

  import SI = Modelica.SIunits;

 // locally defined classes in Prismatic
    model _famefaults_axis = FAME.Dampers.TranslationalWithConnectEquations;
    model _famefaults_support = FAME.Dampers.TranslationalWithConnectEquations;

 // components of Prismatic
  Modelica.SIunits.Force f "Actuation force in direction of joint axis";
  Modelica.Mechanics.Translational.Interfaces.Flange_a axis if useAxisFlange "1-dim. translational flange that drives the joint" annotation(Placement(transformation(extent={{90,50},{70,70}},rotation=0)));
  FAME.Dampers.TranslationalWithConnectEquations _famefault_axis(amount=0.0) if useAxisFlange;
  final parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(n,0.0) "Unit vector in direction of prismatic axis n";
  Modelica.Mechanics.Translational.Interfaces.Flange_b support if useAxisFlange "1-dim. translational flange of the drive drive support (assumed to be fixed in the world frame, NOT in the joint)" annotation(Placement(transformation(extent={{-30,50},{-50,70}},rotation=0)));
  FAME.Dampers.TranslationalWithConnectEquations _famefault_support(amount=0.0) if useAxisFlange;
  parameter Boolean animation=true "= true, if animation shall be enabled";
  parameter StateSelect stateSelect=StateSelect.prefer "Priority to use distance s and v=der(s) as states" annotation(Dialog(tab="Advanced"));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque" annotation(Placement(transformation(extent={{84,-16},{116,16}},rotation=0)));
  Modelica.SIunits.Acceleration a(start=0) "Second derivative of s (relative acceleration)";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n={1,0,0} "Axis of translation resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
  parameter Modelica.SIunits.Distance boxHeight=boxWidth "Height of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  constant Modelica.SIunits.Position s_offset=0 "Relative distance offset (distance between frame_a and frame_b = s_offset + s)" annotation(Evaluate=false);
  input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  Modelica.SIunits.Velocity v(start=0,final stateSelect=stateSelect) "First derivative of s (relative velocity)";
  parameter Modelica.SIunits.Distance boxWidth=world.defaultJointWidth "Width of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter Modelica.Mechanics.MultiBody.Types.Axis boxWidthDirection={0,1,0} "Vector in width direction of box, resolved in frame_a" annotation(Evaluate=true,Dialog(tab="Animation",group="if animation = true",enable=animation));
  Modelica.SIunits.Position s(start=0,final stateSelect=stateSelect) "Relative distance between frame_a and frame_b" annotation(unassignedMessage="
The relative distance s of a prismatic joint cannot be determined.
Possible reasons:
- A non-zero mass might be missing on either side of the parts
  connected to the prismatic joint.
- Too many StateSelect.always are defined and the model
  has less degrees of freedom as specified with this setting
  (remove all StateSelect.always settings).
");
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-116,-16},{-84,16}},rotation=0)));
  parameter Boolean useAxisFlange=false "= true, if axis flange is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
  input Modelica.Mechanics.MultiBody.Types.Color boxColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
 protected
  Modelica.Mechanics.Translational.Interfaces.InternalSupport internalAxis(f=f) annotation(Placement(transformation(extent={{70,50},{90,30}})));
  Modelica.Mechanics.Translational.Components.Fixed fixed annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Mechanics.Translational.Sources.ConstantForce constantForce(f_constant=0) if not useAxisFlange annotation(Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape box(shapeType="box",color=boxColor,specularCoefficient=specularCoefficient,length=(if noEvent(abs(s+s_offset)>1.e-6) then s+s_offset else 1.e-6),width=boxWidth,height=boxHeight,lengthDirection=e,widthDirection=boxWidthDirection,r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  outer Modelica.Mechanics.MultiBody.World world;

 // algorithms and equations of Prismatic
 equation
  v = der(s);
  a = der(v);
  frame_b.r_0 = frame_a.r_0+Frames.resolve1(frame_a.R,e*(s_offset+s));
  frame_b.R = frame_a.R;
  zeros(3) = frame_a.f+frame_b.f;
  zeros(3) = frame_a.t+frame_b.t+cross(e*(s_offset+s),frame_b.f);
  f = (-e)*frame_b.f;
  s = internalAxis.s;
  connect(fixed.flange,_famefault_support.port_b) annotation(Line(points={{-40,40},{-40,60}},color={0,127,0},smooth=Smooth.None));
  connect(internalAxis.flange,_famefault_axis.port_b) annotation(Line(points={{80,40},{80,60}},color={0,127,0},smooth=Smooth.None));
  connect(constantForce.flange,internalAxis.flange) annotation(Line(points={{60,40},{80,40}},color={0,127,0},smooth=Smooth.None));
  Connections.branch(frame_a.R,frame_b.R);
  assert(cardinality(frame_a)>0,"Connector frame_a of joint object is not connected");
  assert(cardinality(frame_b)>0,"Connector frame_b of joint object is not connected");
  connect(axis,_famefault_axis.port_a);
  connect(support,_famefault_support.port_a);

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,-50},{-30,41}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-100,40},{-30,50}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-30,-30},{100,20}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-30,20},{100,30}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-30,-50},{-30,50}},color={0,0,0}),Line(points={{100,-30},{100,21}},color={0,0,0}),Text(extent={{60,12},{96,-13}},lineColor={128,128,128},textString="b"),Text(extent={{-95,13},{-60,-9}},lineColor={128,128,128},textString="a"),Text(visible=useAxisFlange,extent={{-150,-135},{150,-95}},textString="%name",lineColor={0,0,255}),Text(extent={{-150,-90},{150,-60}},lineColor={0,0,0},textString="n=%n"),Rectangle(visible=useAxisFlange,extent={{90,30},{100,70}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Text(visible=not useAxisFlange,extent={{-150,60},{150,100}},textString="%name",lineColor={0,0,255})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics),Documentation(info="<HTML>
<p>
Joint where frame_b is translated along axis n which is fixed in frame_a.
The two frames coincide when the relative distance \"s = 0\".
</p>

<p>
Optionally, two additional 1-dimensional mechanical flanges
(flange \"axis\" represents the driving flange and
flange \"support\" represents the bearing) can be enabled via
parameter <b>useAxisFlange</b>. The enabled axis flange can be
driven with elements of the
<a href=\"modelica://Modelica.Mechanics.Translational\">Modelica.Mechanics.Translational</a>
library.

</p>

<p>
In the \"Advanced\" menu it can be defined via parameter <b>stateSelect</b>
that the relative distance \"s\" and its derivative shall be definitely
used as states by setting stateSelect=StateSelect.always.
Default is StateSelect.prefer to use the relative distance and its
derivative as preferred states. The states are usually selected automatically.
In certain situations, especially when closed kinematic loops are present,
it might be slightly more efficient, when using the StateSelect.always setting.
</p>

<p>
In the following figure the animation of a prismatic
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint. The black arrow is parameter
vector \"n\" defining the translation axis
(here: n = {1,1,0}).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Prismatic.png\">

</HTML>
"));
 end Prismatic;

 model Revolute
  "Revolute joint (1 rotational degree-of-freedom, 2 potential states, optional axis flange)"

  import SI = Modelica.SIunits;

 // locally defined classes in Revolute
    model _famefaults_axis = FAME.Dampers.RotationalWithConnectEquations;
    model _famefaults_support = FAME.Dampers.RotationalWithConnectEquations;

 // components of Revolute
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque" annotation(Placement(transformation(extent={{84,-16},{116,16}},rotation=0)));
  constant Modelica.SIunits.Angle phi_offset=0 "Relative angle offset (angle = phi_offset + phi)";
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-116,-16},{-84,16}},rotation=0)));
  Modelica.SIunits.Angle phi(start=0,final stateSelect=stateSelect) "Relative rotation angle from frame_a to frame_b" annotation(unassignedMessage="
The rotation angle phi of a revolute joint cannot be determined.
Possible reasons:
- A non-zero mass might be missing on either side of the parts
  connected to the revolute joint.
- Too many StateSelect.always are defined and the model
  has less degrees of freedom as specified with this setting
  (remove all StateSelect.always settings).
");
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axis if useAxisFlange "1-dim. rotational flange that drives the joint" annotation(Placement(transformation(extent={{10,90},{-10,110}},rotation=0)));
  FAME.Dampers.RotationalWithConnectEquations _famefault_axis(amount=0.0) if useAxisFlange;
  Modelica.Mechanics.Rotational.Interfaces.Flange_b support if useAxisFlange "1-dim. rotational flange of the drive support (assumed to be fixed in the world frame, NOT in the joint)" annotation(Placement(transformation(extent={{-70,90},{-50,110}},rotation=0)));
  FAME.Dampers.RotationalWithConnectEquations _famefault_support(amount=0.0) if useAxisFlange;
  parameter Boolean animation=true "= true, if animation shall be enabled (show axis as cylinder)";
  parameter StateSelect stateSelect=StateSelect.prefer "Priority to use joint angle phi and w=der(phi) as states" annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinder representing the joint axis" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  Modelica.SIunits.AngularAcceleration a(start=0) "Second derivative of angle phi (relative angular acceleration)";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n={0,0,1} "Axis of rotation resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
  input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder representing the joint axis" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  Modelica.SIunits.Angle angle "= phi_offset + phi";
  parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinder representing the joint axis" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  Modelica.SIunits.AngularVelocity w(start=0,stateSelect=stateSelect) "First derivative of angle phi (relative angular velocity)";
  Modelica.SIunits.Torque tau "Driving torque in direction of axis of rotation";
  parameter Boolean useAxisFlange=false "= true, if axis flange is enabled" annotation(Evaluate=true,HideResult=true,choices(__Dymola_checkBox=true));
 protected
  Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalAxis(tau=tau) annotation(Placement(transformation(extent={{-10,90},{10,70}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed "support flange is fixed to ground" annotation(Placement(transformation(extent={{-70,70},{-50,90}})));
  parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(n,0.0) "Unit vector in direction of rotation axis, resolved in frame_a (= same as in frame_b)";
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape cylinder(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e,widthDirection={0,1,0},r_shape=(-e)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  Modelica.Mechanics.MultiBody.Frames.Orientation R_rel "Relative orientation object from frame_a to frame_b or from frame_b to frame_a";
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(tau_constant=0) if not useAxisFlange annotation(Placement(transformation(extent={{40,70},{20,90}})));
  outer Modelica.Mechanics.MultiBody.World world;

 // algorithms and equations of Revolute
 equation
  Connections.branch(frame_a.R,frame_b.R);
  assert(cardinality(frame_a)>0,"Connector frame_a of revolute joint is not connected");
  assert(cardinality(frame_b)>0,"Connector frame_b of revolute joint is not connected");
  angle = phi_offset+phi;
  w = der(phi);
  a = der(w);
  frame_b.r_0 = frame_a.r_0;
  if rooted(frame_a.R) then
   R_rel = Frames.planarRotation(e,phi_offset+phi,w);
   frame_b.R = Frames.absoluteRotation(frame_a.R,R_rel);
   frame_a.f = -Frames.resolve1(R_rel,frame_b.f);
   frame_a.t = -Frames.resolve1(R_rel,frame_b.t);
  else
   R_rel = Frames.planarRotation(-e,phi_offset+phi,w);
   frame_a.R = Frames.absoluteRotation(frame_b.R,R_rel);
   frame_b.f = -Frames.resolve1(R_rel,frame_a.f);
   frame_b.t = -Frames.resolve1(R_rel,frame_a.t);
  end if;
  tau = (-frame_b.t)*e;
  phi = internalAxis.phi;
  connect(fixed.flange,_famefault_support.port_b) annotation(Line(points={{-60,80},{-60,100}},color={0,0,0},smooth=Smooth.None));
  connect(internalAxis.flange,_famefault_axis.port_b) annotation(Line(points={{0,80},{0,100}},color={0,0,0},smooth=Smooth.None));
  connect(constantTorque.flange,internalAxis.flange) annotation(Line(points={{20,80},{0,80}},color={0,0,0},smooth=Smooth.None));
  connect(axis,_famefault_axis.port_a);
  connect(support,_famefault_support.port_a);

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,-60},{-30,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{30,-60},{100,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-100,59},{-30,-60}},lineColor={0,0,0}),Rectangle(extent={{30,60},{100,-60}},lineColor={0,0,0}),Text(extent={{-90,14},{-54,-11}},lineColor={128,128,128},textString="a"),Text(extent={{51,11},{87,-14}},lineColor={128,128,128},textString="b"),Line(visible=useAxisFlange,points={{-20,80},{-20,60}},color={0,0,0}),Line(visible=useAxisFlange,points={{20,80},{20,60}},color={0,0,0}),Rectangle(visible=useAxisFlange,extent={{-10,100},{10,50}},lineColor={0,0,0},fillPattern=FillPattern.VerticalCylinder,fillColor={192,192,192}),Polygon(visible=useAxisFlange,points={{-10,30},{10,30},{30,50},{-30,50},{-10,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-30,11},{30,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(visible=useAxisFlange,points={{10,30},{30,50},{30,-50},{10,-30},{10,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{-150,-110},{150,-80}},lineColor={0,0,0},textString="n=%n"),Text(visible=useAxisFlange,extent={{-150,-155},{150,-115}},textString="%name",lineColor={0,0,255}),Line(visible=useAxisFlange,points={{-20,70},{-60,70},{-60,60}},color={0,0,0},smooth=Smooth.None),Line(visible=useAxisFlange,points={{20,70},{50,70},{50,60}},color={0,0,0},smooth=Smooth.None),Line(visible=useAxisFlange,points={{-90,100},{-30,100}},color={0,0,0}),Line(visible=useAxisFlange,points={{-30,100},{-50,80}},color={0,0,0}),Line(visible=useAxisFlange,points={{-49,100},{-70,80}},color={0,0,0}),Line(visible=useAxisFlange,points={{-70,100},{-90,80}},color={0,0,0}),Text(visible=not useAxisFlange,extent={{-150,70},{150,110}},textString="%name",lineColor={0,0,255})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics),Documentation(info="<html>

<p>
Joint where frame_b rotates around axis n which is fixed in frame_a.
The two frames coincide when the rotation angle \"phi = 0\".
</p>

<p>
Optionally, two additional 1-dimensional mechanical flanges
(flange \"axis\" represents the driving flange and
flange \"support\" represents the bearing) can be enabled via
parameter <b>useAxisFlange</b>. The enabled axis flange can be
driven with elements of the
<a href=\"modelica://Modelica.Mechanics.Rotational\">Modelica.Mechanics.Rotational</a>
library.

</p>

<p>
In the \"Advanced\" menu it can be defined via parameter <b>stateSelect</b>
that the rotation angle \"phi\" and its derivative shall be definitely
used as states by setting stateSelect=StateSelect.always.
Default is StateSelect.prefer to use the joint angle and its
derivative as preferred states. The states are usually selected automatically.
In certain situations, especially when closed kinematic loops are present,
it might be slightly more efficient, when using the StateSelect.always setting.
</p>
<p>
If a <b>planar loop</b> is present, e.g., consisting of 4 revolute joints
where the joint axes are all parallel to each other, then there is no
longer a unique mathematical solution and the symbolic algorithms will
fail. Usually, an error message will be printed pointing out this
situation. In this case, one revolute joint of the loop has to be replaced
by a Joints.RevolutePlanarLoopConstraint joint. The
effect is that from the 5 constraints of a usual revolute joint,
3 constraints are removed and replaced by appropriate known
variables (e.g., the force in the direction of the axis of rotation is
treated as known with value equal to zero; for standard revolute joints,
this force is an unknown quantity).
</p>

<p>
In the following figure the animation of a revolute
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint. The black arrow is parameter
vector \"n\" defining the translation axis
(here: n = {0,0,1}, phi.start = 45<sup>o</sup>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Revolute.png\">

</html>
"));
 end Revolute;

 model RevolutePlanarLoopConstraint
  "Revolute joint that is described by 2 positional constraints for usage in a planar loop (the ambiguous cut-force perpendicular to the loop and the ambiguous cut-torques are set arbitrarily to zero)"

  import SI = Modelica.SIunits;
  import Cv = Modelica.SIunits.Conversions;
  import T = Modelica.Mechanics.MultiBody.Frames.TransformationMatrices;
  import Modelica.Mechanics.MultiBody.Types;

 // components of RevolutePlanarLoopConstraint
  Interfaces.Frame_a frame_a "Coordinate system fixed to the joint with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-116,-16},{-84,16}},rotation=0)));
  Interfaces.Frame_b frame_b "Coordinate system fixed to the joint with one cut-force and cut-torque" annotation(Placement(transformation(extent={{84,-16},{116,16}},rotation=0)));
  parameter Boolean animation=true "= true, if animation shall be enabled (show axis as cylinder)";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n={0,0,1} "Axis of rotation resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
  parameter SI.Distance cylinderLength=world.defaultJointLength "Length of cylinder representing the joint axis" annotation(Dialog(group="if animation = true",enable=animation));
  parameter SI.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinder representing the joint axis" annotation(Dialog(group="if animation = true",enable=animation));
  input Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder representing the joint axis" annotation(Dialog(group="if animation = true",enable=animation));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group="if animation = true",enable=animation));
 protected
  outer Modelica.Mechanics.MultiBody.World world;
  parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(n,0.0) "Unit vector in direction of rotation axis, resolved in frame_a (= same as in frame_b)";
  parameter Real nnx_a[3](each final unit="1")=(if abs(e[1])>0.1 then {0,1,0} else (if abs(e[2])>0.1 then {0,0,1} else {1,0,0})) "Arbitrary vector that is not aligned with rotation axis n" annotation(Evaluate=true);
  parameter Real ey_a[3](each final unit="1")=Modelica.Math.Vectors.normalize(cross(e,nnx_a),0.0) "Unit vector orthogonal to axis n of revolute joint, resolved in frame_a" annotation(Evaluate=true);
  parameter Real ex_a[3](each final unit="1")=cross(ey_a,e) "Unit vector orthogonal to axis n of revolute joint and to ey_a, resolved in frame_a" annotation(Evaluate=true);
  Real ey_b[3](each final unit="1") "ey_a, resolved in frame_b";
  Real ex_b[3](each final unit="1") "ex_a, resolved in frame_b";
  Frames.Orientation R_rel "Dummy or relative orientation object from frame_a to frame_b";
  Modelica.SIunits.Position r_rel_a[3] "Position vector from origin of frame_a to origin of frame_b, resolved in frame_a";
  SI.Force f_c[2] "Dummy or constraint forces in direction of ex_a, ey_a";
  Visualizers.Advanced.Shape cylinder(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e,widthDirection={0,1,0},r_shape=(-e)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;

 // algorithms and equations of RevolutePlanarLoopConstraint
 equation
  assert(cardinality(frame_a)>0,"Connector frame_a of revolute joint is not connected");
  assert(cardinality(frame_b)>0,"Connector frame_b of revolute joint is not connected");
  R_rel = Frames.relativeRotation(frame_a.R,frame_b.R);
  r_rel_a = Frames.resolve2(frame_a.R,frame_b.r_0-frame_a.r_0);
  0 = ex_a*r_rel_a;
  0 = ey_a*r_rel_a;
  frame_a.t = zeros(3);
  frame_b.t = zeros(3);
  frame_a.f = [ex_a, ey_a]*f_c;
  frame_b.f = -Frames.resolve2(R_rel,frame_a.f);
  ex_b = Frames.resolve2(R_rel,ex_a);
  ey_b = Frames.resolve2(R_rel,ey_a);
  assert(noEvent(((abs(e*r_rel_a)<=1.e-10) and (abs(e*ex_b)<=1.e-10)) and (abs(e*ey_b)<=1.e-10)),"
The MultiBody.Joints.RevolutePlanarLoopConstraint joint is used as cut-joint of a
planar loop. However, the revolute joint is not part of a planar loop where the
axis of the revolute joint (parameter n) is orthogonal to the possible movements.
Either use instead joint MultiBody.Joints.Revolute or correct the
definition of the axes vectors n in the revolute joints of the planar loop.
");

 annotation(defaultComponentName="revolute",Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,70},{150,100}},lineColor={0,0,0},textString="n=%n"),Text(extent={{-150,-110},{150,-70}},textString="%name",lineColor={0,0,255}),Rectangle(extent={{-20,10},{20,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,-60},{-20,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{20,-60},{100,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-100,59},{-20,-60}},lineColor={0,0,0}),Rectangle(extent={{20,60},{100,-60}},lineColor={0,0,0}),Text(extent={{-90,14},{-54,-11}},lineColor={128,128,128},textString="a"),Text(extent={{51,11},{87,-14}},lineColor={128,128,128},textString="b"),Line(points={{-91,-76},{-33,15},{30,-49},{87,61}},color={255,0,0},thickness=0.5,smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,-60},{-20,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-20,10},{20,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{20,-60},{100,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192})}),Documentation(info="<HTML>
<p>
Joint where frame_b rotates around axis n which is fixed in frame_a and
where this joint is used in a planar loop providing 2 constraint equations
on position level.
</p>

<p>
If a <b>planar loop</b> is present, e.g., consisting of 4 revolute joints
where the joint axes are all parallel to each other, then there is no
unique mathematical solution if all revolute joints are modelled with
Joints.Revolute and the symbolic algorithms will
fail. The reason is that, e.g., the cut-forces in the revolute joints perpendicular
to the planar loop are not uniquely defined when 3-dim. descriptions of revolute
joints are used. Usually, an error message will be printed pointing out this
situation. In this case, <b>one</b> revolute joint in the loop has to be replaced by
model Joints.RevolutePlanarLoopCutJoint. The
effect is that from the 5 constraints of a 3-dim. revolute joint,
3 constraints are removed and replaced by appropriate known
variables (e.g., the force in the direction of the axis of rotation is
treated as known with value equal to zero; for standard revolute joints,
this force is an unknown quantity).
</p>

</HTML>
"));
 end RevolutePlanarLoopConstraint;

 model Cylindrical
  "Cylindrical joint (2 degrees-of-freedom, 4 potential states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

  import SI = Modelica.SIunits;

 // components of Cylindrical
  parameter Boolean animation=true "= true, if animation shall be enabled (show cylinder)";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n={1,0,0} "Cylinder axis resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
  parameter SI.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinder" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter StateSelect stateSelect=StateSelect.prefer "Priority to use joint coordinates (phi, s, w, v) as states" annotation(Dialog(tab="Advanced"));
  Prismatic prismatic(n=n,animation=false,stateSelect=StateSelect.never) annotation(Placement(transformation(extent={{-70,-25},{-15,25}},rotation=0)));
  Revolute revolute(n=n,animation=false,stateSelect=StateSelect.never) annotation(Placement(transformation(extent={{10,-25},{65,25}},rotation=0)));
  SI.Position s(start=0,stateSelect=stateSelect) "Relative distance between frame_a and frame_b";
  SI.Angle phi(start=0,stateSelect=stateSelect) "Relative rotation angle from frame_a to frame_b";
  SI.Velocity v(start=0,stateSelect=stateSelect) "First derivative of s (relative velocity)";
  SI.AngularVelocity w(start=0,stateSelect=stateSelect) "First derivative of angle phi (relative angular velocity)";
  SI.Acceleration a(start=0) "Second derivative of s (relative acceleration)";
  SI.AngularAcceleration wd(start=0) "Second derivative of angle phi (relative angular acceleration)";
 protected
  Visualizers.Advanced.Shape cylinder(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=prismatic.s,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=prismatic.n,widthDirection={0,1,0},r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation annotation(Placement(transformation(extent={{-20,40},{0,60}},rotation=0)));

 // algorithms and equations of Cylindrical
 equation
  phi = revolute.phi;
  w = der(phi);
  wd = der(w);
  s = prismatic.s;
  v = der(s);
  a = der(v);
  connect(frame_a,prismatic.frame_a) annotation(Line(points={{-100,0},{-70,0}},color={95,95,95},thickness=0.5));
  connect(prismatic.frame_b,revolute.frame_a) annotation(Line(points={{-15,0},{10,0}},color={95,95,95},thickness=0.5));
  connect(revolute.frame_b,frame_b) annotation(Line(points={{65,0},{100,0}},color={95,95,95},thickness=0.5));

 annotation(Documentation(info="<HTML>
<p>
Joint where frame_b rotates around and translates along axis n
which is fixed in frame_a. The two frames coincide when
\"phi=revolute.phi=0\" and \"s=prismatic.s=0\". This joint
has the following potential states;
<ul>
<li> The relative angle phi [rad] around axis n, </li>
<li> the relative distance s [m] along axis n, </li>
<li> the relative angular velocity w [rad/s] (= der(phi))
     and </li>
<li> the relative velocity v [m/s] (= der(s)).</li>
</ul>
<p>
They are used as candidates for automatic selection of states
from the tool. This may be enforced by setting \"stateSelect=StateSelect.<b>always</b>\"
in the <b>Advanced</b> menu. The states are usually selected automatically.
In certain situations, especially when closed kinematic loops are present,
it might be slightly more efficient, when using the \"StateSelect.always\" setting.
</p>
<p>
In the following figure the animation of a cylindrical
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint. The black arrow is parameter
vector \"n\" defining the cylinder axis
(here: n = {0,0,1}).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Cylindrical.png\">
</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,-50},{0,50}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{0,-30},{100,30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{0,-50},{0,50}},color={0,0,0}),Text(extent={{-150,100},{150,60}},textString="%name",lineColor={0,0,255}),Text(extent={{-150,-65},{150,-95}},lineColor={0,0,0},textString="n=%n")}));
 end Cylindrical;

 model Universal
  "Universal joint (2 degrees-of-freedom, 4 potential states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

  import SI = Modelica.SIunits;

 // components of Universal
  parameter Boolean animation=true "= true, if animation shall be enabled";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_a={1,0,0} "Axis of revolute joint 1 resolved in frame_a" annotation(Evaluate=true);
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={0,1,0} "Axis of revolute joint 2 resolved in frame_b" annotation(Evaluate=true);
  parameter SI.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the joint axes" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the joint axes" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the joint axes" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter StateSelect stateSelect=StateSelect.prefer "Priority to use joint coordinates (phi_a, phi_b, w_a, w_b) as states" annotation(Dialog(tab="Advanced"));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute_a(n=n_a,stateSelect=StateSelect.never,cylinderDiameter=cylinderDiameter,cylinderLength=cylinderLength,cylinderColor=cylinderColor,specularCoefficient=specularCoefficient,animation=animation) annotation(Placement(transformation(extent={{-60,-25},{-10,25}},rotation=0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute_b(n=n_b,stateSelect=StateSelect.never,animation=animation,cylinderDiameter=cylinderDiameter,cylinderLength=cylinderLength,cylinderColor=cylinderColor,specularCoefficient=specularCoefficient) annotation(Placement(transformation(origin={35,45},extent={{-25,-25},{25,25}},rotation=90)));
  SI.Angle phi_a(start=0,stateSelect=stateSelect) "Relative rotation angle from frame_a to intermediate frame";
  SI.Angle phi_b(start=0,stateSelect=stateSelect) "Relative rotation angle from intermediate frame to frame_b";
  SI.AngularVelocity w_a(start=0,stateSelect=stateSelect) "First derivative of angle phi_a (relative angular velocity a)";
  SI.AngularVelocity w_b(start=0,stateSelect=stateSelect) "First derivative of angle phi_b (relative angular velocity b)";
  SI.AngularAcceleration a_a(start=0) "Second derivative of angle phi_a (relative angular acceleration a)";
  SI.AngularAcceleration a_b(start=0) "Second derivative of angle phi_b (relative angular acceleration b)";

 // algorithms and equations of Universal
 equation
  phi_a = revolute_a.phi;
  phi_b = revolute_b.phi;
  w_a = der(phi_a);
  w_b = der(phi_b);
  a_a = der(w_a);
  a_b = der(w_b);
  connect(frame_a,revolute_a.frame_a) annotation(Line(points={{-100,0},{-60,0}},color={95,95,95},thickness=0.5));
  connect(revolute_b.frame_b,frame_b) annotation(Line(points={{35,70},{35,90},{70,90},{70,0},{100,0}},color={95,95,95},thickness=0.5));
  connect(revolute_a.frame_b,revolute_b.frame_a) annotation(Line(points={{-10,0},{35,0},{35,20}},color={95,95,95},thickness=0.5));

 annotation(Documentation(info="<HTML>
<p>
Joint where frame_a rotates around axis n_a which is fixed in frame_a
and frame_b rotates around axis n_b which is fixed in frame_b.
The two frames coincide when
\"revolute_a.phi=0\" and \"revolute_b.phi=0\". This joint
has the following potential states;
<ul>
<li> The relative angle phi_a = revolute_a.phi [rad] around axis n_a, </li>
<li> the relative angle phi_b = revolute_b.phi [rad] around axis n_b, </li>
<li> the relative angular velocity w_a (= der(phi_a))  and </li>
<li> the relative angular velocity w_b (= der(phi_b)).</li>
</ul>
<p>
They are used as candidates for automatic selection of states
from the tool. This may be enforced by setting \"stateSelect=StateSelect.<b>always</b>\"
in the <b>Advanced</b> menu. The states are usually selected automatically.
In certain situations, especially when closed kinematic loops are present,
it might be slightly more efficient, when using the \"StateSelect.always\" setting.
</p>

<p>
In the following figure the animation of a universal
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint
(here: n_a = {0,0,1}, n_b = {0,1,0}, phi_a.start = 90<sup>o</sup>,
phi_b.start = 45<sup>o</sup>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Universal.png\">
</HTML>"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,15},{-65,-15}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={235,235,235}),Ellipse(extent={{-80,-80},{80,80}},lineColor={160,160,164},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-60,-60},{60,60}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-150,-80},{150,-120}},textString="%name",lineColor={0,0,255}),Rectangle(extent={{12,82},{80,-82}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{56,15},{100,-15}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={235,235,235}),Line(points={{12,78},{12,-78}},color={0,0,0},thickness=0.5),Ellipse(extent={{-52,-40},{80,40}},lineColor={160,160,164},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-32,-20},{60,26}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-22,-54},{-60,0},{-22,50},{40,52},{-22,-54}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{12,78},{12,-20}},color={0,0,0},thickness=0.5),Line(points={{32,38},{-12,-36}},color={0,0,0},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics));
 end Universal;

 model Planar
  "Planar joint (3 degrees-of-freedom, 6 potential states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

  import SI = Modelica.SIunits;

 // components of Planar
  parameter Boolean animation=true "= true, if animation shall be enabled";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n={0,0,1} "Axis orthogonal to unconstrained plane, resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_x={1,0,0} "Vector in direction of x-axis of plane, resolved in frame_a (n_x shall be orthogonal to n)" annotation(Evaluate=true);
  parameter SI.Distance cylinderLength=world.defaultJointLength "Length of revolute cylinder" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance cylinderDiameter=world.defaultJointWidth "Diameter of revolute cylinder" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of revolute cylinder" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance boxWidth=0.3*cylinderDiameter "Width of prismatic joint boxes" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance boxHeight=boxWidth "Height of prismatic joint boxes" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color boxColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of prismatic joint boxes" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter StateSelect stateSelect=StateSelect.prefer "Priority to use joint coordinates (s_x, s_y, phi, v_x, v_y, w) as states" annotation(Dialog(tab="Advanced"));
  Prismatic prismatic_x(stateSelect=StateSelect.never,n=cross(cross(n,n_x),n),animation=false) annotation(Placement(transformation(extent={{-69,-20},{-29,20}},rotation=0)));
  Prismatic prismatic_y(stateSelect=StateSelect.never,n=cross(n,n_x),animation=false) annotation(Placement(transformation(origin={0,50},extent={{-20,-20},{20,20}},rotation=90)));
  Revolute revolute(stateSelect=StateSelect.never,n=n,animation=false) annotation(Placement(transformation(extent={{41,-20},{81,20}},rotation=0)));
  SI.Position s_x(start=0,stateSelect=stateSelect) "Relative distance along first prismatic joint starting at frame_a";
  SI.Position s_y(start=0,stateSelect=stateSelect) "Relative distance along second prismatic joint starting at first prismatic joint";
  SI.Angle phi(start=0,stateSelect=stateSelect) "Relative rotation angle from frame_a to frame_b";
  SI.Velocity v_x(start=0,stateSelect=stateSelect) "First derivative of s_x (relative velocity in s_x direction)";
  SI.Velocity v_y(start=0,stateSelect=stateSelect) "First derivative of s_y (relative velocity in s_y direction)";
  SI.AngularVelocity w(start=0,stateSelect=stateSelect) "First derivative of angle phi (relative angular velocity)";
  SI.Acceleration a_x(start=0) "Second derivative of s_x (relative acceleration in s_x direction)";
  SI.Acceleration a_y(start=0) "Second derivative of s_y (relative acceleration in s_y direction)";
  SI.AngularAcceleration wd(start=0) "Second derivative of angle phi (relative angular acceleration)";
 protected
  parameter Integer ndim=(if world.enableAnimation and animation then 1 else 0);
  parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(n);
  Visualizers.Advanced.Shape box_x[ndim](each shapeType="box",each color=boxColor,each length=prismatic_x.s,each width=boxWidth,each height=boxWidth,each lengthDirection=prismatic_x.e,each widthDirection={0,1,0},each r=frame_a.r_0,each R=frame_a.R) annotation(Placement(transformation(extent={{-80,30},{-60,50}},rotation=0)));
  Visualizers.Advanced.Shape box_y[ndim](each shapeType="box",each color=boxColor,each length=prismatic_y.s,each width=boxWidth,each height=boxWidth,each lengthDirection=prismatic_y.e,each widthDirection={1,0,0},each r=prismatic_y.frame_a.r_0,each R=prismatic_y.frame_a.R) annotation(Placement(transformation(extent={{-46,69},{-26,89}},rotation=0)));
  Visualizers.Advanced.Shape cylinder[ndim](each shapeType="cylinder",each color=cylinderColor,each length=cylinderLength,each width=cylinderDiameter,each height=cylinderDiameter,each lengthDirection=n,each widthDirection={0,1,0},each r_shape=(-e)*cylinderLength/(2),each r=revolute.frame_b.r_0,each R=revolute.frame_b.R) annotation(Placement(transformation(extent={{50,30},{70,50}},rotation=0)));

 // algorithms and equations of Planar
 equation
  s_x = prismatic_x.s;
  s_y = prismatic_y.s;
  phi = revolute.phi;
  v_x = der(s_x);
  v_y = der(s_y);
  w = der(phi);
  a_x = der(v_x);
  a_y = der(v_y);
  wd = der(w);
  connect(frame_a,prismatic_x.frame_a) annotation(Line(points={{-100,0},{-69,0}},color={95,95,95},thickness=0.5));
  connect(prismatic_x.frame_b,prismatic_y.frame_a) annotation(Line(points={{-29,0},{-1.22465e-015,0},{-1.22465e-015,30}},color={95,95,95},thickness=0.5));
  connect(prismatic_y.frame_b,revolute.frame_a) annotation(Line(points={{1.22465e-015,70},{0,80},{30,80},{30,0},{41,0}},color={95,95,95},thickness=0.5));
  connect(revolute.frame_b,frame_b) annotation(Line(points={{81,0},{100,0}},color={95,95,95},thickness=0.5));

 annotation(Documentation(info="<HTML>
<p>
Joint where frame_b can move in a plane and can rotate around an
axis orthogonal to the plane. The plane is defined by
vector n which is perpendicular to the plane and by vector n_x,
which points in the direction of the x-axis of the plane.
frame_a and frame_b coincide when s_x=prismatic_x.s=0,
s_y=prismatic_y.s=0 and phi=revolute.phi=0. This joint has the following
potential states:
<ul>
<li> the relative distance s_x = prismatic_x.s [m] along axis n_x, </li>
<li> the relative distance s_y = prismatic_y.s [m] along axis n_y = cross(n,n_x), </li>
<li> the relative angle phi = revolute.phi [rad] around axis n, </li>
<li> the relative velocity v_x (= der(s_x)).</li>
<li> the relative velocity v_y (= der(s_y)).</li>
<li> the relative angular velocity w (= der(phi))</li>
</ul>
<p>
They are used as candidates for automatic selection of states
from the tool. This may be enforced by setting \"stateSelect=StateSelect.<b>always</b>\"
in the <b>Advanced</b> menu. The states are usually selected automatically.
In certain situations, especially when closed kinematic loops are present,
it might be slightly more efficient, when using the \"StateSelect.always\" setting.
</p>
<p>
In the following figure the animation of a planar
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint. The black arrows are parameter
vectors \"n\" and \"n_x\"
(here: n = {0,1,0}, n_x = {0,0,1}, s_x.start = 0.5,
s_y.start = 0.5, phi.start = 45<sup>o</sup>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Planar.png\">
</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-30,-60},{-10,60}},lineColor={0,0,0},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{10,-60},{30,60}},lineColor={0,0,0},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,-10},{-30,10}},lineColor={0,0,0},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{100,-10},{30,10}},lineColor={0,0,0},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{-150,-75},{150,-105}},lineColor={0,0,0},textString="n=%n"),Text(extent={{-150,110},{150,70}},textString="%name",lineColor={0,0,255})}));
 end Planar;

 model Spherical
  "Spherical joint (3 constraints and no potential states, or 3 degrees-of-freedom and 3 states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

  import Modelica.Mechanics.MultiBody.Frames;
  import SI = Modelica.SIunits;

 // components of Spherical
  parameter Boolean animation=true "= true, if animation shall be enabled (show sphere)";
  parameter SI.Distance sphereDiameter=world.defaultJointLength "Diameter of sphere representing the spherical joint" annotation(Dialog(group="if animation = true",enable=animation));
  input Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of sphere representing the spherical joint" annotation(Dialog(group="if animation = true",enable=animation));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group="if animation = true",enable=animation));
  parameter Boolean angles_fixed=false "= true, if angles_start are used as initial values, else as guess values" annotation(Evaluate=true,choices(__Dymola_checkBox=true),Dialog(tab="Initialization"));
  parameter SI.Angle angles_start[3]={0,0,0} "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b" annotation(Dialog(tab="Initialization"));
  parameter Types.RotationSequence sequence_start={1,2,3} "Sequence of rotations to rotate frame_a into frame_b at initial time" annotation(Evaluate=true,Dialog(tab="Initialization"));
  parameter Boolean w_rel_a_fixed=false "= true, if w_rel_a_start are used as initial values, else as guess values" annotation(Evaluate=true,choices(__Dymola_checkBox=true),Dialog(tab="Initialization"));
  parameter SI.AngularVelocity w_rel_a_start[3]={0,0,0} "Initial values of angular velocity of frame_b with respect to frame_a, resolved in frame_a" annotation(Dialog(tab="Initialization"));
  parameter Boolean z_rel_a_fixed=false "= true, if z_rel_a_start are used as initial values, else as guess values" annotation(Evaluate=true,choices(__Dymola_checkBox=true),Dialog(tab="Initialization"));
  parameter SI.AngularAcceleration z_rel_a_start[3]={0,0,0} "Initial values of angular acceleration z_rel_a = der(w_rel_a)" annotation(Dialog(tab="Initialization"));
  parameter Boolean enforceStates=false " = true, if relative variables of spherical joint shall be used as states (StateSelect.always)" annotation(Dialog(tab="Advanced"));
  parameter Boolean useQuaternions=true " = true, if quaternions shall be used as states otherwise use 3 angles as states (provided enforceStates=true)" annotation(Dialog(tab="Advanced",enable=enforceStates));
  parameter Types.RotationSequence sequence_angleStates={1,2,3} " Sequence of rotations to rotate frame_a into frame_b around the 3 angles used as states" annotation(Evaluate=true,Dialog(tab="Advanced",enable=enforceStates and not useQuaternions));
  final parameter Frames.Orientation R_rel_start=Frames.axesRotations(sequence_start,angles_start,zeros(3)) "Orientation object from frame_a to frame_b at initial time";
 protected
  Visualizers.Advanced.Shape sphere(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection={1,0,0},widthDirection={0,1,0},r_shape={-0.5,0,0}*sphereDiameter,r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  parameter Frames.Quaternions.Orientation Q_start=Modelica.Mechanics.MultiBody.Frames.to_Q(R_rel_start) "Quaternion orientation object from frame_a to frame_b at initial time";
  Frames.Quaternions.Orientation Q(start=Q_start,each stateSelect=(if enforceStates and useQuaternions then StateSelect.prefer else StateSelect.never)) "Quaternion orientation object from frame_a to frame_b (dummy value, if quaternions are not used as states)";
  parameter SI.Angle phi_start[3]=(if ((sequence_start[1]==sequence_angleStates[1]) and (sequence_start[2]==sequence_angleStates[2])) and (sequence_start[3]==sequence_angleStates[3]) then angles_start else Frames.axesRotationsAngles(R_rel_start,sequence_angleStates)) "Potential angle states at initial time";
  SI.Angle phi[3](start=phi_start,each stateSelect=(if enforceStates and not useQuaternions then StateSelect.always else StateSelect.never)) "Dummy or 3 angles to rotate frame_a into frame_b";
  SI.AngularVelocity phi_d[3](each stateSelect=(if enforceStates and not useQuaternions then StateSelect.always else StateSelect.never)) "= der(phi)";
  SI.AngularAcceleration phi_dd[3] "= der(phi_d)";
  SI.AngularVelocity w_rel[3](start=Frames.resolve2(R_rel_start,w_rel_a_start),fixed=fill(w_rel_a_fixed,3),each stateSelect=(if enforceStates and useQuaternions then StateSelect.always else StateSelect.never)) "Dummy or relative angular velocity of frame_b with respect to frame_a, resolved in frame_b";
  Frames.Orientation R_rel "Dummy or relative orientation object to rotate from frame_a to frame_b";
  Frames.Orientation R_rel_inv "Dummy or relative orientation object to rotate from frame_b to frame_a";

 // algorithms and equations of Spherical
 initial equation
  if angles_fixed then
   if not enforceStates then
    zeros(3) = Frames.Orientation.equalityConstraint(Frames.absoluteRotation(frame_a.R,R_rel_start),frame_b.R);
   elseif useQuaternions then
    zeros(3) = Frames.Quaternions.Orientation.equalityConstraint(Q,Q_start);
   else
    phi = phi_start;
   end if;
  end if;
  if z_rel_a_fixed then
   der(w_rel) = Frames.resolve2(R_rel_start,z_rel_a_start);
  end if;
 equation
  zeros(3) = frame_a.t;
  zeros(3) = frame_b.t;
  if enforceStates then
   Connections.branch(frame_a.R,frame_b.R);
   frame_b.r_0 = frame_a.r_0;
   if rooted(frame_a.R) then
    R_rel_inv = Frames.nullRotation();
    frame_b.R = Frames.absoluteRotation(frame_a.R,R_rel);
    zeros(3) = frame_a.f+Frames.resolve1(R_rel,frame_b.f);
   else
    R_rel_inv = Frames.inverseRotation(R_rel);
    frame_a.R = Frames.absoluteRotation(frame_b.R,R_rel_inv);
    zeros(3) = frame_b.f+Frames.resolve2(R_rel,frame_a.f);
   end if;
   if useQuaternions then
    {0} = Frames.Quaternions.orientationConstraint(Q);
    w_rel = Frames.Quaternions.angularVelocity2(Q,der(Q));
    R_rel = Frames.from_Q(Q,w_rel);
    phi = zeros(3);
    phi_d = zeros(3);
    phi_dd = zeros(3);
   else
    phi_d = der(phi);
    phi_dd = der(phi_d);
    R_rel = Frames.axesRotations(sequence_angleStates,phi,phi_d);
    w_rel = Frames.angularVelocity2(R_rel);
    Q = zeros(4);
   end if;
  else
   frame_b.r_0 = frame_a.r_0;
   zeros(3) = frame_a.f+Frames.resolveRelative(frame_b.f,frame_b.R,frame_a.R);
   if w_rel_a_fixed or z_rel_a_fixed then
    w_rel = Frames.angularVelocity2(frame_b.R)-Frames.resolve2(frame_b.R,Frames.angularVelocity1(frame_a.R));
   else
    w_rel = zeros(3);
   end if;
   R_rel = Frames.nullRotation();
   R_rel_inv = Frames.nullRotation();
   Q = zeros(4);
   phi = zeros(3);
   phi_d = zeros(3);
   phi_dd = zeros(3);
  end if;

 annotation(Documentation(info="<html>
<p>
Joint with <b>3 constraints</b> that define that the origin of
frame_a and the origin of frame_b coincide. By default this joint
defines only the 3 constraints without any potential states.
If parameter <b>enforceStates</b> is set to <b>true</b>
in the \"Advanced\" menu, three states are introduced.
Depending on parameter <b>useQuaternions</b> these are either
quaternions and the relative angular velocity or 3 angles
and the angle derivatves. In the latter case the orientation
of frame_b is computed by rotating frame_a along the axes defined
in parameter vector \"sequence_angleStates\" (default = {1,2,3}, i.e.,
the Cardan angle sequence) around the angles used as states.
For example, the default is to rotate the x-axis of frame_a
around angles[1], the new y-axis around angles[2] and the new z-axis
around angles[3], arriving at frame_b. If angles are used
as states there is the slight disadvantage that
a singular configuration is present leading to a divison by zero.
</p>
<p>
If this joint is used in a <b>chain</b> structure, a Modelica translator
has to select orientation coordinates of a body as states, if the
default setting is used. It is usually better to use relative coordinates
in the spherical joint as states, and therefore in this situation
parameter enforceStates might be set to <b>true</b>.
</p>
<p>
If this joint is used in a <b>loop</b> structure, the default
setting results in a <b>cut-joint</b> that
breaks the loop in independent kinematic pieces, hold together
by the constraints of this joint. As a result, a Modelica translator
will first try to select 3 generalized coordinates in the joints of
the remaining parts of the loop and their first derivative as states
and if this is not possible, e.g., because there are only spherical
joints in the loop, will select coordinates from a body of the loop
as states.
</p>
<p>
In the following figure the animation of a spherical
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint.
(here: angles_start = {45, 45, 45}<sup>o</sup>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Spherical.png\">
</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Ellipse(extent={{-70,-70},{70,70}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-49,-50},{51,50}},lineColor={128,128,128},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{30,70},{71,-68}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,10},{-68,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{23,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Ellipse(extent={{-24,25},{26,-25}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={160,160,164}),Text(extent={{-150,-115},{150,-75}},textString="%name",lineColor={0,0,255})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Ellipse(extent={{-70,-70},{70,70}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-49,-50},{51,50}},lineColor={128,128,128},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{30,70},{71,-68}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,10},{-68,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{23,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Ellipse(extent={{-24,25},{26,-25}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={160,160,164})}));
 end Spherical;

 model FreeMotion
  "Free motion joint (6 degrees-of-freedom, 12 potential states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

  import Modelica.Math.*;
  import SI = Modelica.SIunits;

 // components of FreeMotion
  parameter Boolean animation=true "= true, if animation shall be enabled (show arrow from frame_a to frame_b)";
  SI.Position r_rel_a[3](start={0,0,0},each stateSelect=(if enforceStates then StateSelect.always else StateSelect.prefer)) "Position vector from origin of frame_a to origin of frame_b, resolved in frame_a" annotation(Dialog(group="Initialization",showStartAttribute=true));
  SI.Velocity v_rel_a[3](start={0,0,0},each stateSelect=(if enforceStates then StateSelect.always else StateSelect.prefer)) "= der(r_rel_a), i.e., velocity of origin of frame_b with respect to origin of frame_a, resolved in frame_a" annotation(Dialog(group="Initialization",showStartAttribute=true));
  SI.Acceleration a_rel_a[3](start={0,0,0}) "= der(v_rel_a)" annotation(Dialog(group="Initialization",showStartAttribute=true));
  parameter Boolean angles_fixed=false "= true, if angles_start are used as initial values, else as guess values" annotation(Evaluate=true,choices(__Dymola_checkBox=true),Dialog(group="Initialization"));
  parameter SI.Angle angles_start[3]={0,0,0} "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b" annotation(Dialog(group="Initialization"));
  parameter Types.RotationSequence sequence_start={1,2,3} "Sequence of rotations to rotate frame_a into frame_b at initial time" annotation(Evaluate=true,Dialog(group="Initialization"));
  parameter Boolean w_rel_a_fixed=false "= true, if w_rel_a_start are used as initial values, else as guess values" annotation(Evaluate=true,choices(__Dymola_checkBox=true),Dialog(group="Initialization"));
  parameter SI.AngularVelocity w_rel_a_start[3]={0,0,0} "Initial values of angular velocity of frame_b with respect to frame_a, resolved in frame_a" annotation(Dialog(group="Initialization"));
  parameter Boolean z_rel_a_fixed=false "= true, if z_rel_a_start are used as initial values, else as guess values" annotation(Evaluate=true,choices(__Dymola_checkBox=true),Dialog(group="Initialization"));
  parameter SI.AngularAcceleration z_rel_a_start[3]={0,0,0} "Initial values of angular acceleration z_rel_a = der(w_rel_a)" annotation(Dialog(group="Initialization"));
  parameter SI.Length arrowDiameter=world.defaultArrowDiameter "Diameter of arrow from frame_a to frame_b" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color arrowColor=Modelica.Mechanics.MultiBody.Types.Defaults.SensorColor "Color of arrow" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter Boolean enforceStates=true " = true, if relative variables between frame_a and frame_b shall be used as states" annotation(Dialog(tab="Advanced"));
  parameter Boolean useQuaternions=true " = true, if quaternions shall be used as states otherwise use 3 angles as states" annotation(Dialog(tab="Advanced"));
  parameter Types.RotationSequence sequence_angleStates={1,2,3} " Sequence of rotations to rotate frame_a into frame_b around the 3 angles used as states" annotation(Evaluate=true,Dialog(tab="Advanced",enable=not useQuaternions));
  final parameter Frames.Orientation R_rel_start=Modelica.Mechanics.MultiBody.Frames.axesRotations(sequence_start,angles_start,zeros(3)) "Orientation object from frame_a to frame_b at initial time";
 protected
  Visualizers.Advanced.Arrow arrow(r_head=r_rel_a,diameter=arrowDiameter,color=arrowColor,specularCoefficient=specularCoefficient,r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  parameter Frames.Quaternions.Orientation Q_start=Frames.to_Q(R_rel_start) "Quaternion orientation object from frame_a to frame_b at initial time";
  Frames.Quaternions.Orientation Q(start=Q_start,each stateSelect=(if enforceStates then (if useQuaternions then StateSelect.prefer else StateSelect.never) else StateSelect.default)) "Quaternion orientation object from frame_a to frame_b (dummy value, if quaternions are not used as states)";
  parameter SI.Angle phi_start[3]=(if ((sequence_start[1]==sequence_angleStates[1]) and (sequence_start[2]==sequence_angleStates[2])) and (sequence_start[3]==sequence_angleStates[3]) then angles_start else Frames.axesRotationsAngles(R_rel_start,sequence_angleStates)) "Potential angle states at initial time";
  SI.Angle phi[3](start=phi_start,each stateSelect=(if enforceStates then (if useQuaternions then StateSelect.never else StateSelect.always) else StateSelect.prefer)) "Dummy or 3 angles to rotate frame_a into frame_b";
  SI.AngularVelocity phi_d[3](each stateSelect=(if enforceStates then (if useQuaternions then StateSelect.never else StateSelect.always) else StateSelect.prefer)) "= der(phi)";
  SI.AngularAcceleration phi_dd[3] "= der(phi_d)";
  SI.AngularVelocity w_rel_b[3](start=Frames.resolve2(R_rel_start,w_rel_a_start),fixed=fill(w_rel_a_fixed,3),each stateSelect=(if enforceStates then (if useQuaternions then StateSelect.always else StateSelect.avoid) else StateSelect.prefer)) "Dummy or relative angular velocity of frame_b with respect to frame_a, resolved in frame_b";
  Frames.Orientation R_rel "Dummy or relative orientation object to rotate from frame_a to frame_b";
  Frames.Orientation R_rel_inv "Dummy or relative orientation object to rotate from frame_b to frame_a";

 // algorithms and equations of FreeMotion
 initial equation
  if angles_fixed then
   if not enforceStates then
    zeros(3) = Frames.Orientation.equalityConstraint(Frames.absoluteRotation(frame_a.R,R_rel_start),frame_b.R);
   elseif useQuaternions then
    zeros(3) = Frames.Quaternions.Orientation.equalityConstraint(Q,Q_start);
   else
    phi = phi_start;
   end if;
  end if;
  if z_rel_a_fixed then
   der(w_rel_b) = Frames.resolve2(R_rel_start,z_rel_a_start);
  end if;
 equation
  der(r_rel_a) = v_rel_a;
  der(v_rel_a) = a_rel_a;
  frame_b.r_0 = frame_a.r_0+Frames.resolve1(frame_a.R,r_rel_a);
  frame_a.f = zeros(3);
  frame_a.t = zeros(3);
  frame_b.f = zeros(3);
  frame_b.t = zeros(3);
  if enforceStates then
   Connections.branch(frame_a.R,frame_b.R);
   if rooted(frame_a.R) then
    R_rel_inv = Frames.nullRotation();
    frame_b.R = Frames.absoluteRotation(frame_a.R,R_rel);
   else
    R_rel_inv = Frames.inverseRotation(R_rel);
    frame_a.R = Frames.absoluteRotation(frame_b.R,R_rel_inv);
   end if;
   if useQuaternions then
    {0} = Frames.Quaternions.orientationConstraint(Q);
    w_rel_b = Frames.Quaternions.angularVelocity2(Q,der(Q));
    R_rel = Frames.from_Q(Q,w_rel_b);
    phi = zeros(3);
    phi_d = zeros(3);
    phi_dd = zeros(3);
   else
    phi_d = der(phi);
    phi_dd = der(phi_d);
    R_rel = Frames.axesRotations(sequence_angleStates,phi,phi_d);
    w_rel_b = Frames.angularVelocity2(R_rel);
    Q = zeros(4);
   end if;
  else
   if w_rel_a_fixed or z_rel_a_fixed then
    w_rel_b = Frames.angularVelocity2(frame_b.R)-Frames.resolve2(frame_b.R,Frames.angularVelocity1(frame_a.R));
   else
    w_rel_b = zeros(3);
   end if;
   R_rel = Frames.nullRotation();
   R_rel_inv = Frames.nullRotation();
   Q = zeros(4);
   phi = zeros(3);
   phi_d = zeros(3);
   phi_dd = zeros(3);
  end if;

 annotation(Documentation(info="<HTML>
<p>
Joint which does not constrain the motion between frame_a and frame_b.
Such a joint is only meaningful if the <b>relative</b> distance and orientation
between frame_a and frame_b, and their derivatives, shall be used
as <b>states</b>.
</p>
<p>
Note, that <b>bodies</b> such as Parts.Body, Parts.BodyShape,
have potential states describing the distance
and orientation, and their derivatives, between the <b>world frame</b> and
a <b>body fixed frame</b>.
Therefore, if these potential state variables are suited,
a FreeMotion joint is not needed.
</p>
The states of the FreeMotion object are:
</p>
<ul>
<li> The <b>relative position vector</b> r_rel_a from the origin of
     frame_a to the origin of frame_b, resolved in
     frame_a and the <b>relative velocity</b> v_rel_a of the origin of
     frame_b with respect to the origin of frame_a, resolved in frame_a
     (= der(r_rel_a)).
</li>
<li> If parameter <b>useQuaternions</b> in the \"Advanced\" menu
     is <b>true</b> (this is the default), then <b>4 quaternions</b>
     are states. Additionally, the coordinates of the
     relative angular velocity vector are 3 potential states.<br>
     If <b>useQuaternions</b> in the \"Advanced\" menu
     is <b>false</b>, then <b>3 angles</b> and the derivatives of
     these angles are potential states. The orientation of frame_b
     is computed by rotating frame_a along the axes defined
     in parameter vector \"sequence_angleStates\" (default = {1,2,3}, i.e.,
     the Cardan angle sequence) around the angles used as states.
     For example, the default is to rotate the x-axis of frame_a
     around angles[1], the new y-axis around angles[2] and the new z-axis
     around angles[3], arriving at frame_b.
 </li>
</ul>
<p>
The quaternions have the slight disadvantage that there is a
non-linear constraint equation between the 4 quaternions.
Therefore, at least one non-linear equation has to be solved
during simulation. A tool might, however, analytically solve this
simple constraint equation. Using the 3 angles as states has the
disadvantage that there is a singular configuration in which a
division by zero will occur. If it is possible to determine in advance
for an application class that this singular configuration is outside
of the operating region, the 3 angles might be used as
states by setting <b>useQuaternions</b> = <b>false</b>.
</p>
<p>
In text books about 3-dimensional mechanics often 3 angles and the
angular velocity are used as states. This is not the case here, since
3 angles and their derivatives are used as states
(if useQuaternions = false). The reason
is that for real-time simulation the discretization formula of the
integrator might be \"inlined\" and solved together with the model equations.
By appropriate symbolic transformation the performance is
drastically increased if angles and their
derivatives are used as states, instead of angles and the angular
velocity.
</p>
<p>
If parameter
<b>enforceStates</b> is set to <b>true</b> (= the default)
in the \"Advanced\" menu,
then FreeMotion variables are forced to be used as states according
to the setting of parameters \"useQuaternions\" and
\"sequence_angleStates\".
</p>
<p>
In the following figure the animation of a FreeMotion
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint.
(here: r_rel_a_start = {0.5, 0, 0.5}, angles_start = {45, 45, 45}<sup>o</sup>).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/FreeMotion.png\">
</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-86,31},{-74,61},{-49,83},{-17,92},{19,88},{40,69},{59,48}},color={160,160,164},thickness=0.5),Polygon(points={{90,0},{50,20},{50,-20},{90,0}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(points={{69,58},{49,40},{77,28},{69,58}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{150,-35},{-150,-75}},lineColor={0,0,255},textString="%name"),Rectangle(extent={{-70,-5},{-90,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{50,-5},{30,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{11,-5},{-9,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-30,-5},{-50,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-86,31},{-74,61},{-49,83},{-17,92},{19,88},{40,69},{59,48}},color={160,160,164},thickness=0.5),Polygon(points={{90,0},{50,20},{50,-20},{90,0}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(points={{69,58},{49,40},{77,28},{69,58}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{50,-5},{30,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{11,-5},{-9,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-30,-5},{-50,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-70,-5},{-90,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid)}));
 end FreeMotion;

 model FreeMotionScalarInit
  "Free motion joint with scalar initialization and state selection (6 degrees-of-freedom, 12 potential states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

  import Modelica.Math.*;
  import SI = Modelica.SIunits;

 // locally defined classes in FreeMotionScalarInit

 // components of FreeMotionScalarInit
  parameter Boolean animation=true "= true, if animation shall be enabled (show arrow from frame_a to frame_b)" annotation(Dialog(enable=use_r));
  parameter Boolean use_r=false "= true, if r_rel_a shall be used" annotation(HideResult=true,Dialog(tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a"));
  SI.Position r_rel_a_1(start=0,final stateSelect=r_rel_a_1_stateSelect)=model_r.r_rel_a_1 if use_r "Relative distance r_rel_a[1]" annotation(Dialog(enable=use_r,tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Position r_rel_a_2(start=0,final stateSelect=r_rel_a_2_stateSelect)=model_r.r_rel_a_2 if use_r "Relative distance r_rel_a[2]" annotation(Dialog(enable=use_r,tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Position r_rel_a_3(start=0,final stateSelect=r_rel_a_3_stateSelect)=model_r.r_rel_a_3 if use_r "Relative distance r_rel_a[3]" annotation(Dialog(enable=use_r,tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter StateSelect r_rel_a_1_stateSelect=StateSelect.never "StateSelect of r_rel_a[1]" annotation(HideResult=true,Dialog(enable=use_r,tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a"));
  parameter StateSelect r_rel_a_2_stateSelect=StateSelect.never "StateSelect of r_rel_a[2]" annotation(HideResult=true,Dialog(enable=use_r,tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a"));
  parameter StateSelect r_rel_a_3_stateSelect=StateSelect.never "StateSelect of r_rel_a[3]" annotation(HideResult=true,Dialog(enable=use_r,tab="Translational Initialization",group="Position vector r_rel_a from origin of frame_a to origin of frame_b, resolved in frame_a"));
  parameter Boolean use_v=false "= true, if v_rel_a shall be used" annotation(HideResult=true,Dialog(enable=use_r,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)"));
  SI.Velocity v_rel_a_1(start=0,final stateSelect=v_rel_a_1_stateSelect)=der(r_rel_a_1) if use_r and use_v "Relative velocity v_rel_a[1]" annotation(Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Velocity v_rel_a_2(start=0,final stateSelect=v_rel_a_2_stateSelect)=der(r_rel_a_2) if use_r and use_v "Relative velocity v_rel_a[2]" annotation(Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Velocity v_rel_a_3(start=0,final stateSelect=v_rel_a_3_stateSelect)=der(r_rel_a_3) if use_r and use_v "Relative velocity v_rel_a[3]" annotation(Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter StateSelect v_rel_a_1_stateSelect=StateSelect.never "StateSelect of v_rel_a[1]" annotation(HideResult=true,Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)"));
  parameter StateSelect v_rel_a_2_stateSelect=StateSelect.never "StateSelect of v_rel_a[2]" annotation(HideResult=true,Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)"));
  parameter StateSelect v_rel_a_3_stateSelect=StateSelect.never "StateSelect of v_rel_a[3]" annotation(HideResult=true,Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Velocity vector v_rel_a = der(r_rel_a)"));
  parameter Boolean use_a=false "= true, if a_rel_a shall be used" annotation(HideResult=true,Dialog(enable=use_r and use_v,tab="Translational Initialization",group="Acceleration vector a_rel_a = der(v_rel_a)"));
  SI.Acceleration a_rel_a_1(start=0)=der(v_rel_a_1) if (use_r and use_v) and use_a "Relative acceleration a_rel_a[1]" annotation(Dialog(enable=(use_r and use_v) and use_a,tab="Translational Initialization",group="Acceleration vector a_rel_a = der(v_rel_a)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Acceleration a_rel_a_2(start=0)=der(v_rel_a_2) if (use_r and use_v) and use_a "Relative acceleration a_rel_a[2]" annotation(Dialog(enable=(use_r and use_v) and use_a,tab="Translational Initialization",group="Acceleration vector a_rel_a = der(v_rel_a)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Acceleration a_rel_a_3(start=0)=der(v_rel_a_3) if (use_r and use_v) and use_a "Relative acceleration a_rel_a[3]" annotation(Dialog(enable=(use_r and use_v) and use_a,tab="Translational Initialization",group="Acceleration vector a_rel_a = der(v_rel_a)",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter Boolean use_angle=false "= true, if angle shall be used" annotation(HideResult=true,Dialog(tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start"));
  parameter Types.RotationSequence sequence_start={1,2,3} "Sequence of angle rotations" annotation(Evaluate=true,Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start"));
  SI.Angle angle_1(start=0,stateSelect=angle_1_stateSelect) "First rotation angle or dummy" annotation(Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Angle angle_2(start=0,stateSelect=angle_2_stateSelect) "Second rotation angle or dummy" annotation(Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.Angle angle_3(start=0,stateSelect=angle_3_stateSelect) "Third rotation angle or dummy" annotation(Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter StateSelect angle_1_stateSelect=StateSelect.never "StateSelect of angle_1" annotation(HideResult=true,Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start"));
  parameter StateSelect angle_2_stateSelect=StateSelect.never "StateSelect of angle_2" annotation(HideResult=true,Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start"));
  parameter StateSelect angle_3_stateSelect=StateSelect.never "StateSelect of angle_3" annotation(HideResult=true,Dialog(enable=use_angle,tab="Angle Initialization",group="Angles to rotate frame_a to frame_b along sequence_start"));
  parameter Boolean use_angle_d=false "= true, if angle_d shall be used" annotation(HideResult=true,Dialog(enable=use_angle,tab="Angle Initialization",group="angle_d = der(angle)"));
  SI.AngularVelocity angle_d_1(start=0,final stateSelect=angle_d_1_stateSelect)=der(angle_1) if use_angle and use_angle_d "= der(angle_1)" annotation(Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_d = der(angle)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularVelocity angle_d_2(start=0,final stateSelect=angle_d_2_stateSelect)=der(angle_2) if use_angle and use_angle_d "= der(angle_2)" annotation(Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_d = der(angle)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularVelocity angle_d_3(start=0,final stateSelect=angle_d_3_stateSelect)=der(angle_3) if use_angle and use_angle_d "= der(angle_3)" annotation(Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_d = der(angle)",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter StateSelect angle_d_1_stateSelect=StateSelect.never "StateSelect of angle_d_1" annotation(HideResult=true,Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_d = der(angle)"));
  parameter StateSelect angle_d_2_stateSelect=StateSelect.never "StateSelect of angle_d_2" annotation(HideResult=true,Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_d = der(angle)"));
  parameter StateSelect angle_d_3_stateSelect=StateSelect.never "StateSelect of angle_d_3" annotation(HideResult=true,Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_d = der(angle)"));
  parameter Boolean use_angle_dd=false "= true, if angle_dd shall be used" annotation(HideResult=true,Dialog(enable=use_angle and use_angle_d,tab="Angle Initialization",group="angle_dd = der(angle_d)"));
  SI.AngularAcceleration angle_dd_1(start=0)=der(angle_d_1) if (use_angle and use_angle_d) and use_angle_dd "= der(angle_d_1)" annotation(Dialog(enable=(use_angle and use_angle_d) and use_angle_dd,tab="Angle Initialization",group="angle_dd = der(angle_d)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularAcceleration angle_dd_2(start=0)=der(angle_d_2) if (use_angle and use_angle_d) and use_angle_dd "= der(angle_d_2)" annotation(Dialog(enable=(use_angle and use_angle_d) and use_angle_dd,tab="Angle Initialization",group="angle_dd = der(angle_d)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularAcceleration angle_dd_3(start=0)=der(angle_d_3) if (use_angle and use_angle_d) and use_angle_dd "= der(angle_d_3)" annotation(Dialog(enable=(use_angle and use_angle_d) and use_angle_dd,tab="Angle Initialization",group="angle_dd = der(angle_d)",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter Boolean use_w=false "= true, if w_rel_b shall be used" annotation(HideResult=true,Dialog(tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b"));
  SI.AngularVelocity w_rel_b_1(start=0,stateSelect=w_rel_b_1_stateSelect)=model_w.w_rel_b_1 if use_w "Relative angular velocity w_rel_b[1]" annotation(Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularVelocity w_rel_b_2(start=0,stateSelect=w_rel_b_2_stateSelect)=model_w.w_rel_b_2 if use_w "Relative angular velocity w_rel_b[2]" annotation(Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularVelocity w_rel_b_3(start=0,stateSelect=w_rel_b_3_stateSelect)=model_w.w_rel_b_3 if use_w "Relative angular velocity w_rel_b[3]" annotation(Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter StateSelect w_rel_b_1_stateSelect=StateSelect.never "StateSelect of w_rel_b[1]" annotation(HideResult=true,Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b"));
  parameter StateSelect w_rel_b_2_stateSelect=StateSelect.never "StateSelect of w_rel_b[2]" annotation(HideResult=true,Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b"));
  parameter StateSelect w_rel_b_3_stateSelect=StateSelect.never "StateSelect of w_rel_b[3]" annotation(HideResult=true,Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular velocity w_rel_b of frame_b with respect to frame_a, resolved in frame_b"));
  parameter Boolean use_z=false "= true, if z_rel_b shall be used" annotation(HideResult=true,Dialog(enable=use_w,tab="Angular Velocity Initialization",group="Angular acceleration z_rel_b = der(w_rel_b)"));
  SI.AngularAcceleration z_rel_b_1(start=0)=der(w_rel_b_1) if use_w and use_z "Relative angular acceleration z_rel_b[1]" annotation(Dialog(enable=use_w and use_z,tab="Angular Velocity Initialization",group="Angular acceleration z_rel_b = der(w_rel_b)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularAcceleration z_rel_b_2(start=0)=der(w_rel_b_2) if use_w and use_z "Relative angular acceleration z_rel_b[2]" annotation(Dialog(enable=use_w and use_z,tab="Angular Velocity Initialization",group="Angular acceleration z_rel_b = der(w_rel_b)",showStartAttribute=true,__Dymola_initialDialog=true));
  SI.AngularAcceleration z_rel_b_3(start=0)=der(w_rel_b_3) if use_w and use_z "Relative angular acceleration z_rel_b[3]" annotation(Dialog(enable=use_w and use_z,tab="Angular Velocity Initialization",group="Angular acceleration z_rel_b = der(w_rel_b)",showStartAttribute=true,__Dymola_initialDialog=true));
  parameter SI.Length arrowDiameter=world.defaultArrowDiameter "Diameter of arrow from frame_a to frame_b" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation and use_r));
  input Types.Color arrowColor=Modelica.Mechanics.MultiBody.Types.Defaults.SensorColor "Color of arrow" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation and use_r));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation and use_r));
 protected

  encapsulated model Model_r

   import SI = Modelica.SIunits;
   import Modelica.Mechanics.MultiBody.Frames;

  // components of Model_r
   input SI.Position r_a_0[3] annotation(HideResult=true);
   input SI.Position r_b_0[3] annotation(HideResult=true);
   input Frames.Orientation R_a annotation(HideResult=true);
   output SI.Position r_rel_a_1 annotation(HideResult=true);
   output SI.Position r_rel_a_2 annotation(HideResult=true);
   output SI.Position r_rel_a_3 annotation(HideResult=true);

  // algorithms and equations of Model_r
  equation
   r_b_0 = r_a_0+Frames.resolve1(R_a,{r_rel_a_1,r_rel_a_2,r_rel_a_3});
  end Model_r;

  encapsulated model Model_w

   import SI = Modelica.SIunits;
   import Modelica.Mechanics.MultiBody.Frames;

  // components of Model_w
   input Frames.Orientation R_a annotation(HideResult=true);
   input Frames.Orientation R_b annotation(HideResult=true);
   output SI.AngularVelocity w_rel_b_1 annotation(HideResult=true);
   output SI.AngularVelocity w_rel_b_2 annotation(HideResult=true);
   output SI.AngularVelocity w_rel_b_3 annotation(HideResult=true);

  // algorithms and equations of Model_w
  equation
   {w_rel_b_1,w_rel_b_2,w_rel_b_3} = Frames.angularVelocity2(R_b)-Frames.resolve2(R_b,Frames.angularVelocity1(R_a));
  end Model_w;
 protected
  Visualizers.Advanced.Arrow arrow(r_head={r_rel_a_1,r_rel_a_2,r_rel_a_3},diameter=arrowDiameter,color=arrowColor,specularCoefficient=specularCoefficient,r=frame_a.r_0,R=frame_a.R) if (world.enableAnimation and animation) and use_r;
  Model_r model_r(r_a_0=frame_a.r_0,r_b_0=frame_b.r_0,R_a=frame_a.R) if use_r;
  Model_w model_w(R_a=frame_a.R,R_b=frame_b.R) if use_w;
  Frames.Orientation R_rel "Dummy or relative orientation object to rotate from frame_a to frame_b" annotation(HideResult=true);
  Frames.Orientation R_rel_inv "Dummy or relative orientation object to rotate from frame_b to frame_a" annotation(HideResult=true);

 // algorithms and equations of FreeMotionScalarInit
 equation
  if use_angle then
   Connections.branch(frame_a.R,frame_b.R);
   R_rel = Frames.axesRotations(sequence_start,{angle_1,angle_2,angle_3},{der(angle_1),der(angle_2),der(angle_3)});
   if rooted(frame_a.R) then
    R_rel_inv = Frames.nullRotation();
    frame_b.R = Frames.absoluteRotation(frame_a.R,R_rel);
   else
    R_rel_inv = Frames.inverseRotation(R_rel);
    frame_a.R = Frames.absoluteRotation(frame_b.R,R_rel_inv);
   end if;
  else
   R_rel = Frames.nullRotation();
   R_rel_inv = Frames.nullRotation();
   angle_1 = 0;
   angle_2 = 0;
   angle_3 = 0;
  end if;
  frame_a.f = zeros(3);
  frame_a.t = zeros(3);
  frame_b.f = zeros(3);
  frame_b.t = zeros(3);

 annotation(Documentation(info="<HTML>
<p>
Joint which does not constrain the motion between frame_a and frame_b.
Such a joint is meaningful if the <b>relative</b> distance and orientation
between frame_a and frame_b, and their derivatives, shall be used
as <b>states</b> or shall be used for non-standard
<b>initialization</b>. This joint allows to <b>initialize</b>
every <b>scalar</b> element of the relative quantites, as well
as to define <b>StateSelect</b> attributes for every
<b>scalar</b> element separately.
</p>

<p>
In the following figure the animation of a FreeMotionScalarInit
joint is shown. The light blue coordinate system is
frame_a and the dark blue coordinate system is
frame_b of the joint.
(here: r_rel_a_1(start = 0.5), r_rel_a_2(start = 0), r_rel_a_3(start = 0.5),
       angle_1(start = 45<sup>o</sup>), angle_2(start = 45<sup>o</sup>), angle_3(start = 45<sup>o</sup>)).
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/FreeMotion.png\">

<p>
A example to use this joint for the initialization of a planar double pendulum by providing
its tip position, is shown in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Examples.Elementary.DoublePendulumInitTip\">Examples.Elementary.DoublePendulumInitTip</a>.
</p>
</HTML>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-86,31},{-74,61},{-49,83},{-17,92},{19,88},{40,69},{59,48}},color={160,160,164},thickness=0.5),Polygon(points={{90,0},{50,20},{50,-20},{90,0}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(points={{69,58},{49,40},{77,28},{69,58}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{150,-44},{-150,-84}},lineColor={0,0,255},textString="%name"),Rectangle(extent={{-70,-5},{-90,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{50,-5},{30,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{11,-5},{-9,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-30,-5},{-50,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-86,31},{-74,61},{-49,83},{-17,92},{19,88},{40,69},{59,48}},color={160,160,164},thickness=0.5),Polygon(points={{90,0},{50,20},{50,-20},{90,0}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(points={{69,58},{49,40},{77,28},{69,58}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{50,-5},{30,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{11,-5},{-9,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-30,-5},{-50,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-70,-5},{-90,5}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid)}));
 end FreeMotionScalarInit;

 model SphericalSpherical
  "Spherical - spherical joint aggregation (1 constraint, no potential states) with an optional point mass in the middle"
  extends Interfaces.PartialTwoFrames;

  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Types;

 // components of SphericalSpherical
  parameter Boolean animation=true "= true, if animation shall be enabled";
  parameter Boolean showMass=true "= true, if mass shall be shown (provided animation = true and m > 0)";
  parameter Boolean computeRodLength=false "= true, if rodLength shall be computed during initialization (see info)";
  parameter SI.Length rodLength(min=Modelica.Constants.eps,fixed=not computeRodLength,start=1) "Distance between the origins of frame_a and frame_b (if computeRodLength=true, guess value)";
  parameter SI.Mass m(min=0)=0 "Mass of rod (= point mass located in middle of rod)";
  parameter SI.Diameter sphereDiameter=world.defaultJointLength "Diameter of spheres respresenting the spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of spheres respresenting the spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Diameter rodDiameter=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Diameter of rod connecting the two spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color rodColor=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of rod connecting the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Diameter massDiameter=sphereDiameter "Diameter of sphere representing the mass point" annotation(Dialog(tab="Animation",group="if animation = true and showMass = true and m > 0",enable=(animation and showMass) and (m>0)));
  input Types.Color massColor=Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor "Color of sphere representing the mass point" annotation(Dialog(tab="Animation",group="if animation = true and showMass = true and m > 0",enable=(animation and showMass) and (m>0)));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter Boolean kinematicConstraint=true "= false, if no constraint shall be defined, due to analytically solving a kinematic loop (\"false\" should not be used by user, but only by MultiBody.Joints.Assemblies joints)" annotation(Dialog(tab="Advanced"));
  Real constraintResidue=rRod_0*rRod_0-rodLength*rodLength "Constraint equation of joint in residue form: Either length constraint (= default) or equation to compute rod force (for analytic solution of loops in combination with Internal.RevoluteWithLengthConstraint/PrismaticWithLengthConstraint)" annotation(Dialog(tab="Advanced",enable=not kinematicConstraint));
  parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
  SI.Force f_rod "Constraint force in direction of the rod (positive on frame_a, when directed from frame_a to frame_b)";
  SI.Position rRod_0[3] "Position vector from frame_a to frame_b resolved in world frame";
  SI.Position rRod_a[3] "Position vector from frame_a to frame_b resolved in frame_a";
  Real eRod_a[3](each final unit="1") "Unit vector in direction from frame_a to frame_b, resolved in frame_a";
  SI.Position r_CM_0[3] "Dummy if m==0, or position vector from world frame to mid-point of rod, resolved in world frame";
  SI.Velocity v_CM_0[3] "First derivative of r_CM_0";
  SI.Force f_CM_a[3] "Dummy if m==0, or inertial force acting at mid-point of rod due to mass oint acceleration, resolved in frame_a";
  SI.Force f_CM_e[3] "Dummy if m==0, or projection of f_CM_a onto eRod_a, resolved in frame_a";
  SI.Force f_b_a1[3] "Force acting at frame_b, but without force in rod, resolved in frame_a";
  SI.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
 protected
  Visualizers.Advanced.Shape shape_rod(shapeType="cylinder",color=rodColor,specularCoefficient=specularCoefficient,length=rodLength,width=rodDiameter,height=rodDiameter,lengthDirection=eRod_a,widthDirection={0,1,0},r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  Visualizers.Advanced.Shape shape_a(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection=eRod_a,widthDirection={0,1,0},r_shape=(-eRod_a)*sphereDiameter/(2),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  Visualizers.Advanced.Shape shape_b(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection=eRod_a,widthDirection={0,1,0},r_shape=eRod_a*(rodLength-sphereDiameter/(2)),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
  Visualizers.Advanced.Shape shape_mass(shapeType="sphere",color=massColor,specularCoefficient=specularCoefficient,length=massDiameter,width=massDiameter,height=massDiameter,lengthDirection=eRod_a,widthDirection={0,1,0},r_shape=eRod_a*(rodLength/(2)-sphereDiameter/(2)),r=frame_a.r_0,R=frame_a.R) if ((world.enableAnimation and animation) and showMass) and (m>0);

 // algorithms and equations of SphericalSpherical
 equation
  if kinematicConstraint then
   rRod_0 = transpose(frame_b.R.T)*frame_b.R.T*frame_b.r_0-transpose(frame_a.R.T)*frame_a.R.T*frame_a.r_0;
  else
   rRod_0 = frame_b.r_0-frame_a.r_0;
  end if;
  rRod_a = Frames.resolve2(frame_a.R,rRod_0);
  eRod_a = rRod_a/(rodLength);
  constraintResidue = 0;
  frame_a.t = zeros(3);
  frame_b.t = zeros(3);
  if m>0 then
   r_CM_0 = frame_a.r_0+rRod_0/(2);
   v_CM_0 = der(r_CM_0);
   f_CM_a = m*Frames.resolve2(frame_a.R,der(v_CM_0)-world.gravityAcceleration(r_CM_0));
   f_CM_e = f_CM_a*eRod_a*eRod_a;
   frame_a.f = (f_CM_a-f_CM_e)/(2)+f_rod*eRod_a;
   f_b_a1 = (f_CM_a+f_CM_e)/(2);
   frame_b.f = Frames.resolveRelative(f_b_a1-f_rod*eRod_a,frame_a.R,frame_b.R);
  else
   r_CM_0 = zeros(3);
   v_CM_0 = zeros(3);
   f_CM_a = zeros(3);
   f_CM_e = zeros(3);
   f_b_a1 = zeros(3);
   frame_a.f = f_rod*eRod_a;
   frame_b.f = -Frames.resolveRelative(frame_a.f,frame_a.R,frame_b.R);
  end if;
  if checkTotalPower then
   totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+(-m)*(der(v_CM_0)-world.gravityAcceleration(r_CM_0))*v_CM_0+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R);
  else
   totalPower = 0;
  end if;

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Ellipse(extent={{-95,-40},{-15,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-84,-30},{-24,30}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{15,-40},{95,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{25,-29},{85,30}},lineColor={128,128,128},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-150,90},{150,50}},textString="%name",lineColor={0,0,255}),Rectangle(extent={{-40,40},{41,-41}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-51,6},{48,-4}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Ellipse(extent={{-68,15},{-39,-13}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{39,14},{68,-14}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Text(extent={{-150,-60},{150,-90}},lineColor={0,0,0},textString="%rodLength")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Ellipse(extent={{-98,-40},{-18,40}},lineColor={0,0,0},fillColor={160,160,164},fillPattern=FillPattern.Solid),Ellipse(extent={{-88,-30},{-28,30}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{18,-40},{98,40}},lineColor={160,160,164},fillColor={160,160,164},fillPattern=FillPattern.Solid),Ellipse(extent={{29,-30},{89,29}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-56,-60},{46,-60}},color={0,0,255}),Polygon(points={{56,-60},{41,-54},{41,-66},{56,-60}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Text(extent={{-37,-63},{33,-79}},textString="rodLength",lineColor={0,0,255}),Rectangle(extent={{-40,41},{40,-40}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-51,6},{48,-4}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Ellipse(extent={{-71,15},{-42,-13}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{42,14},{71,-14}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{-56,-71},{-56,1}},color={0,0,255}),Line(points={{56,-72},{56,0}},color={0,0,255}),Polygon(points={{11,1},{-1,4},{-1,-2},{11,1}},lineColor={0,0,255}),Line(points={{-56,1},{-1,1}},color={0,0,255}),Text(extent={{-32,-4},{4,-29}},lineColor={0,0,0},textString="eRod_a")}),Documentation(info="<html>
<p>
Joint that has a spherical joint on each of its two ends.
The rod connecting the two spherical joints is approximated by a
point mass that is located in the middle of the rod. When the mass
is set to zero (default), special code for a massless body is generated.
In the following default animation figure, the two spherical joints are
represented by two red spheres, the connecting rod by a grey cylinder
and the point mass in the middle of the rod by a light blue sphere:
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/SphericalSpherical.png\" ALT=\"model Joints.SphericalSpherical\">

<p>
This joint introduces <b>one constraint</b> defining that the distance between
the origin of frame_a and the origin of frame_b is constant (= rodLength).
It is highly recommended to use this joint in loops
whenever possible, because this enhances the efficiency
considerably due to smaller systems of non-linear algebraic
equations.
</p>
<p>
It is sometimes desirable to <b>compute</b> the <b>rodLength</b>
of the connecting rod during initialization. For this, parameter
<b>computeLength</b> has to be set to <b>true</b> and instead <b>one</b> other,
easier to determine, position variable in the same loop
needs to have a fixed attribute of <b>true</b>. For example,
if a loop consists of one Revolute joint, one Prismatic joint and
a SphericalSpherical joint, one may fix the start values of the revolute
joint angle and of the relative distance of the prismatic joint
in order to compute the rodLength of the rod.
</p>
<p>
It is not possible to connect other components, such as a body with mass
properties or a special visual shape object to the rod connecting
the two spherical joints. If this is needed, use instead joint Joints.<b>UniversalSpherical</b>
that has this property.
</p>
</html>"));
 end SphericalSpherical;

 model UniversalSpherical
  "Universal - spherical joint aggregation (1 constraint, no potential states)"
  extends Interfaces.PartialTwoFrames;

  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Types;

 // components of UniversalSpherical
  Interfaces.Frame_a frame_ia "Coordinate system at the origin of frame_a, fixed at the rod connecting the universal with the spherical joint" annotation(Placement(transformation(origin={-40,100},extent={{-16,-16},{16,16}},rotation=270)));
  parameter Boolean animation=true "= true, if animation shall be enabled";
  parameter Boolean showUniversalAxes=true " = true, if universal joint shall be visualized with two cylinders, otherwise with a sphere (provided animation=true)";
  parameter Boolean computeRodLength=false "= true, if distance between frame_a and frame_b shall be computed during initialization (see info)";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n1_a={0,0,1} "Axis 1 of universal joint resolved in frame_a (axis 2 is orthogonal to axis 1 and to rod)" annotation(Evaluate=true);
  parameter SI.Position rRod_ia[3]={1,0,0} "Vector from origin of frame_a to origin of frame_b, resolved in frame_ia (if computeRodLength=true, rRod_ia is only an axis vector along the connecting rod)" annotation(Evaluate=true);
  parameter SI.Diameter sphereDiameter=world.defaultJointLength "Diameter of spheres representing the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of spheres representing the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter Types.ShapeType rodShapeType="cylinder" "Shape type of rod connecting the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance rodWidth=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Width of rod shape in direction of axis 2 of universal joint." annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance rodHeight=rodWidth "Height of rod shape in direction that is orthogonal to rod and to axis 2" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter Types.ShapeExtra rodExtra=0.0 "Additional parameter depending on rodShapeType" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  input Types.Color rodColor=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of rod shape connecting the universal and the spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter SI.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
  parameter SI.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
  input Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
  input Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  parameter Boolean kinematicConstraint=true "= false, if no constraint shall be defined, due to analytically solving a kinematic loop" annotation(Dialog(tab="Advanced"));
  Real constraintResidue=rRod_0*rRod_0-rodLength*rodLength "Constraint equation of joint in residue form: Either length constraint (= default) or equation to compute rod force (for analytic solution of loops in combination with Internal.RevoluteWithLengthConstraint/PrismaticWithLengthConstraint)" annotation(Dialog(tab="Advanced",enable=not kinematicConstraint));
  parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
  SI.Force f_rod "Constraint force in direction of the rod (positive, if rod is pressed)";
  final parameter SI.Distance rodLength(fixed=not computeRodLength)=Modelica.Math.Vectors.length(rRod_ia) "Length of rod (distance between origin of frame_a and origin of frame_b)";
  final parameter Real eRod_ia[3](each final unit="1")=Modelica.Math.Vectors.normalize(rRod_ia,0.0) "Unit vector from origin of frame_a to origin of frame_b, resolved in frame_ia";
  final parameter Real e2_ia[3](each final unit="1")=Modelica.Math.Vectors.normalize(cross(n1_a,eRod_ia)) "Unit vector in direction of axis 2 of universal joint, resolved in frame_ia (orthogonal to n1_a and eRod_ia; note: frame_ia is parallel to frame_a when the universal joint angles are zero)";
  final parameter Real e3_ia[3](each final unit="1")=cross(eRod_ia,e2_ia) "Unit vector perpendicular to eRod_ia and e2_ia, resolved in frame_ia";
  SI.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
  SI.Force f_b_a1[3] "frame_b.f without f_rod part, resolved in frame_a (needed for analytic loop handling)";
  Real eRod_a[3](each final unit="1") "Unit vector in direction of rRod_a, resolved in frame_a (needed for analytic loop handling)";
  SI.Position rRod_0[3](start=rRod_ia) "Position vector from origin of frame_a to origin of frame_b resolved in world frame";
  SI.Position rRod_a[3](start=rRod_ia) "Position vector from origin of frame_a to origin of frame_b resolved in frame_a";
 protected
  SI.Force f_b_a[3] "frame_b.f resolved in frame_a";
  SI.Force f_ia_a[3] "frame_ia.f resolved in frame_a";
  SI.Torque t_ia_a[3] "frame_ia.t resolved in frame_a";
  Real n2_a[3](each final unit="1") "Vector in direction of axis 2 of the universal joint (e2_ia), resolved in frame_a";
  Real length2_n2_a(start=1,unit="m2") "Square of length of vector n2_a";
  SI.Length length_n2_a "Length of vector n2_a";
  Real e2_a[3](each final unit="1") "Unit vector in direction of axis 2 of the universal joint (e2_ia), resolved in frame_a";
  Real e3_a[3](each final unit="1") "Unit vector perpendicular to eRod_ia and e2_a, resolved in frame_a";
  Real der_rRod_a_L[3](each unit="1/s") "= der(rRod_a)/rodLength";
  SI.AngularVelocity w_rel_ia1[3];
  Frames.Orientation R_rel_ia1;
  Frames.Orientation R_rel_ia2;
  Frames.Orientation R_rel_ia "Rotation from frame_a to frame_ia";
  Visualizers.Advanced.Shape rodShape(shapeType=rodShapeType,color=rodColor,specularCoefficient=specularCoefficient,length=rodLength,width=rodWidth,height=rodHeight,lengthDirection=eRod_ia,widthDirection=e2_ia,r=frame_ia.r_0,R=frame_ia.R) if world.enableAnimation and animation;
  Visualizers.Advanced.Shape sphericalShape_b(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection={1,0,0},widthDirection={0,1,0},r_shape={-0.5,0,0}*sphereDiameter,r=frame_b.r_0,R=frame_b.R) if world.enableAnimation and animation;
  Visualizers.Advanced.Shape sphericalShape_a(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection={1,0,0},widthDirection={0,1,0},r_shape={-0.5,0,0}*sphereDiameter,r=frame_a.r_0,R=frame_a.R) if (world.enableAnimation and animation) and not showUniversalAxes;
  Visualizers.Advanced.Shape universalShape1(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=n1_a,widthDirection={0,1,0},r_shape=(-n1_a)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if (world.enableAnimation and animation) and showUniversalAxes;
  Visualizers.Advanced.Shape universalShape2(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e2_ia,widthDirection={0,1,0},r_shape=(-e2_ia)*cylinderLength/(2),r=frame_ia.r_0,R=frame_ia.R) if (world.enableAnimation and animation) and showUniversalAxes;

 // algorithms and equations of UniversalSpherical
 equation
  Connections.branch(frame_a.R,frame_ia.R);
  if kinematicConstraint then
   rRod_0 = transpose(frame_b.R.T)*frame_b.R.T*frame_b.r_0-transpose(frame_a.R.T)*frame_a.R.T*frame_a.r_0;
  else
   rRod_0 = frame_b.r_0-frame_a.r_0;
  end if;
  rRod_a = Frames.resolve2(frame_a.R,rRod_0);
  constraintResidue = 0;
  eRod_a = rRod_a/(rodLength);
  n2_a = cross(n1_a,eRod_a);
  length2_n2_a = n2_a*n2_a;
  assert(length2_n2_a>1.e-10,"
A Modelica.Mechanics.MultiBody.Joints.UniversalSpherical joint (consisting of
a universal joint and a spherical joint connected together
by a rigid rod) is in the singular configuration of the
universal joint. This means that axis 1 of the universal
joint defined via parameter \"n1_a\" is parallel to vector
\"rRod_ia\" that is directed from the origin of frame_a to the
origin of frame_b.
   You may try to use another \"n1_a\" vector. If this fails,
use instead Modelica.Mechanics.MultiBody.Joints.SphericalSpherical, if this is
possible, because this joint aggregation does not have a
singular configuration.
");
  length_n2_a = sqrt(length2_n2_a);
  e2_a = n2_a/(length_n2_a);
  e3_a = cross(eRod_a,e2_a);
  der_rRod_a_L = (Frames.resolve2(frame_a.R,der(rRod_0))-cross(frame_a.R.w,rRod_a))/(rodLength);
  w_rel_ia1 = {e3_a*cross(n1_a,der_rRod_a_L)/(length_n2_a),(-e3_a)*der_rRod_a_L,e2_a*der_rRod_a_L};
  R_rel_ia1 = Frames.from_T(transpose([eRod_a, e2_a, e3_a]),w_rel_ia1);
  R_rel_ia2 = Frames.from_T([eRod_ia, e2_ia, e3_ia],zeros(3));
  R_rel_ia = Frames.absoluteRotation(R_rel_ia1,R_rel_ia2);
  frame_ia.r_0 = frame_a.r_0;
  frame_ia.R = Frames.absoluteRotation(frame_a.R,R_rel_ia);
  f_ia_a = Frames.resolve1(R_rel_ia,frame_ia.f);
  t_ia_a = Frames.resolve1(R_rel_ia,frame_ia.t);
  f_b_a1 = (-e2_a)*n1_a*t_ia_a/(rodLength*n1_a*e3_a)+e3_a*e2_a*t_ia_a/(rodLength);
  f_b_a = (-f_rod)*eRod_a+f_b_a1;
  frame_b.f = Frames.resolveRelative(f_b_a,frame_a.R,frame_b.R);
  frame_b.t = zeros(3);
  zeros(3) = frame_a.f+f_b_a+f_ia_a;
  zeros(3) = frame_a.t+t_ia_a+cross(rRod_a,f_b_a);
  if checkTotalPower then
   totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+frame_ia.f*Frames.resolve2(frame_ia.R,der(frame_ia.r_0))+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R)+frame_ia.t*Frames.angularVelocity2(frame_ia.R);
  else
   totalPower = 0;
  end if;

 annotation(Documentation(info="<html>
<p>
This component consists of a <b>universal joint</b> at frame_a and
a <b>spherical joint</b> at frame_b that are connected together with
a <b>rigid rod</b>, see default aimation figure (the arrows are not
part of the default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/UniversalSpherical.png\" ALT=\"model Joints.UniversalSpherical\">

<p>
This joint aggregation has no mass and no inertia and introduces the constraint
that the distance between the origin of frame_a and the origin of frame_b is constant
(= Frames.length(rRod_ia)). The universal joint is defined in the following way:
<p>
<ul>
<li> The rotation <b>axis</b> of revolute joint <b>1</b> is along parameter
     vector n1_a which is fixed in frame_a.<li>
<li> The rotation <b>axis</b> of revolute joint <b>2</b> is perpendicular to
     axis 1 and to the line connecting the universal and the spherical joint.
</ul>
<p>
The definition of axis 2 of the universal joint is performed according
to the most often occuring case. In a future release, axis 2 might
be explicitly definable via a parameter. However, the treatment is much more
complicated and the number of operations is considerably higher,
if axis 2 is not orthogonal to axis 1 and to the connecting rod.
</p>
<p>
Note, there is a <b>singularity</b> when axis 1 and the connecting rod are parallel
to other. Therefore, if possible n1_a should be selected in such a way that it
is perpendicular to rRod_ia in the initial configuration (i.e., the
distance to the singularity is as large as possible).
</p>
<p>
An additional <b>frame_ia</b> is present. It is <b>fixed</b> in the connecting
<b>rod</b> at the origin of <b>frame_a</b>. The placement of frame_ia on the rod
is implicitly defined by the universal joint (frame_a and frame_ia coincide
when the angles of the two revolute joints of the universal joint are zero)
and by parameter vector <b>rRod_ia</b>, the position vector
from the origin of frame_a to the origin of frame_b, resolved in frame_<b>ia</b>.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to other (alternatively,
at least frame_a and frame_ia of the UniversalSpherical joint
should be parallel to other when defining an instance of this
component). Since frame_a and frame_ia are parallel to other,
vector <b>rRod_ia</b> from frame_a to frame_b resolved in frame_<b>ia</b> can be resolved
in frame_<b>a</b> (or the <b>world frame</b>, if all frames are parallel to other).
</p>
<p>
This joint aggregation can be used in cases where
in reality a rod with spherical joints at end are present.
Such a system has an additional degree of freedom to rotate
the rod along its axis. In practice this rotation is usually
of no interested and is mathematically removed by replacing one
of the spherical joints by a universal joint. Still, in most
cases the Joints.SphericalSpherical joint aggregation can be used instead
of the UniversalSpherical joint
since the rod is animated and its mass properties are approximated by
a point mass in the middle of the rod. The SphericalSpherical joint
has the advantage that it does not have a singular configuration.
</p>
<p>
In the public interface of the UniversalSpherical joint, the following
(final) <b>parameters</b> are provided:
</p>
<pre>
  <b>parameter</b> Real rodLength(unit=\"m\")  \"Length of rod\";
  <b>parameter</b> Real eRod_ia[3] \"Unit vector along rod, resolved in frame_ia\";
  <b>parameter</b> Real e2_ia  [3] \"Unit vector along axis 2, resolved in frame_ia\";
</pre>
<p>
This allows a more convenient definition of data which is related to the rod.
For example, if a box shall be connected at frame_ia directing from
the origin of frame_a to the middle of the rod, this might be defined as:
</p>
<pre>
    Modelica.Mechanics.MultiBody.Joints.UniversalSpherical jointUS(rRod_ia={1.2, 1, 0.2});
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape    shape(shapeType       = \"box\",
                                              lengthDirection = jointUS.eRod_ia,
                                              widthDirection  = jointUS.e2_ia,
                                              length          = jointUS.rodLength/2,
                                              width           = jointUS.rodLength/10);
  <b>equation</b>
    <b>connect</b>(jointUS.frame_ia, shape.frame_a);
</pre>
</html>
"),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Text(extent={{-150,-50},{150,-90}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-100,-40},{-19,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-90,-30},{-29,29}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-60,41},{-9,-44}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-60,40},{-60,-40}},color={0,0,0},thickness=0.5),Ellipse(extent={{-83,-17},{-34,21}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-74,-12},{-40,15}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-72,-20},{-89,3},{-69,25},{-45,27},{-72,-20}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-60,40},{-60,-10}},color={0,0,0},thickness=0.5),Line(points={{-49,20},{-69,-15}},color={0,0,0},thickness=0.5),Ellipse(extent={{44,14},{73,-14}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{20,-40},{100,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{30,-30},{90,30}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-22,45},{40,-43}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{46,14},{75,-14}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Rectangle(extent={{-36,-8},{48,8}},lineColor={0,0,0},pattern=LinePattern.None,fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-105,118},{-67,86}},lineColor={128,128,128},textString="ia"),Text(extent={{-24,95},{167,65}},lineColor={0,0,0},textString="%rRod_ia"),Line(points={{-40,101},{-40,60},{-60,1}},color={128,128,128},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-60,-70},{46,-70}},color={0,0,255}),Polygon(points={{60,-70},{45,-64},{45,-76},{60,-70}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Text(extent={{-56,-71},{56,-90}},textString="rRod",lineColor={0,0,255}),Ellipse(extent={{-100,-40},{-19,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-90,-30},{-29,29}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-60,41},{-19,-41}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-60,40},{-60,-40}},color={0,0,0},thickness=0.5),Ellipse(extent={{-83,-17},{-34,21}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-74,-12},{-40,15}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-72,-20},{-89,3},{-69,25},{-45,27},{-72,-20}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-60,40},{-60,-10}},color={0,0,0},thickness=0.5),Line(points={{-49,20},{-69,-15}},color={0,0,0},thickness=0.5),Polygon(points={{7,-1},{-5,2},{-5,-4},{7,-1}},lineColor={0,0,255}),Line(points={{-50,19},{-30,57}},color={0,0,255}),Text(extent={{-34,78},{8,62}},lineColor={0,0,0},textString="e2"),Polygon(points={{-25,64},{-33,56},{-27,53},{-25,64}},lineColor={0,0,255}),Line(points={{-60,41},{-60,65}},color={0,0,255}),Polygon(points={{-60,75},{-64,63},{-56,63},{-60,75}},lineColor={0,0,255}),Text(extent={{-93,82},{-64,62}},lineColor={0,0,0},textString="n1"),Line(points={{-60,-40},{-60,-72}},color={0,0,255}),Ellipse(extent={{20,-40},{100,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{30,-30},{90,30}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-22,45},{40,-43}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{45,14},{74,-14}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{-36,-8},{48,8}},lineColor={0,0,0},pattern=LinePattern.None,fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-31,-7},{0,-28}},lineColor={0,0,0},textString="eRod"),Line(points={{-60,0},{-5,0}},color={0,0,255}),Polygon(points={{7,0},{-5,3},{-5,-3},{7,0}},lineColor={0,0,255}),Line(points={{60,-1},{60,-72}},color={0,0,255}),Line(points={{-40,100},{-40,70},{-60,0}},color={128,128,128},thickness=0.5),Text(extent={{-23,30},{26,10}},textString=" eRod*e2 = 0;  n1*e2 = 0",lineColor={0,0,255})}));
 end UniversalSpherical;

 model GearConstraint
  "Ideal 3-dim. gearbox (arbitrary shaft directions)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;

 // components of GearConstraint
  Interfaces.Frame_a bearing "Coordinate system fixed in the bearing" annotation(Placement(transformation(origin={0,-100},extent={{-16,-16},{16,16}},rotation=90)));
  parameter Real ratio(start=2) "Gear speed ratio";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_a={1,0,0} "Axis of rotation of shaft a (same coordinates in frame_a, frame_b, bearing)";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={1,0,0} "Axis of rotation of shaft b (same coordinates in frame_a, frame_b, bearing)";
  parameter Modelica.SIunits.Position r_a[3]={0,0,0} "Vector from frame bearing to frame_a resolved in bearing";
  parameter Modelica.SIunits.Position r_b[3]={0,0,0} "Vector from frame bearing to frame_b resolved in bearing";
  Modelica.Mechanics.MultiBody.Joints.Revolute actuatedRevolute_a(useAxisFlange=true,n=n_a,animation=false) annotation(Placement(transformation(extent={{-40,-10},{-60,10}},rotation=0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute actuatedRevolute_b(useAxisFlange=true,n=n_b,animation=false) annotation(Placement(transformation(extent={{40,-10},{60,10}},rotation=0)));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio=ratio) annotation(Placement(transformation(extent={{-10,30},{10,50}},rotation=0)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation fixedTranslation1(animation=false,r=r_b) annotation(Placement(transformation(extent={{10,-10},{30,10}},rotation=0)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation fixedTranslation2(animation=false,r=r_a) annotation(Placement(transformation(origin={-20,0},extent={{-10,-10},{10,10}},rotation=180)));

 // algorithms and equations of GearConstraint
 equation
  assert(cardinality(bearing)>0,"Connector bearing of component is not connected");
  connect(actuatedRevolute_a.axis,idealGear.flange_a) annotation(Line(points={{-50,10},{-50,40},{-10,40}},color={0,0,0}));
  connect(idealGear.flange_b,actuatedRevolute_b.axis) annotation(Line(points={{10,40},{50,40},{50,10}},color={0,0,0}));
  connect(actuatedRevolute_a.frame_a,fixedTranslation2.frame_b) annotation(Line(points={{-40,0},{-35,0},{-35,1.22465e-015},{-30,1.22465e-015}},color={95,95,95},thickness=0.5));
  connect(fixedTranslation2.frame_a,bearing) annotation(Line(points={{-10,-1.22465e-015},{-4,-1.22465e-015},{-4,0},{0,0},{0,-100}},color={95,95,95},thickness=0.5));
  connect(fixedTranslation1.frame_a,bearing) annotation(Line(points={{10,0},{0,0},{0,-100}},color={95,95,95},thickness=0.5));
  connect(fixedTranslation1.frame_b,actuatedRevolute_b.frame_a) annotation(Line(points={{30,0},{40,0}},color={95,95,95},thickness=0.5));
  connect(frame_a,actuatedRevolute_a.frame_b) annotation(Line(points={{-100,0},{-60,0}},color={95,95,95},thickness=0.5));
  connect(actuatedRevolute_b.frame_b,frame_b) annotation(Line(points={{60,0},{100,0}},color={95,95,95},thickness=0.5));

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-98,98},{98,-98}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-40,20},{-20,-20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-40,140},{-20,20}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{20,100},{40,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{20,60},{40,-60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{40,10},{100,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-20,90},{20,70}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-100,10},{-40,-10}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-150,175},{150,135}},lineColor={0,0,255},textString="%name"),Line(points={{-80,20},{-60,20}},color={0,0,0}),Line(points={{-80,-20},{-60,-20}},color={0,0,0}),Line(points={{-10,60},{10,60}},color={0,0,0}),Line(points={{60,20},{80,20}},color={0,0,0}),Line(points={{60,-20},{80,-20}},color={0,0,0}),Line(points={{-70,-20},{-70,-70},{70,-70},{70,-20}},color={0,0,0}),Line(points={{0,60},{0,-70},{0,-100}},color={0,0,0}),Line(points={{-10,100},{10,100}},color={0,0,0}),Text(extent={{-150,-64},{150,-94}},lineColor={0,0,0},textString="%ratio")}),Documentation(info="<html>
<p>This ideal massless joint provides a gear constraint between
frames <code>frame_a</code> and <code>frame_b</code>. The axes of rotation
of <code>frame_a</code> and <code>frame_b</code> may be arbitrary.</p>
<p><b>Reference</b><br>
<span style=\"font-variant:small-caps\">Schweiger</span>, Christian ;
<span style=\"font-variant:small-caps\">Otter</span>, Martin:
<a href=\"http://www.modelica.org/Conference2003/papers/h06_Schweiger_powertrains_v5.pdf\">Modelling
3D Mechanical Effects of 1-dim. Powertrains</a>. In: <i>Proceedings of the 3rd International
Modelica Conference</i>. Link&ouml;ping : The Modelica Association and Link&ouml;ping University,
November 3-4, 2003, pp. 149-158</p>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics));
 end GearConstraint;

 model RollingWheel
  "Joint (no mass, no inertia) that describes an ideal rolling wheel (rolling on the plane z=0)"

  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Frames;

 // components of RollingWheel
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Frame fixed in wheel center point. x-Axis: upwards, y-axis: along wheel axis" annotation(Placement(transformation(extent={{-16,-16},{16,16}})));
  parameter SI.Radius wheelRadius "Wheel radius";
  parameter StateSelect stateSelect=StateSelect.always "Priority to use generalized coordinates as states" annotation(HideResult=true,Evaluate=true);
  SI.Position x(start=0,stateSelect=stateSelect) "x-coordinate of wheel axis";
  SI.Position y(start=0,stateSelect=stateSelect) "y-coordinate of wheel axis";
  SI.Position z;
  SI.Angle angles[3](start={0,0,0},each stateSelect=stateSelect) "Angles to rotate world-frame in to frame_a around z-, y-, x-axis" annotation(Dialog(group="Initialization",showStartAttribute=true));
  SI.AngularVelocity der_angles[3](start={0,0,0},each stateSelect=stateSelect) "Derivative of angles" annotation(Dialog(group="Initialization",showStartAttribute=true));
  SI.Position r_road_0[3] "Position vector from world frame to contact point on road, resolved in world frame";
  SI.Force f_wheel_0[3] "Contact force acting on wheel, resolved in world frame";
  SI.Force f_n "Contact force acting on wheel in normal direction";
  SI.Force f_lat "Contact force acting on wheel in lateral direction";
  SI.Force f_long "Contact force acting on wheel in longitudinal direction";
  SI.Position err "|r_road_0 - frame_a.r_0| - wheelRadius (must be zero; used for checking)";
 protected
  Real e_axis_0[3] "Unit vector along wheel axis, resolved in world frame";
  SI.Position delta_0[3](start={0,0,-wheelRadius}) "Distance vector from wheel center to contact point";
  Real e_n_0[3] "Unit vector in normal direction of road at contact point, resolved in world frame";
  Real e_lat_0[3] "Unit vector in lateral direction of wheel at contact point, resolved in world frame";
  Real e_long_0[3] "Unit vector in longitudinal direction of wheel at contact point, resolved in world frame";
  SI.Position s "Road surface parameter 1";
  SI.Position w "Road surface parameter 2";
  Real e_s_0[3] "Road heading at (s,w), resolved in world frame (unit vector)";
  SI.Velocity v_0[3] "Velocity of wheel center, resolved in world frame";
  SI.AngularVelocity w_0[3] "Angular velocity of wheel, resolved in world frame";
  SI.Velocity vContact_0[3] "Velocity of wheel contact point, resolved in world frame";
  Real aux[3];

 // algorithms and equations of RollingWheel
 equation
  Connections.root(frame_a.R);
  frame_a.r_0 = {x,y,z};
  der_angles = der(angles);
  frame_a.R = Frames.axesRotations({3,2,1},angles,der_angles);
  r_road_0 = {s,w,0};
  e_n_0 = {0,0,1};
  e_s_0 = {1,0,0};
  e_axis_0 = Frames.resolve1(frame_a.R,{0,1,0});
  aux = cross(e_n_0,e_axis_0);
  e_long_0 = aux/(Modelica.Math.Vectors.length(aux));
  e_lat_0 = cross(e_long_0,e_n_0);
  delta_0 = r_road_0-frame_a.r_0;
  0 = delta_0*e_axis_0;
  0 = delta_0*e_long_0;
  0 = wheelRadius-delta_0*cross(e_long_0,e_axis_0);
  err = Modelica.Math.Vectors.length(delta_0)-wheelRadius;
  v_0 = der(frame_a.r_0);
  w_0 = Frames.angularVelocity1(frame_a.R);
  vContact_0 = v_0+cross(w_0,delta_0);
  0 = vContact_0*e_long_0;
  0 = vContact_0*e_lat_0;
  f_wheel_0 = f_n*e_n_0+f_lat*e_lat_0+f_long*e_long_0;
  zeros(3) = frame_a.f+Frames.resolve2(frame_a.R,f_wheel_0);
  zeros(3) = frame_a.t+Frames.resolve2(frame_a.R,cross(delta_0,f_wheel_0));
  assert(abs(e_n_0*e_axis_0)<0.99,"Wheel lays nearly on the ground (which is a singularity)");

 annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,-80},{100,-100}},lineColor={0,0,0},fillColor={175,175,175},fillPattern=FillPattern.Solid),Text(extent={{-154,124},{146,84}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-80,80},{80,-80}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid)}));
 end RollingWheel;

 model RollingWheelSet
  "Joint (no mass, no inertia) that describes an ideal rolling wheel set (two ideal rolling wheels connected together by an axis)"

  import SI = Modelica.SIunits;

 // locally defined classes in RollingWheelSet
    model _famefaults_support = FAME.Dampers.RotationalWithConnectEquations;
    model _famefaults_axis2 = FAME.Dampers.RotationalWithConnectEquations;
    model _famefaults_axis1 = FAME.Dampers.RotationalWithConnectEquations;

 // components of RollingWheelSet
  Modelica.SIunits.Angle theta2(start=0,stateSelect=stateSelect) "Angle of wheel 2";
  Modelica.SIunits.Angle theta1(start=0,stateSelect=stateSelect) "Angle of wheel 1";
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute(animation=animation) annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={0,-22})));
  Modelica.Mechanics.MultiBody.Parts.Fixed fixed(r={0,0,wheelRadius},animation=animation) annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={0,-90})));
  Modelica.SIunits.Angle phi(start=0,stateSelect=stateSelect) "Orientation angle of wheel axis along z-axis";
  Modelica.Mechanics.MultiBody.Joints.Prismatic prismatic2(n={0,1,0},animation=animation) annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,origin={-24,-50})));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute2(n={0,1,0},useAxisFlange=true,animation=animation) annotation(Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Mechanics.MultiBody.Joints.Internal.RollingConstraintVerticalWheel rolling2(radius=wheelRadius,lateralSlidingConstraint=false) annotation(Placement(transformation(extent={{54,-60},{74,-40}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b support "Support of 1D axes" annotation(Placement(transformation(extent={{-10,70},{10,90}}),iconTransformation(extent={{-10,70},{10,90}})));
  FAME.Dampers.RotationalWithConnectEquations _famefault_support(amount=0.0);
  Modelica.Mechanics.MultiBody.Joints.Internal.RollingConstraintVerticalWheel rolling1(radius=wheelRadius) annotation(Placement(transformation(extent={{-70,-60},{-50,-40}})));
  parameter Boolean animation=true "= true, if animation of wheel set shall be enabled";
  parameter StateSelect stateSelect=StateSelect.default "Priority to use the generalized coordinates as states";
  parameter Modelica.SIunits.Radius wheelRadius "Radius of one wheel";
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute1(n={0,1,0},useAxisFlange=true,animation=animation) annotation(Placement(transformation(extent={{-34,-10},{-54,10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation rod2(r={0,(-wheelDistance)/(2),0},animation=animation) annotation(Placement(transformation(extent={{12,-10},{32,10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation rod1(r={0,wheelDistance/(2),0},animation=animation) annotation(Placement(transformation(extent={{-8,-10},{-28,10}})));
  Modelica.Mechanics.MultiBody.Joints.Prismatic prismatic1(animation=animation) annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={0,-66})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axis2 "1-dim. rotational flange that drives the joint" annotation(Placement(transformation(extent={{90,90},{110,110}})));
  FAME.Dampers.RotationalWithConnectEquations _famefault_axis2(amount=0.0);
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axis1 "1-dim. rotational flange that drives the joint" annotation(Placement(transformation(extent={{-110,90},{-90,110}})));
  FAME.Dampers.RotationalWithConnectEquations _famefault_axis1(amount=0.0);
  Modelica.SIunits.AngularVelocity der_theta2(start=0,stateSelect=stateSelect) "Derivative of theta 2";
  Modelica.SIunits.AngularVelocity der_theta1(start=0,stateSelect=stateSelect) "Derivative of theta 1";
  Modelica.Mechanics.MultiBody.Parts.Mounting1D mounting1D annotation(Placement(transformation(extent={{-10,38},{10,58}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame1 "Frame fixed in center point of left wheel (y-axis: along wheel axis, z-Axis: upwards)" annotation(Placement(transformation(extent={{-96,16},{-64,-16}}),iconTransformation(extent={{-96,16},{-64,-16}})));
  parameter Modelica.SIunits.Distance wheelDistance "Distance between the two wheels";
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame2 "Frame fixed in center point of right wheel (y-axis: along wheel axis, z-Axis: upwards)" annotation(Placement(transformation(extent={{64,16},{96,-16}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frameMiddle "Frame fixed in middle of axis connecting both wheels (y-axis: along wheel axis, z-Axis: upwards)" annotation(Placement(transformation(extent={{-16,16},{16,-16}}),iconTransformation(extent={{-16,-16},{16,16}})));
  Modelica.SIunits.Position y(start=0,stateSelect=stateSelect) "y coordinate for center between wheels";
  Modelica.SIunits.Position x(start=0,stateSelect=stateSelect) "x coordinate for center between wheels";

 // algorithms and equations of RollingWheelSet
 equation
  prismatic1.s = x;
  prismatic2.s = y;
  revolute.phi = phi;
  revolute1.phi = theta1;
  revolute2.phi = theta2;
  der_theta1 = der(theta1);
  der_theta2 = der(theta2);
  connect(revolute.frame_b,frameMiddle) annotation(Line(points={{6.12323e-016,-12},{0,-12},{0,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(rod1.frame_a,frameMiddle) annotation(Line(points={{-8,0},{0,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(rod2.frame_a,frameMiddle) annotation(Line(points={{12,0},{0,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(rod1.frame_b,revolute1.frame_a) annotation(Line(points={{-28,0},{-34,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(revolute1.frame_b,frame1) annotation(Line(points={{-54,0},{-80,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(revolute2.frame_a,rod2.frame_b) annotation(Line(points={{40,0},{32,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(revolute2.frame_b,frame2) annotation(Line(points={{60,0},{80,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(prismatic1.frame_a,fixed.frame_b) annotation(Line(points={{-6.12323e-016,-76},{6.12323e-016,-76},{6.12323e-016,-80}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(prismatic1.frame_b,prismatic2.frame_a) annotation(Line(points={{6.12323e-016,-56},{6.12323e-016,-50},{-14,-50}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(prismatic2.frame_b,revolute.frame_a) annotation(Line(points={{-34,-50},{-40,-50},{-40,-36},{-6.12323e-016,-36},{-6.12323e-016,-32}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(rolling1.frame_a,revolute1.frame_b) annotation(Line(points={{-60,-48},{-60,0},{-54,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(rolling2.frame_a,revolute2.frame_b) annotation(Line(points={{64,-48},{64,0},{60,0}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(revolute1.axis,_famefault_axis1.port_b) annotation(Line(points={{-44,10},{-44,100},{-100,100}},color={0,0,0},smooth=Smooth.None));
  connect(revolute2.axis,_famefault_axis2.port_b) annotation(Line(points={{50,10},{50,100},{100,100}},color={0,0,0},smooth=Smooth.None));
  connect(frameMiddle,mounting1D.frame_a) annotation(Line(points={{0,0},{0,38}},color={95,95,95},thickness=0.5,smooth=Smooth.None));
  connect(mounting1D.flange_b,_famefault_support.port_b) annotation(Line(points={{10,48},{16,48},{16,80},{0,80}},color={0,0,0},smooth=Smooth.None));
  connect(support,_famefault_support.port_a);
  connect(axis2,_famefault_axis2.port_a);
  connect(axis1,_famefault_axis1.port_a);

 annotation(defaultComponentName="wheelSet",Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,-80},{100,-100}},lineColor={0,0,0},fillColor={175,175,175},fillPattern=FillPattern.Solid),Text(extent={{-146,-98},{154,-138}},textString="%name",lineColor={0,0,255}),Ellipse(extent={{42,80},{118,-80}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-62,2},{64,-6}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-118,80},{-42,-80}},lineColor={0,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{86,24},{64,24},{64,10},{56,10}},color={0,0,0},smooth=Smooth.None),Line(points={{86,-24},{64,-24},{64,-12},{56,-12}},color={0,0,0},smooth=Smooth.None),Line(points={{-96,100},{-80,100},{-80,4}},color={0,0,0},smooth=Smooth.None),Line(points={{100,100},{80,100},{80,-2}},color={0,0,0},smooth=Smooth.None),Line(points={{0,72},{0,40},{-20,40},{-20,2}},color={0,0,0},smooth=Smooth.None),Line(points={{0,40},{20,40},{20,2}},color={0,0,0},smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Line(points={{-68,24},{-68,52}},color={0,0,255},smooth=Smooth.None),Polygon(points={{-68,70},{-74,52},{-62,52},{-68,70}},lineColor={0,0,255},smooth=Smooth.None,fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-56,62},{-38,50}},lineColor={0,0,255},textString="x"),Line(points={{-62,30},{-94,30}},color={0,0,255},smooth=Smooth.None),Polygon(points={{-90,36},{-90,24},{-108,30},{-90,36}},lineColor={0,0,255},smooth=Smooth.None,fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-114,50},{-96,38}},lineColor={0,0,255},textString="y")}));
 end RollingWheelSet;

 package Assemblies
  "Joint aggregations for analytic loop handling"
  extends Modelica.Icons.Package;

  import SI = Modelica.SIunits;

  model JointUPS
   "Universal - prismatic - spherical joint aggregation (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointUPS
      model _famefaults_bearing = FAME.Dampers.TranslationalWithoutConnectEquations;
      model _famefaults_axis = FAME.Dampers.TranslationalWithoutConnectEquations;

  // components of JointUPS
   parameter Modelica.SIunits.Diameter axisDiameter=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Diameter of cylinder on the connecting line from frame_a to frame_b" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Length axisLength "Distance between frame_a and frame_b";
   parameter Boolean showUniversalAxes=true " = true, if universal joint shall be visualized with two cylinders, otherwise with a sphere (provided animation=true)";
   final parameter Real e3_ia[3](each final unit="1")=cross(eAxis_ia,e2_ia) "Unit vector perpendicular to eAxis_ia and e2_ia, resolved in frame_ia";
   Modelica.SIunits.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   parameter Modelica.SIunits.Position nAxis_ia[3]={1,0,0} "Axis vector along line from origin of frame_a to origin of frame_b, resolved in frame_ia" annotation(Evaluate=true);
   input Modelica.Mechanics.MultiBody.Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of spheres representing the spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at prismatic joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_ia "Coordinate system at origin of frame_a fixed at prismatic joint" annotation(Placement(transformation(origin={-80,100},extent={{-8,-8},{8,8}},rotation=270)));
   Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing of the prismatic joint" annotation(Placement(transformation(extent={{-35,95},{-45,105}},rotation=0)));
   FAME.Dampers.TranslationalWithoutConnectEquations _famefault_bearing(amount=0.0);
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   parameter Modelica.SIunits.Position s_offset=0 "Relative distance offset (distance between frame_a and frame_b = s(t) + s_offset)";
   final parameter Real e2_ia[3](each final unit="1")=Modelica.Math.Vectors.normalize(cross(n1_a,eAxis_ia),0.0) "Unit vector in direction of second rotation axis of universal joint, resolved in frame_ia";
   final parameter Real eAxis_ia[3](each final unit="1")=Modelica.Math.Vectors.normalize(nAxis_ia,0.0) "Unit vector from origin of frame_a to origin of frame_b, resolved in frame_ia";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   parameter Modelica.SIunits.Diameter sphereDiameter=world.defaultJointLength "Diameter of spheres representing the spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the prismatic joint" annotation(Placement(transformation(extent={{45,95},{35,105}},rotation=0)));
   FAME.Dampers.TranslationalWithoutConnectEquations _famefault_axis(amount=0.0);
   Modelica.SIunits.Force f "= axis.f (driving force in the axis; = -bearing.f)";
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   Modelica.SIunits.Position s "Relative distance between frame_a and frame_b along axis nAxis = s + s_offset";
   input Modelica.Mechanics.MultiBody.Types.Color axisColor=Modelica.Mechanics.MultiBody.Types.Defaults.SensorColor "Color of cylinder on the connecting line from frame_a to frame_b" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis n1_a={0,0,1} "Axis 1 of universal joint resolved in frame_a (axis 2 is orthogonal to axis 1 and to line from universal to spherical joint)" annotation(Evaluate=true);
  protected
   Modelica.Mechanics.MultiBody.Frames.Orientation R_ia2_a;
   Modelica.SIunits.Torque t_cd_a[3] "frame_ia.t + frame_ib.t resolved in frame_a";
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape axisCylinder(shapeType="cylinder",color=axisColor,specularCoefficient=specularCoefficient,length=axisLength,width=axisDiameter,height=axisDiameter,lengthDirection=eAxis_ia,widthDirection=e2_ia,r=frame_ia.r_0,R=frame_ia.R) if world.enableAnimation and animation;
   Modelica.SIunits.Position rAxis_a[3] "Position vector from origin of frame_a to origin of frame_b resolved in frame_a";
   Modelica.SIunits.AngularVelocity w_rel_ia1[3];
   Real eAxis_a[3](each final unit="1") "Unit vector in direction of rAxis_a, resolved in frame_a";
   Real e3_a[3](each final unit="1") "Unit vector perpendicular to eAxis_a and e2_a, resolved in frame_a";
   Modelica.SIunits.Length length_n2_a "Length of vector n2_a";
   Real e2_a[3](each final unit="1") "Unit vector in direction of second rotation axis of universal joint, resolved in frame_a";
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape universalShape1(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=n1_a,widthDirection={0,1,0},r_shape=(-n1_a)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if (world.enableAnimation and animation) and showUniversalAxes;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape universalShape2(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e2_ia,widthDirection={0,1,0},r_shape=(-e2_ia)*cylinderLength/(2),r=frame_ia.r_0,R=frame_ia.R) if (world.enableAnimation and animation) and showUniversalAxes;
   Modelica.Mechanics.MultiBody.Frames.Orientation R_ia_a "Rotation from frame_a to frame_ia";
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape sphericalShape_a(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection={1,0,0},widthDirection={0,1,0},r_shape={-0.5,0,0}*sphereDiameter,r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape sphericalShape_b(shapeType="sphere",color=sphereColor,specularCoefficient=specularCoefficient,length=sphereDiameter,width=sphereDiameter,height=sphereDiameter,lengthDirection={1,0,0},widthDirection={0,1,0},r_shape={-0.5,0,0}*sphereDiameter,r=frame_b.r_0,R=frame_b.R) if world.enableAnimation and animation;
   Modelica.SIunits.Position rAxis_0[3] "Position vector from origin of frame_a to origin of frame_b resolved in world frame";
   Real length2_n2_a(unit="m2") "Square of length of vector n2_a";
   Real n2_a[3](each final unit="1") "Vector in direction of second rotation axis of universal joint, resolved in frame_a";
   Real der_rAxis_a_L[3](each unit="1/s") "= der(rAxis_a)/axisLength";
   Modelica.Mechanics.MultiBody.Frames.Orientation R_ia1_a;
   Modelica.SIunits.Force f_bd_a[3] "frame_b.f + frame_ib.f resolved in frame_a";
   Modelica.SIunits.Force f_c_a[3] "frame_ia.f resolved in frame_a";
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointUPS
  equation
   Connections.branch(frame_a.R,frame_ia.R);
   Connections.branch(frame_ia.R,frame_ib.R);
   axisLength = s+s_offset;
   _famefault_bearing.port_b.s = 0;
   _famefault_axis.port_b.s = s;
   _famefault_axis.port_b.f = f;
   rAxis_0 = frame_b.r_0-frame_a.r_0;
   rAxis_a = Frames.resolve2(frame_a.R,rAxis_0);
   axisLength = sqrt(rAxis_0*rAxis_0);
   assert(axisLength>1.0e-15,"
Distance between frame_a and frame_b of a JointUPS joint
became zero. This is not allowed. If this occurs during
initialization, the initial conditions are probably wrong.");
   eAxis_a = rAxis_a/(axisLength);
   n2_a = cross(n1_a,eAxis_a);
   length2_n2_a = n2_a*n2_a;
   assert(noEvent(length2_n2_a>1.e-10),"
A Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUPS joint (consisting of
a universal, prismatic and spherical joint) is in the singular
configuration of the universal joint. This means that axis 1 of
the universal joint defined via parameter \"n1_a\" is parallel to vector
\"eAxis_ia\" that is directed from the origin of frame_a to the
origin of frame_b. You may try to use another \"n1_a\" vector.
");
   length_n2_a = sqrt(length2_n2_a);
   e2_a = n2_a/(length_n2_a);
   e3_a = cross(eAxis_a,e2_a);
   der_rAxis_a_L = (Frames.resolve2(frame_a.R,der(rAxis_0))-cross(frame_a.R.w,rAxis_a))/(axisLength);
   w_rel_ia1 = {e3_a*cross(n1_a,der_rAxis_a_L)/(length_n2_a),(-e3_a)*der_rAxis_a_L,e2_a*der_rAxis_a_L};
   R_ia1_a = Frames.from_T(transpose([eAxis_a, e2_a, e3_a]),w_rel_ia1);
   R_ia2_a = Frames.from_T([eAxis_ia, e2_ia, e3_ia],zeros(3));
   R_ia_a = Frames.absoluteRotation(R_ia1_a,R_ia2_a);
   frame_ia.r_0 = frame_a.r_0;
   frame_ib.r_0 = frame_b.r_0;
   frame_ia.R = Frames.absoluteRotation(frame_a.R,R_ia_a);
   frame_ib.R = frame_ia.R;
   f_c_a = Frames.resolve1(R_ia_a,frame_ia.f);
   t_cd_a = Frames.resolve1(R_ia_a,frame_ia.t+frame_ib.t);
   f_bd_a = (-eAxis_a)*f-e2_a*n1_a*t_cd_a/(axisLength*n1_a*e3_a)+e3_a*e2_a*t_cd_a/(axisLength);
   zeros(3) = frame_b.f+Frames.resolveRelative(frame_ib.f,frame_ib.R,frame_b.R)-Frames.resolveRelative(f_bd_a,frame_a.R,frame_b.R);
   zeros(3) = frame_b.t;
   zeros(3) = frame_a.f+f_c_a+f_bd_a;
   zeros(3) = frame_a.t+t_cd_a+cross(rAxis_a,f_bd_a);
   if checkTotalPower then
    totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+frame_ia.f*Frames.resolve2(frame_ia.R,der(frame_ia.r_0))+frame_ib.f*Frames.resolve2(frame_ib.R,der(frame_ib.r_0))+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R)+frame_ia.t*Frames.angularVelocity2(frame_ia.R)+frame_ib.t*Frames.angularVelocity2(frame_ib.R)+_famefault_axis.port_b.f*der(_famefault_axis.port_b.s)+_famefault_bearing.port_b.f*der(_famefault_bearing.port_b.s);
   else
    totalPower = 0;
   end if;
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(bearing,_famefault_bearing.port_a);
   connect(axis,_famefault_axis.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of a <b>universal</b> joint at frame_a,
a <b>spherical</b> joint at frame_b and a <b>prismatic</b> joint along the
line connecting the origin of frame_a and the origin of frame_b,
see the default animation in the following figure (the axes vectors
are not part of the default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointUPS.png\" ALT=\"model Joints.Assemblies.JointUPS\">

<p>
This joint aggregation has no mass and no inertia and
introduces neither constraints nor potential state variables.
It is especially useful to build up more complicated force elements
where the mass and/or inertia of the force element shall be taken
into account.
</p>
<p>
The universal joint is defined in the following way:
<p>
<ul>
<li> The rotation <b>axis</b> of revolute joint <b>1</b> is along parameter
     vector n1_a which is fixed in frame_a.<li>
<li> The rotation <b>axis</b> of revolute joint <b>2</b> is perpendicular to
     axis 1 and to the line connecting the universal and the spherical joint.
</ul>
<p>
The definition of axis 2 of the universal joint is performed according
to the most often occuring case. In a future release, axis 2 might
be explicitly definable via a parameter. However, the treatment is much more
complicated and the number of operations is considerably higher,
if axis 2 is not orthogonal to axis 1 and to the connecting rod.
</p>
<p>
Note, there is a <b>singularity</b> when axis 1 and the connecting line are parallel
to each other. Therefore, if possible n1_a should be selected in such a way that it
is perpendicular to nAxis_ia in the initial configuration (i.e., the
distance to the singularity is as large as possible).
</p>
<p>
An additional <b>frame_ia</b> is present. It is <b>fixed</b> on the line
connecting the universal and the spherical joint at the
origin of <b>frame_a</b>. The placement of frame_ia on this line
is implicitly defined by the universal joint (frame_a and frame_ia coincide
when the angles of the two revolute joints of the universal joint are zero)
and by parameter vector <b>nAxis_ia</b>, an axis vector directed
along the line from the origin of frame_a to the spherical joint,
resolved in frame_<b>ia</b>.
</p>
<p>
An additional <b>frame_ib</b> is present. It is <b>fixed</b> in the line
connecting the prismatic and the spherical joint at the
origin of <b>frame_b</b>.
It is always parallel to <b>frame_ia</b>.
</p>
<p>
Note, this joint aggregation can be used in cases where
in reality a rod with spherical joints at each end are present.
Such a system has an additional degree of freedom to rotate
the rod along its axis. In practice this rotation is usually
of no interested and is mathematically removed by replacing one
of the spherical joints by a universal joint.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_a, frame_ia and frame_ib of the JointUSP joint
should be parallel to each other when defining an instance of this
component).
</p>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Text(extent={{-140,-50},{140,-75}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-100,-40},{-19,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-90,-30},{-29,29}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-60,41},{-9,-44}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-60,40},{-60,-40}},color={0,0,0},thickness=0.5),Ellipse(extent={{-83,-17},{-34,21}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-74,-12},{-40,15}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-72,-20},{-89,3},{-69,25},{-45,27},{-72,-20}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-60,40},{-60,-10}},color={0,0,0},thickness=0.5),Line(points={{-49,20},{-69,-15}},color={0,0,0},thickness=0.5),Ellipse(extent={{44,14},{73,-14}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{20,-40},{100,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{30,-30},{90,30}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-22,45},{40,-43}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{45,14},{74,-14}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Text(extent={{-98,84},{-60,65}},lineColor={128,128,128},textString="ia"),Line(points={{-40,0},{-40,90},{-80,90},{-80,97}},color={95,95,95},thickness=0.5),Text(extent={{61,86},{109,64}},lineColor={128,128,128},textString="ib"),Rectangle(extent={{-35,-13},{-6,14}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-35,14},{-6,18}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-6,-7},{46,6}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-6,6},{46,10}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-6,-13},{-6,18}},color={0,0,0}),Line(points={{60,-1},{60,90},{80,90},{80,97}},color={95,95,95},thickness=0.5),Line(points={{60,90},{40,90},{40,95}},color={95,95,95},thickness=0.5),Line(points={{-30,70},{10,70}},color={0,0,0}),Polygon(points={{30,70},{10,76},{10,63},{30,70}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Line(points={{-40,90},{-40,90},{-40,95}},color={95,95,95},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Line(points={{-60,-70},{46,-70}},color={0,0,255}),Polygon(points={{60,-70},{45,-64},{45,-76},{60,-70}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Text(extent={{-62,-73},{65,-90}},textString="rAxis",lineColor={0,0,255}),Ellipse(extent={{-100,-40},{-19,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-90,-30},{-29,29}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-60,41},{-19,-41}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-60,40},{-60,-40}},color={0,0,0},thickness=0.5),Ellipse(extent={{-83,-17},{-34,21}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-74,-12},{-40,15}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-72,-20},{-89,3},{-69,25},{-45,27},{-72,-20}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-60,40},{-60,-10}},color={0,0,0},thickness=0.5),Line(points={{-49,20},{-69,-15}},color={0,0,0},thickness=0.5),Line(points={{-40,0},{-40,90},{-80,90},{-80,99}},color={95,95,95},thickness=0.5),Polygon(points={{7,-1},{-5,2},{-5,-4},{7,-1}},lineColor={0,0,255}),Line(points={{-50,19},{-30,57}},color={0,0,255}),Text(extent={{-24,74},{7,53}},lineColor={0,0,0},textString="e2"),Polygon(points={{-25,64},{-33,56},{-27,53},{-25,64}},lineColor={0,0,255}),Line(points={{-60,41},{-60,65}},color={0,0,255}),Polygon(points={{-60,75},{-64,63},{-56,63},{-60,75}},lineColor={0,0,255}),Text(extent={{-96,82},{-65,61}},lineColor={0,0,0},textString="n1"),Line(points={{-60,-40},{-60,-72}},color={0,0,255}),Ellipse(extent={{20,-40},{100,40}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{30,-30},{90,30}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-22,45},{40,-43}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{45,14},{74,-14}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={128,128,128}),Line(points={{60,0},{60,-74}},color={0,0,255}),Rectangle(extent={{-35,14},{-6,18}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-35,-13},{-6,14}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-6,6},{46,10}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-6,-7},{46,6}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-6,-13},{-6,18}},color={0,0,0}),Text(extent={{-40,-2},{-1,-16}},lineColor={0,0,0},textString="nAxis"),Line(points={{-61,1},{-2,1}},color={0,0,255}),Polygon(points={{10,1},{-2,4},{-2,-2},{10,1}},lineColor={0,0,255}),Line(points={{60,-1},{60,90},{80,90},{80,99}},color={95,95,95},thickness=0.5),Text(extent={{-24,117},{-9,102}},textString="f",lineColor={0,0,255}),Polygon(points={{-26,103},{-36,100},{-26,97},{-26,103}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Polygon(points={{26,103},{36,100},{26,97},{26,103}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Line(points={{14,100},{36,100}},color={0,0,255}),Text(extent={{12,116},{27,101}},textString="f",lineColor={0,0,255}),Polygon(points={{30,93},{40,90},{30,87},{30,93}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Line(points={{-40,90},{40,90}},color={128,128,128}),Line(points={{-25,100},{-10,100}},color={0,0,255}),Text(extent={{-18,90},{19,77}},lineColor={128,128,128},textString="s"),Line(points={{60,90},{40,90},{40,98}},color={95,95,95},thickness=0.5),Line(points={{-40,90},{-40,96},{-40,98}},color={135,135,135},thickness=0.5)}));
  end JointUPS;

  model JointUSR
   "Universal - spherical - revolute joint aggregation (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointUSR
      model _famefaults_axis = FAME.Dampers.RotationalWithConnectEquations;
      model _famefaults_bearing = FAME.Dampers.RotationalWithConnectEquations;

  // components of JointUSR
   final parameter Real eRod1_ia[3](each final unit="1")=rod1.eRod_ia "Unit vector from origin of frame_a to origin of spherical joint, resolved in frame_ia";
   parameter Modelica.SIunits.Diameter rod1Diameter=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Diameter of rod 1 connecting the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Distance revoluteLength=world.defaultJointLength "Length of cylinder representing the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Sensors.RelativePosition relativePosition(resolveInFrame=Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.frame_a) annotation(Placement(transformation(extent={{60,-70},{40,-90}},rotation=0)));
   input Modelica.Mechanics.MultiBody.Types.Color revoluteColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder representing the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   Modelica.Mechanics.MultiBody.Joints.Internal.RevoluteWithLengthConstraint revolute(animation=animation,lengthConstraint=rod1Length,n=n_b,phi_offset=phi_offset,phi_guess=phi_guess,cylinderDiameter=revoluteDiameter,cylinderLength=revoluteLength,cylinderColor=revoluteColor,specularCoefficient=specularCoefficient) annotation(Placement(transformation(extent={{75,-20},{35,20}},rotation=0)));
   input Modelica.Mechanics.MultiBody.Types.Color rod1Color=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of rod 1 connecting the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Force f_rod "Constraint force in direction of the rod (positive, if rod is pressed)";
   Modelica.SIunits.Position aux "Denominator used to compute force in rod connecting universal and spherical joint";
   parameter Boolean showUniversalAxes=true " = true, if universal joint shall be visualized with two cylinders, otherwise with a sphere (provided animation=true)";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_guess=0 "Select the configuration such that at initial time |phi(t0) - from_deg(phi_guess)|is minimal";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_offset=0 "Relative angle offset of revolute joint (angle = phi(t) + from_deg(phi_offset))";
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={0,0,1} "Axis of revolute joint fixed and resolved in frame_b" annotation(Evaluate=true);
   final parameter Real e2_ia[3](each final unit="1")=rod1.e2_ia "Unit vector in direction of axis 2 of universal joint, resolved in frame_ia";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   input Modelica.Mechanics.MultiBody.Types.Color rod2Color=rod1Color "Color of rod 2 connecting the revolute and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Diameter sphereDiameter=world.defaultJointLength "Diameter of the spheres representing the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position rRod1_ia[3]={1,0,0} "Vector from origin of frame_a to spherical joint, resolved in frame_ia" annotation(Evaluate=true);
   final parameter Modelica.SIunits.Distance rod1Length=rod1.rodLength "Length of rod 1 (= distance between universal and spherical joint";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the revolute joint" annotation(Placement(transformation(extent={{105,85},{95,75}},rotation=0)));
   FAME.Dampers.RotationalWithConnectEquations _famefault_axis(amount=0.0);
   parameter Modelica.SIunits.Diameter revoluteDiameter=world.defaultJointWidth "Diameter of cylinder representing the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   Modelica.Mechanics.MultiBody.Parts.FixedTranslation rod2(animation=animation,width=rod2Diameter,height=rod2Diameter,color=rod2Color,specularCoefficient=specularCoefficient,r=rRod2_ib) annotation(Placement(transformation(extent={{15,-20},{-25,20}},rotation=0)));
   Modelica.Mechanics.MultiBody.Joints.UniversalSpherical rod1(animation=animation,showUniversalAxes=showUniversalAxes,rRod_ia=rRod1_ia,n1_a=n1_a,sphereDiameter=sphereDiameter,sphereColor=sphereColor,rodWidth=rod1Diameter,rodHeight=rod1Diameter,rodColor=rod1Color,cylinderLength=cylinderLength,cylinderDiameter=cylinderDiameter,cylinderColor=cylinderColor,specularCoefficient=specularCoefficient,kinematicConstraint=false,constraintResidue=rod1.f_rod-f_rod) annotation(Placement(transformation(extent={{-92,-20},{-52,20}},rotation=0)));
   parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_im "Coordinate system at origin of spherical joint fixed at connecting rod of spherical and revolute joint" annotation(Placement(transformation(origin={0,100},extent={{8,-8},{-8,8}},rotation=270)));
   parameter Modelica.SIunits.Position rRod2_ib[3]={-1,0,0} "Vector from origin of frame_ib to spherical joint, resolved in frame_ib";
   input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   input Modelica.Mechanics.MultiBody.Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of the spheres representing the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at connecting rod of spherical and revolute joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Blocks.Sources.Constant position_b[3](k=rRod2_ib) annotation(Placement(transformation(extent={{-20,-50},{0,-30}},rotation=0)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_ia "Coordinate system at origin of frame_a fixed at connecting rod of universal and spherical joint" annotation(Placement(transformation(origin={-80,100},extent={{-8,-8},{8,8}},rotation=90)));
   parameter Modelica.SIunits.Diameter rod2Diameter=rod1Diameter "Diameter of rod 2 connecting the revolute and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing of the revolute joint" annotation(Placement(transformation(extent={{95,45},{105,35}},rotation=0)));
   FAME.Dampers.RotationalWithConnectEquations _famefault_bearing(amount=0.0);
   parameter Modelica.Mechanics.MultiBody.Types.Axis n1_a={0,0,1} "Axis 1 of universal joint fixed and resolved in frame_a (axis 2 is orthogonal to axis 1 and to rod 1)" annotation(Evaluate=true);
  protected
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointUSR
  equation
   aux = cross(revolute.e,rRod2_ib)*Frames.resolveRelative(rod1.eRod_a,rod1.frame_a.R,rod1.frame_b.R);
   f_rod = (-revolute.tau-revolute.e*(frame_ib.t+frame_im.t+cross(rRod2_ib,frame_im.f)-cross(rRod2_ib,Frames.resolveRelative(rod1.f_b_a1,rod1.frame_a.R,rod1.frame_b.R))))/(noEvent((if abs(aux)<1.e-10 then 1.e-10 else aux)));
   if checkTotalPower then
    totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+frame_ia.f*Frames.resolve2(frame_ia.R,der(frame_ia.r_0))+frame_ib.f*Frames.resolve2(frame_ib.R,der(frame_ib.r_0))+frame_im.f*Frames.resolve2(frame_im.R,der(frame_im.r_0))+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R)+frame_ia.t*Frames.angularVelocity2(frame_ia.R)+frame_ib.t*Frames.angularVelocity2(frame_ib.R)+frame_im.t*Frames.angularVelocity2(frame_im.R)+_famefault_axis.port_b.tau*der(_famefault_axis.port_b.phi)+_famefault_bearing.port_b.tau*der(_famefault_bearing.port_b.phi);
   else
    totalPower = 0;
   end if;
   connect(revolute.frame_b,rod2.frame_a) annotation(Line(points={{35,0},{15,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_b,rod1.frame_b) annotation(Line(points={{-25,0},{-52,0}},color={95,95,95},thickness=0.5));
   connect(revolute.frame_a,frame_b) annotation(Line(points={{75,0},{100,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_a,frame_ib) annotation(Line(points={{15,0},{26,0},{26,70},{80,70},{80,100}},color={95,95,95},thickness=0.5));
   connect(rod1.frame_a,frame_a) annotation(Line(points={{-92,0},{-100,0}},color={95,95,95},thickness=0.5));
   connect(relativePosition.frame_b,frame_a) annotation(Line(points={{40,-80},{-96,-80},{-96,0},{-100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(relativePosition.frame_a,frame_b) annotation(Line(points={{60,-80},{96,-80},{96,0},{100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(position_b.y,revolute.position_b) annotation(Line(points={{1,-40},{20,-40},{20,-12},{31,-12}},color={0,0,127}));
   connect(rod2.frame_b,frame_im) annotation(Line(points={{-25,0},{-40,0},{-40,80},{0,80},{0,100}},color={95,95,95},thickness=0.5));
   connect(rod1.frame_ia,frame_ia) annotation(Line(points={{-80,20},{-80,100}},color={95,95,95},thickness=0.5));
   connect(revolute.axis,_famefault_axis.port_b) annotation(Line(points={{55,20},{55,60},{90,60},{90,80},{100,80}},color={0,0,0}));
   connect(relativePosition.r_rel,revolute.position_a) annotation(Line(points={{50,-69},{50,-40},{90,-40},{90,-12},{79,-12}},color={0,0,127},smooth=Smooth.None));
   connect(revolute.bearing,_famefault_bearing.port_b) annotation(Line(points={{67,20},{67,40},{100,40}},color={0,0,0},smooth=Smooth.None));
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of a <b>universal</b> joint at frame_a, a <b>revolute</b>
joint at frame_b and a <b>spherical</b> joint which is connected via <b>rod1</b>
to the universal and via <b>rod2</b> to the revolute joint, see the default
animation in the following figure (the axes vectors are not part of the
default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointUSR.png\" ALT=\"model Joints.Assemblies.JointUSR\">

<p>
This joint aggregation has no mass and no inertia and
introduces neither constraints nor potential state variables.
It should be used in kinematic loops whenever possible since
the non-linear system of equations introduced by this joint aggregation
is solved <b>analytically</b> (i.e., a solution is always computed, if a
unique solution exists).
</p>
<p>
The universal joint is defined in the following way:
<p>
<ul>
<li> The rotation <b>axis</b> of revolute joint <b>1</b> is along parameter
     vector n1_a which is fixed in frame_a.<li>
<li> The rotation <b>axis</b> of revolute joint <b>2</b> is perpendicular to
     axis 1 and to the line connecting the universal and the spherical joint
     (= rod 1).
</ul>
<p>
The definition of axis 2 of the universal joint is performed according
to the most often occuring case. In a future release, axis 2 might
be explicitly definable via a parameter. However, the treatment is much more
complicated and the number of operations is considerably higher,
if axis 2 is not orthogonal to axis 1 and to the connecting rod.
</p>
<p>
Note, there is a <b>singularity</b> when axis 1 and the connecting rod are parallel
to each other. Therefore, if possible n1_a should be selected in such a way that it
is perpendicular to rRod1_ia in the initial configuration (i.e., the
distance to the singularity is as large as possible).
</p>
<p>
The rest of this joint aggregation is defined by the following parameters:
</p>
<ul>
<li> The position of the spherical joint with respect to the universal
     joint is defined by vector <b>rRod1_ia</b>. This vector is directed from
     frame_a to the spherical joint and is resolved in frame_ia
     (it is most simple to select frame_ia such that it is parallel to
     frame_a in the reference or initial configuration).</li>
<li> The position of the spherical joint with respect to the revolute
     joint is defined by vector <b>rRod2_ib</b>. This vector is directed from
     the inner frame of the revolute joint (frame_ib or revolute.frame_a)
     to the spherical joint and is resolved in frame_ib (note, that frame_ib
     and frame_b are parallel to each other).</li>
<li> The axis of rotation of the revolute joint is defined by axis
     vector <b>n_b</b>. It is fixed and resolved in frame_b.</li>
<li> When specifying this joint aggregation with the definitions above, <b>two</b>
     different <b>configurations</b> are possible. Via parameter <b>phi_guess</b>
     a guess value for revolute.phi(t0) at the initial time t0 is given. The configuration
     is selected that is closest to phi_guess (|revolute.phi - phi_guess|is minimal).
</ul>
<p>
An additional <b>frame_ia</b> is present. It is <b>fixed</b> in the rod
connecting the universal and the spherical joint at the
origin of <b>frame_a</b>. The placement of frame_ia on the rod
is implicitly defined by the universal joint (frame_a and frame_ia coincide
when the angles of the two revolute joints of the universal joint are zero)
and by parameter vector <b>rRod1_ia</b>, the position vector
from the origin of frame_a to the spherical joint, resolved in frame_<b>ia</b>.
</p>
<p>
An additional <b>frame_ib</b> is present. It is <b>fixed</b> in the rod
connecting the revolute and the spherical joint at the side of the revolute
joint that is connected to this rod (= rod2.frame_a = revolute.frame_a).
</p>
<p>
An additional <b>frame_im</b> is present. It is <b>fixed</b> in the rod
connecting the revolute and the spherical joint at the side of the spherical
joint that is connected to this rod (= rod2.frame_b).
It is always parallel to <b>frame_ib</b>.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_a and frame_ia of the JointUSR joint
should be parallel to each other when defining an instance of this
component).
</p>
<p>
In the public interface of the JointUSR joint, the following
(final) <b>parameters</b> are provided:
</p>
<pre>
  <b>parameter</b> Real rod1Length(unit=\"m\")  \"Length of rod 1\";
  <b>parameter</b> Real eRod1_ia[3] \"Unit vector along rod 1, resolved in frame_ia\";
  <b>parameter</b> Real e2_ia  [3]  \"Unit vector along axis 2, resolved in frame_ia\";
</pre>
<p>
This allows a more convenient definition of data which is related to rod 1.
For example, if a box shall be connected at frame_ia directing from
the origin of frame_a to the middle of rod 1, this might be defined as:
</p>
<pre>
    Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUSP jointUSR(rRod1_ia={1.2, 1, 0.2});
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape     shape(shapeType       = \"box\",
                                               lengthDirection = jointUSR.eRod1_ia,
                                               widthDirection  = jointUSR.e2_ia,
                                               length          = jointUSR.rod1Length/2,
                                               width           = jointUSR.rod1Length/10);
  <b>equation</b>
    <b>connect</b>(jointUSP.frame_ia, shape.frame_a);
</pre>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Text(extent={{-140,-41},{140,-66}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-100,-30},{-40,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-93,-22},{-48,23}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-70,40},{-39,-33}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-70,28},{-70,-30}},color={0,0,0},thickness=0.5),Ellipse(extent={{-89,-18},{-48,18}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-84,-12},{-53,13}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-81,-17},{-92,-1},{-83,16},{-57,24},{-81,-17}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-70,30},{-70,-10}},color={0,0,0},thickness=0.5),Line(points={{-61,16},{-79,-15}},color={0,0,0},thickness=0.5),Line(points={{-50,0},{-50,80},{-80,80},{-80,100}},color={95,95,95},thickness=0.5),Ellipse(extent={{-40,-30},{20,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-33,-22},{12,23}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-44,31},{-14,-30}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-23,10},{-3,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{19,6},{61,-6}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-50,5},{-21,-5}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{60,-30},{76,30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{85,-30},{100,30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{76,10},{85,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{60,30},{76,-30}},lineColor={0,0,0}),Rectangle(extent={{85,30},{100,-30}},lineColor={0,0,0}),Text(extent={{40,109},{77,91}},lineColor={128,128,128},textString="ib"),Text(extent={{-124,109},{-95,92}},lineColor={128,128,128},textString="ia"),Line(points={{60,30},{60,80},{80,80},{80,100}},color={95,95,95},thickness=0.5),Text(extent={{-43,108},{-10,92}},lineColor={128,128,128},textString="im"),Line(points={{19,6},{19,80},{0,80},{0,100}},color={95,95,95},thickness=0.5),Line(points={{80,80},{101,80}},color={128,128,128},thickness=0.5),Line(points={{90,30},{90,40},{95,40}},color={95,95,95},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics));
  end JointUSR;

  model JointUSP
   "Universal - spherical - prismatic joint aggregation (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointUSP
      model _famefaults_axis = FAME.Dampers.TranslationalWithConnectEquations;
      model _famefaults_bearing = FAME.Dampers.TranslationalWithConnectEquations;

  // components of JointUSP
   final parameter Real eRod1_ia[3](each final unit="1")=rod1.eRod_ia "Unit vector from origin of frame_a to origin of spherical joint, resolved in frame_ia";
   parameter Modelica.SIunits.Position s_guess=0 "Select the configuration such that at initial time |s(t0)-s_guess|is minimal";
   parameter Modelica.SIunits.Diameter rod1Diameter=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Diameter of rod 1 connecting the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Sensors.RelativePosition relativePosition(resolveInFrame=Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.frame_a) annotation(Placement(transformation(extent={{50,-70},{30,-90}},rotation=0)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   input Modelica.Mechanics.MultiBody.Types.Color rod1Color=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of rod 1 connecting the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Force f_rod "Constraint force in direction of the rod (positive, if rod is pressed)";
   parameter Modelica.SIunits.Distance boxHeight=boxWidth "Height of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position s_offset=0 "Relative distance offset of prismatic joint (distance between the prismatic joint frames = s(t) + s_offset)";
   parameter Boolean showUniversalAxes=true " = true, if universal joint shall be visualized with two cylinders, otherwise with a sphere (provided animation=true)";
   Modelica.Mechanics.MultiBody.Joints.Internal.PrismaticWithLengthConstraint prismatic(animation=animation,length=rod1.rodLength,n=n_b,s_offset=s_offset,s_guess=s_guess,boxWidthDirection=boxWidthDirection,boxWidth=boxWidth,boxHeight=boxHeight,boxColor=boxColor,specularCoefficient=specularCoefficient) annotation(Placement(transformation(extent={{76,-20},{36,20}},rotation=0)));
   parameter Modelica.SIunits.Distance boxWidth=world.defaultJointWidth "Width of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis boxWidthDirection={0,1,0} "Vector in width direction of prismatic joint, resolved in frame_b" annotation(Evaluate=true,Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={-1,0,0} "Axis of prismatic joint fixed and resolved in frame_b" annotation(Evaluate=true);
   final parameter Real e2_ia[3](each final unit="1")=rod1.e2_ia "Unit vector in direction of axis 2 of universal joint, resolved in frame_ia";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   input Modelica.Mechanics.MultiBody.Types.Color rod2Color=rod1Color "Color of rod 2 connecting the prismatic and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Diameter sphereDiameter=world.defaultJointLength "Diameter of the spheres representing the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position rRod1_ia[3]={1,0,0} "Vector from origin of frame_a to spherical joint, resolved in frame_ia" annotation(Evaluate=true);
   final parameter Modelica.SIunits.Distance rod1Length=rod1.rodLength "Length of rod 1 (= distance between universal and spherical joint";
   Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the prismatic joint" annotation(Placement(transformation(extent={{95,75},{105,85}},rotation=0)));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_axis(amount=0.0);
   Modelica.SIunits.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   Modelica.Mechanics.MultiBody.Parts.FixedTranslation rod2(animation=animation,r=rRod2_ib,width=rod2Diameter,height=rod2Diameter,specularCoefficient=specularCoefficient,color=rod2Color) annotation(Placement(transformation(extent={{0,20},{-40,-20}},rotation=0)));
   Modelica.Mechanics.MultiBody.Joints.UniversalSpherical rod1(animation=animation,showUniversalAxes=showUniversalAxes,rRod_ia=rRod1_ia,n1_a=n1_a,sphereDiameter=sphereDiameter,sphereColor=sphereColor,rodWidth=rod1Diameter,rodHeight=rod1Diameter,rodColor=rod1Color,specularCoefficient=specularCoefficient,cylinderLength=cylinderLength,cylinderDiameter=cylinderDiameter,cylinderColor=cylinderColor,kinematicConstraint=false,constraintResidue=rod1.f_rod-f_rod) annotation(Placement(transformation(extent={{-92,-20},{-52,20}},rotation=0)));
   parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_im "Coordinate system at origin of spherical joint fixed at connecting rod of spherical and prismatic joint" annotation(Placement(transformation(origin={0,100},extent={{8,-8},{-8,8}},rotation=270)));
   parameter Modelica.SIunits.Position rRod2_ib[3]={-1,0,0} "Vector from origin of frame_ib to spherical joint, resolved in frame_ib (frame_ib is parallel to frame_b)" annotation(Evaluate=true);
   input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   input Modelica.Mechanics.MultiBody.Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of the spheres representing the universal and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the two universal joint axes" annotation(Dialog(tab="Animation",group="if animation = true and showUniversalAxes",enable=animation and showUniversalAxes));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at connecting rod of spherical and prismatic joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Blocks.Sources.Constant position_b[3](k=rRod2_ib) annotation(Placement(transformation(extent={{-20,-60},{0,-40}},rotation=0)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_ia "Coordinate system at origin of frame_a fixed at connecting rod of universal and spherical joint" annotation(Placement(transformation(origin={-80,100},extent={{-8,-8},{8,8}},rotation=90)));
   parameter Modelica.SIunits.Diameter rod2Diameter=rod1Diameter "Diameter of rod 2 connecting the prismatic and the spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing of the prismatic joint" annotation(Placement(transformation(extent={{105,35},{95,45}},rotation=0)));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_bearing(amount=0.0);
   parameter Modelica.Mechanics.MultiBody.Types.Axis n1_a={0,0,1} "Axis 1 of universal joint fixed and resolved in frame_a (axis 2 is orthogonal to axis 1 and to rod 1)" annotation(Evaluate=true);
   input Modelica.Mechanics.MultiBody.Types.Color boxColor=sphereColor "Color of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  protected
   Real aux "Denominator used to compute force in rod connecting universal and spherical joint";
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointUSP
  equation
   aux = prismatic.e*Frames.resolveRelative(rod1.eRod_a,rod1.frame_a.R,rod1.frame_b.R);
   f_rod = (-prismatic.f-prismatic.e*(frame_ib.f+frame_im.f-Frames.resolveRelative(rod1.f_b_a1,rod1.frame_a.R,rod1.frame_b.R)))/(noEvent((if abs(aux)<1.e-10 then 1.e-10 else aux)));
   if checkTotalPower then
    totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+frame_ia.f*Frames.resolve2(frame_ia.R,der(frame_ia.r_0))+frame_ib.f*Frames.resolve2(frame_ib.R,der(frame_ib.r_0))+frame_im.f*Frames.resolve2(frame_im.R,der(frame_im.r_0))+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R)+frame_ia.t*Frames.angularVelocity2(frame_ia.R)+frame_ib.t*Frames.angularVelocity2(frame_ib.R)+frame_im.t*Frames.angularVelocity2(frame_im.R)+_famefault_axis.port_b.f*der(_famefault_axis.port_b.s)+_famefault_bearing.port_b.f*der(_famefault_bearing.port_b.s);
   else
    totalPower = 0;
   end if;
   connect(prismatic.frame_b,rod2.frame_a) annotation(Line(points={{36,0},{0,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_b,rod1.frame_b) annotation(Line(points={{-40,0},{-52,0}},color={0,0,0},thickness=0.5));
   connect(prismatic.frame_a,frame_b) annotation(Line(points={{76,0},{100,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_a,frame_ib) annotation(Line(points={{0,0},{7,0},{7,70},{80,70},{80,100}},color={95,95,95},thickness=0.5));
   connect(rod1.frame_a,frame_a) annotation(Line(points={{-92,0},{-100,0}},color={95,95,95},thickness=0.5));
   connect(relativePosition.frame_b,frame_a) annotation(Line(points={{30,-80},{-97,-80},{-97,0},{-100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(relativePosition.frame_a,frame_b) annotation(Line(points={{50,-80},{95,-80},{95,0},{100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(rod2.frame_b,frame_im) annotation(Line(points={{-40,0},{-46,0},{-46,80},{0,80},{0,100}},color={95,95,95},thickness=0.5));
   connect(rod1.frame_ia,frame_ia) annotation(Line(points={{-80,20},{-80,100}},color={95,95,95},thickness=0.5));
   connect(position_b.y,prismatic.position_b) annotation(Line(points={{1,-50},{10,-50},{10,-12},{32,-12}},color={0,0,127}));
   connect(prismatic.axis,_famefault_axis.port_b) annotation(Line(points={{40,14},{40,56},{90,56},{90,80},{100,80}},color={0,191,0}));
   connect(prismatic.bearing,_famefault_bearing.port_b) annotation(Line(points={{64,14},{64,40},{100,40}},color={0,191,0}));
   connect(relativePosition.r_rel,prismatic.position_a) annotation(Line(points={{40,-69},{40,-50},{90,-50},{90,-12},{80,-12}},color={0,0,127},smooth=Smooth.None));
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of a <b>universal</b> joint at frame_a, a <b>prismatic</b>
joint at frame_b and a <b>spherical</b> joint which is connected via <b>rod1</b>
to the universal and via <b>rod2</b> to the prismatic joint, see the default
animation in the following figure (the axes vectors are not part of the
default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointUSP.png\" ALT=\"model Joints.Assemblies.JointUSP\">

<p>
This joint aggregation has no mass and no inertia and
introduces neither constraints nor potential state variables.
It should be used in kinematic loops whenever possible since
the non-linear system of equations introduced by this joint aggregation
is solved <b>analytically</b> (i.e., a solution is always computed, if a
unique solution exists).
</p>
<p>
The universal joint is defined in the following way:
<p>
<ul>
<li> The rotation <b>axis</b> of revolute joint <b>1</b> is along parameter
     vector n1_a which is fixed in frame_a.<li>
<li> The rotation <b>axis</b> of revolute joint <b>2</b> is perpendicular to
     axis 1 and to the line connecting the universal and the spherical joint
     (= rod 1).
</ul>
<p>
The definition of axis 2 of the universal joint is performed according
to the most often occuring case. In a future release, axis 2 might
be explicitly definable via a parameter. However, the treatment is much more
complicated and the number of operations is considerably higher,
if axis 2 is not orthogonal to axis 1 and to the connecting rod.
</p>
<p>
Note, there is a <b>singularity</b> when axis 1 and the connecting rod are parallel
to each other. Therefore, if possible n1_a should be selected in such a way that it
is perpendicular to rRod1_ia in the initial configuration (i.e., the
distance to the singularity is as large as possible).
</p>
<p>
The rest of this joint aggregation is defined by the following parameters:
</p>
<ul>
<li> The position of the spherical joint with respect to the universal
     joint is defined by vector <b>rRod1_ia</b>. This vector is directed from
     frame_a to the spherical joint and is resolved in frame_ia
     (it is most simple to select frame_ia such that it is parallel to
     frame_a in the reference or initial configuration).</li>
<li> The position of the spherical joint with respect to the prismatic
     joint is defined by vector <b>rRod2_ib</b>. This vector is directed from
     the inner frame of the prismatic joint (frame_ib or prismatic.frame_a)
     to the spherical joint and is resolved in frame_ib (note, that frame_ib
     and frame_b are parallel to each other).</li>
<li> The axis of translation of the prismatic joint is defined by axis
     vector <b>n_b</b>. It is fixed and resolved in frame_b.</li>
<li> The two frames of the prismatic joint, i.e., frame_b and frame_ib,
     are parallel to each other.
     The distance between the origins of these two frames along axis n_b
     is equal to \"prismatic.s(t) + s_offset\", where \"prismatic.s(t)\" is
     a time varying variable and \"s_offset\" is a fixed, constant offset
     parameter.</li>
<li> When specifying this joint aggregation with the definitions above, <b>two</b>
     different <b>configurations</b> are possible. Via parameter <b>s_guess</b>
     a guess value for prismatic.s(t0) at the initial time t0 is given. The configuration
     is selected that is closest to s_guess (|prismatic.s - s_guess|is minimal).
</ul>
<p>
An additional <b>frame_ia</b> is present. It is <b>fixed</b> in the rod
connecting the universal and the spherical joint at the
origin of <b>frame_a</b>. The placement of frame_ia on the rod
is implicitly defined by the universal joint (frame_a and frame_ia coincide
when the angles of the two revolute joints of the universal joint are zero)
and by parameter vector <b>rRod1_ia</b>, the position vector
from the origin of frame_a to the spherical joint, resolved in frame_<b>ia</b>.
</p>
<p>
An additional <b>frame_ib</b> is present. It is <b>fixed</b> in the rod
connecting the prismatic and the spherical joint at the side of the prismatic
joint that is connected to this rod (= rod2.frame_a = prismatic.frame_a).
It is always parallel to <b>frame_b</b>.
</p>
<p>
An additional <b>frame_im</b> is present. It is <b>fixed</b> in the rod
connecting the prismatic and the spherical joint at the side of the spherical
joint that is connected to this rod (= rod2.frame_b).
It is always parallel to <b>frame_b</b>.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_a and frame_ia of the JointUSP joint
should be parallel to each other when defining an instance of this
component).
</p>
<p>
In the public interface of the JointUSP joint, the following
(final) <b>parameters</b> are provided:
</p>
<pre>
  <b>parameter</b> Real rod1Length(unit=\"m\")  \"Length of rod 1\";
  <b>parameter</b> Real eRod1_ia[3] \"Unit vector along rod 1, resolved in frame_ia\";
  <b>parameter</b> Real e2_ia  [3]  \"Unit vector along axis 2, resolved in frame_ia\";
</pre>
<p>
This allows a more convenient definition of data which is related to rod 1.
For example, if a box shall be connected at frame_ia directing from
the origin of frame_a to the middle of rod 1, this might be defined as:
</p>
<pre>
    Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUSP jointUSP(rRod1_ia={1.2, 1, 0.2});
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape     shape(shapeType       = \"box\",
                                               lengthDirection = jointUSP.eRod1_ia,
                                               widthDirection  = jointUSP.e2_ia,
                                               length          = jointUSP.rod1Length/2,
                                               width           = jointUSP.rod1Length/10);
  <b>equation</b>
    <b>connect</b>(jointUSP.frame_ia, shape.frame_a);
</pre>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Rectangle(extent={{50,20},{80,-20}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{80,30},{100,-30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{-140,-45},{140,-70}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-100,-30},{-40,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-93,-22},{-48,23}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-70,40},{-39,-33}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Line(points={{-70,28},{-70,-30}},color={0,0,0},thickness=0.5),Ellipse(extent={{-89,-18},{-48,18}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-84,-12},{-53,13}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Polygon(points={{-81,-17},{-92,-1},{-83,16},{-57,24},{-81,-17}},pattern=LinePattern.None,fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{-70,30},{-70,-10}},color={0,0,0},thickness=0.5),Line(points={{-61,16},{-79,-15}},color={0,0,0},thickness=0.5),Line(points={{-50,0},{-50,80},{-80,80},{-80,100}},color={95,95,95},thickness=0.5),Ellipse(extent={{-40,-30},{20,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-33,-22},{12,23}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-44,31},{-14,-30}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-23,10},{-3,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{19,6},{50,-6}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-50,5},{-21,-5}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{37,109},{68,90}},lineColor={128,128,128},textString="ib"),Text(extent={{-124,110},{-93,90}},lineColor={128,128,128},textString="ia"),Line(points={{50,6},{50,80},{80,80},{80,100}},color={95,95,95},thickness=0.5),Text(extent={{-44,111},{-8,91}},lineColor={128,128,128},textString="im"),Line(points={{19,6},{19,80},{0,80},{0,100}},color={95,95,95},thickness=0.5),Rectangle(extent={{80,24},{100,30}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{50,14},{80,20}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{95,80},{79,80}},color={135,135,135},thickness=0.5),Line(points={{95,40},{90,40},{90,30}},color={135,135,135},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Line(points={{-78,30},{-50,30}},color={128,128,128},arrow={Arrow.None,Arrow.Filled}),Text(extent={{-76,39},{-49,32}},lineColor={128,128,128},textString="rRod1_ia"),Text(extent={{-27,40},{0,33}},lineColor={128,128,128},textString="rRod2_ib"),Line(points={{3,30},{-43,30}},color={128,128,128},arrow={Arrow.None,Arrow.Filled})}));
  end JointUSP;

  model JointSSR
   "Spherical - spherical - revolute joint aggregation with mass (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointSSR
      model _famefaults_axis = FAME.Dampers.RotationalWithConnectEquations;
      model _famefaults_bearing = FAME.Dampers.RotationalWithConnectEquations;

  // components of JointSSR
   parameter Modelica.SIunits.Diameter rod1Diameter=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Diameter of rod 1 connecting the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Distance revoluteLength=world.defaultJointLength "Length of cylinder representing the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Sensors.RelativePosition relativePosition(resolveInFrame=Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.frame_a) annotation(Placement(transformation(extent={{60,-70},{40,-90}},rotation=0)));
   input Modelica.Mechanics.MultiBody.Types.Color revoluteColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder representing the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   Modelica.Mechanics.MultiBody.Joints.Internal.RevoluteWithLengthConstraint revolute(animation=animation,lengthConstraint=rod1Length,n=n_b,phi_offset=phi_offset,phi_guess=phi_guess,cylinderDiameter=revoluteDiameter,cylinderLength=revoluteLength,cylinderColor=revoluteColor,specularCoefficient=specularCoefficient) annotation(Placement(transformation(extent={{75,-20},{35,20}},rotation=0)));
   input Modelica.Mechanics.MultiBody.Types.Color rod1Color=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of rod 1 connecting the two spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Force f_rod "Constraint force in direction of the rod (positive, if rod is pressed)";
   Modelica.SIunits.Position aux "Denominator used to compute force in rod connecting universal and spherical joint";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_guess=0 "Select the configuration such that at initial time |phi(t0) - from_deg(phi_guess)|is minimal";
   parameter Modelica.SIunits.Mass rod1Mass(min=0)=0 "Mass of rod 1 (= point mass located in middle of rod connecting the two spherical joints)";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_offset=0 "Relative angle offset of revolute joint (angle = phi(t) + from_deg(phi_offset))";
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={0,0,1} "Axis of revolute joint fixed and resolved in frame_b";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   input Modelica.Mechanics.MultiBody.Types.Color rod2Color=rod1Color "Color of rod 2 connecting the revolute joint and spherical joint 2" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Diameter sphereDiameter=world.defaultJointLength "Diameter of the spheres representing the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Length rod1Length(min=Modelica.Constants.eps,start=1) "Distance between the origins of the two spherical joints ";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the revolute joint" annotation(Placement(transformation(extent={{105,85},{95,75}},rotation=0)));
   FAME.Dampers.RotationalWithConnectEquations _famefault_axis(amount=0.0);
   parameter Modelica.SIunits.Diameter revoluteDiameter=world.defaultJointWidth "Diameter of cylinder representing the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   Modelica.Mechanics.MultiBody.Parts.FixedTranslation rod2(animation=animation,width=rod2Diameter,height=rod2Diameter,color=rod2Color,specularCoefficient=specularCoefficient,r=rRod2_ib) annotation(Placement(transformation(extent={{15,-20},{-25,20}},rotation=0)));
   parameter Boolean showMass=true "= true, if point mass on rod 1 shall be shown (provided animation = true and rod1Mass > 0)";
   Modelica.Mechanics.MultiBody.Joints.SphericalSpherical rod1(animation=animation,showMass=showMass,m=rod1Mass,rodLength=rod1Length,rodDiameter=rod1Diameter,sphereDiameter=sphereDiameter,rodColor=rod1Color,specularCoefficient=specularCoefficient,kinematicConstraint=false,sphereColor=sphereColor,constraintResidue=rod1.f_rod-f_rod) annotation(Placement(transformation(extent={{-89,-20},{-49,20}},rotation=0)));
   parameter Modelica.SIunits.Position rRod2_ib[3]={1,0,0} "Vector from origin of frame_ib to spherical joint in the middle, resolved in frame_ib";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_im "Coordinate system at origin of spherical joint in the middle fixed at connecting rod of spherical and revolute joint" annotation(Placement(transformation(origin={0,100},extent={{8,-8},{-8,8}},rotation=270)));
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   input Modelica.Mechanics.MultiBody.Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of the spheres representing the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at connecting rod of spherical and revolute joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Blocks.Sources.Constant position_b[3](k=rRod2_ib) annotation(Placement(transformation(extent={{-20,-50},{0,-30}},rotation=0)));
   parameter Modelica.SIunits.Diameter rod2Diameter=rod1Diameter "Diameter of rod 2 connecting the revolute joint and spherical joint 2" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing of the revolute joint" annotation(Placement(transformation(extent={{95,45},{105,35}},rotation=0)));
   FAME.Dampers.RotationalWithConnectEquations _famefault_bearing(amount=0.0);
  protected
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointSSR
  equation
   aux = cross(revolute.e,rRod2_ib)*Frames.resolveRelative(rod1.eRod_a,rod1.frame_a.R,rod1.frame_b.R);
   f_rod = (-revolute.tau-revolute.e*(frame_ib.t+frame_im.t+cross(rRod2_ib,frame_im.f)-cross(rRod2_ib,Frames.resolveRelative(rod1.f_b_a1,rod1.frame_a.R,rod1.frame_b.R))))/(noEvent((if abs(aux)<1.e-10 then 1.e-10 else aux)));
   if checkTotalPower then
    totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+frame_ib.f*Frames.resolve2(frame_ib.R,der(frame_ib.r_0))+frame_im.f*Frames.resolve2(frame_im.R,der(frame_im.r_0))+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R)+frame_ib.t*Frames.angularVelocity2(frame_ib.R)+frame_im.t*Frames.angularVelocity2(frame_im.R)+_famefault_axis.port_b.tau*der(_famefault_axis.port_b.phi)+_famefault_bearing.port_b.tau*der(_famefault_bearing.port_b.phi)+(-rod1Mass)*(der(rod1.v_CM_0)-world.gravityAcceleration(rod1.r_CM_0))*rod1.v_CM_0;
   else
    totalPower = 0;
   end if;
   connect(revolute.frame_b,rod2.frame_a) annotation(Line(points={{35,0},{15,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_b,rod1.frame_b) annotation(Line(points={{-25,0},{-49,0}},color={95,95,95},thickness=0.5));
   connect(revolute.frame_a,frame_b) annotation(Line(points={{75,0},{100,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_a,frame_ib) annotation(Line(points={{15,0},{26,0},{26,70},{80,70},{80,100}},color={95,95,95},thickness=0.5));
   connect(rod1.frame_a,frame_a) annotation(Line(points={{-89,0},{-100,0}},color={95,95,95},thickness=0.5));
   connect(relativePosition.frame_b,frame_a) annotation(Line(points={{40,-80},{-95,-80},{-95,0},{-100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(relativePosition.frame_a,frame_b) annotation(Line(points={{60,-80},{96,-80},{96,0},{100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(position_b.y,revolute.position_b) annotation(Line(points={{1,-40},{20,-40},{20,-12},{31,-12}},color={0,0,127}));
   connect(revolute.axis,_famefault_axis.port_b) annotation(Line(points={{55,20},{55,60},{90,60},{90,80},{100,80}},color={0,0,0}));
   connect(rod2.frame_b,frame_im) annotation(Line(points={{-25,0},{-35,0},{-35,60},{0,60},{0,100}},color={95,95,95},thickness=0.5));
   connect(relativePosition.r_rel,revolute.position_a) annotation(Line(points={{50,-69},{50,-50},{90,-50},{90,-12},{79,-12}},color={0,0,127},smooth=Smooth.None));
   connect(revolute.bearing,_famefault_bearing.port_b) annotation(Line(points={{67,20},{67,40},{100,40}},color={0,0,0},smooth=Smooth.None));
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of a <b>spherical</b> joint 1 at frame_a, a <b>revolute</b>
joint at frame_b and a <b>spherical</b> joint 2 which is connected via rod 1
to the spherical joint 1 and via rod 2 to the revolute joint, see the default
animation in the following figure (the axes vectors are not part of the
default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointSSR.png\" ALT=\"model Joints.Assemblies.JointSSR\">

<p>
Besides an optional point mass in the middle of rod 1,
this joint aggregation has no mass and no inertia,
and introduces neither constraints nor potential state variables.
It should be used in kinematic loops whenever possible since
the non-linear system of equations introduced by this joint aggregation
is solved <b>analytically</b> (i.e., a solution is always computed, if a
unique solution exists).
</p>
<p>
An additional <b>frame_ib</b> is present. It is <b>fixed</b> in rod 2
connecting the revolute and the spherical joint at the side of the revolute
joint that is connected to this rod (= rod2.frame_a = revolute.frame_a).
</p>
<p>
An additional <b>frame_im</b> is present. It is <b>fixed</b> in rod 2
connecting the revolute and the spherical joint at the side of spherical
joint 2 that is connected to this rod (= rod2.frame_b).
It is always parallel to <b>frame_ib</b>.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_b and frame_ib of the JointSSR joint
should be parallel to each other when defining an instance of this
component).
</p>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Text(extent={{-141,-41},{139,-66}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-100,-30},{-40,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-93,-22},{-48,23}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-63,33},{-39,-33}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-40,-30},{20,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-33,-22},{12,23}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-44,31},{-19,-30}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-23,10},{-3,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{19,6},{61,-6}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{60,-30},{76,30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{85,-30},{100,30}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{76,10},{85,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{60,30},{76,-30}},lineColor={0,0,0}),Rectangle(extent={{85,30},{100,-30}},lineColor={0,0,0}),Text(extent={{88,112},{127,92}},lineColor={128,128,128},textString="ib"),Ellipse(extent={{-80,11},{-60,-9}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{-62,6},{-21,-5}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{80,80},{100,80}},color={95,95,95},thickness=0.5),Line(points={{19,6},{19,80},{0,80},{0,100}},color={95,95,95},thickness=0.5),Text(extent={{-47,111},{-8,92}},lineColor={128,128,128},textString="im"),Line(points={{68,30},{68,80},{80,80},{80,98}},color={95,95,95},thickness=0.5),Line(points={{90,30},{90,40},{95,40}},color={95,95,95},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics));
  end JointSSR;

  model JointSSP
   "Spherical - spherical - prismatic joint aggregation with mass (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointSSP
      model _famefaults_axis = FAME.Dampers.TranslationalWithConnectEquations;
      model _famefaults_bearing = FAME.Dampers.TranslationalWithConnectEquations;

  // components of JointSSP
   parameter Modelica.SIunits.Position s_guess=0 "Select the configuration such that at initial time |s(t0)-s_guess|is minimal";
   parameter Modelica.SIunits.Diameter rod1Diameter=sphereDiameter/(Types.Defaults.JointRodDiameterFraction) "Diameter of rod 1 connecting the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Sensors.RelativePosition relativePosition(resolveInFrame=Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.frame_a) annotation(Placement(transformation(extent={{60,-70},{40,-90}},rotation=0)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   input Modelica.Mechanics.MultiBody.Types.Color rod1Color=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of rod 1 connecting the two spherical joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Force f_rod "Constraint force in direction of the rod (positive, if rod is pressed)";
   Real aux "Denominator used to compute force in rod connecting universal and spherical joint";
   parameter Modelica.SIunits.Distance boxHeight=boxWidth "Height of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position s_offset=0 "Relative distance offset of prismatic joint (distance between frame_b and frame_ib = s(t) + s_offset)";
   parameter Modelica.SIunits.Mass rod1Mass(min=0)=0 "Mass of rod 1 (= point mass located in middle of rod connecting the two spherical joints)";
   Modelica.Mechanics.MultiBody.Joints.Internal.PrismaticWithLengthConstraint prismatic(animation=animation,length=rod1Length,n=n_b,s_offset=s_offset,s_guess=s_guess,boxWidthDirection=boxWidthDirection,boxWidth=boxWidth,boxHeight=boxHeight,specularCoefficient=specularCoefficient,boxColor=boxColor) annotation(Placement(transformation(extent={{75,-20},{35,20}},rotation=0)));
   parameter Modelica.SIunits.Distance boxWidth=world.defaultJointWidth "Width of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis boxWidthDirection={0,1,0} "Vector in width direction of prismatic joint box, resolved in frame_b" annotation(Evaluate=true,Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={0,0,1} "Axis of prismatic joint fixed and resolved in frame_b";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   input Modelica.Mechanics.MultiBody.Types.Color rod2Color=rod1Color "Color of rod 2 connecting the revolute joint and spherical joint 2" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Diameter sphereDiameter=world.defaultJointLength "Diameter of the spheres representing the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Length rod1Length(min=Modelica.Constants.eps,start=1) "Distance between the origins of the two spherical joints ";
   Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the prismatic joint" annotation(Placement(transformation(extent={{95,75},{105,85}},rotation=0)));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_axis(amount=0.0);
   Modelica.SIunits.Power totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   Modelica.Mechanics.MultiBody.Parts.FixedTranslation rod2(animation=animation,width=rod2Diameter,height=rod2Diameter,specularCoefficient=specularCoefficient,color=rod2Color,r=rRod2_ib) annotation(Placement(transformation(extent={{15,-20},{-25,20}},rotation=0)));
   parameter Boolean showMass=true "= true, if point mass on rod 1 shall be shown (provided animation = true and rod1Mass > 0)";
   Modelica.Mechanics.MultiBody.Joints.SphericalSpherical rod1(animation=animation,showMass=showMass,m=rod1Mass,rodLength=rod1Length,rodDiameter=rod1Diameter,sphereDiameter=sphereDiameter,rodColor=rod1Color,kinematicConstraint=false,specularCoefficient=specularCoefficient,sphereColor=sphereColor,constraintResidue=rod1.f_rod-f_rod) annotation(Placement(transformation(extent={{-89,-20},{-49,20}},rotation=0)));
   parameter Modelica.SIunits.Position rRod2_ib[3]={1,0,0} "Vector from origin of frame_ib to spherical joint in the middle, resolved in frame_ib";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_im "Coordinate system at origin of spherical joint in the middle fixed at connecting rod of spherical and prismatic joint" annotation(Placement(transformation(origin={0,100},extent={{8,-8},{-8,8}},rotation=270)));
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   input Modelica.Mechanics.MultiBody.Types.Color sphereColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of the spheres representing the two spherical joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at connecting rod of spherical and prismatic joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Blocks.Sources.Constant position_b[3](k=rRod2_ib) annotation(Placement(transformation(extent={{-20,-50},{0,-30}},rotation=0)));
   parameter Modelica.SIunits.Diameter rod2Diameter=rod1Diameter "Diameter of rod 2 connecting the revolute joint and spherical joint 2" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing of the prismatic joint" annotation(Placement(transformation(extent={{105,35},{95,45}},rotation=0)));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_bearing(amount=0.0);
   input Modelica.Mechanics.MultiBody.Types.Color boxColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  protected
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointSSP
  equation
   aux = prismatic.e*Frames.resolveRelative(rod1.eRod_a,rod1.frame_a.R,rod1.frame_b.R);
   f_rod = (-prismatic.f-prismatic.e*(frame_ib.f+frame_im.f))/(noEvent((if abs(aux)<1.e-10 then 1.e-10 else aux)));
   if checkTotalPower then
    totalPower = frame_a.f*Frames.resolve2(frame_a.R,der(frame_a.r_0))+frame_b.f*Frames.resolve2(frame_b.R,der(frame_b.r_0))+frame_ib.f*Frames.resolve2(frame_ib.R,der(frame_ib.r_0))+frame_im.f*Frames.resolve2(frame_im.R,der(frame_im.r_0))+frame_a.t*Frames.angularVelocity2(frame_a.R)+frame_b.t*Frames.angularVelocity2(frame_b.R)+frame_ib.t*Frames.angularVelocity2(frame_ib.R)+frame_im.t*Frames.angularVelocity2(frame_im.R)+_famefault_axis.port_b.f*der(_famefault_axis.port_b.s)+_famefault_bearing.port_b.f*der(_famefault_bearing.port_b.s)+(-rod1Mass)*(der(rod1.v_CM_0)-world.gravityAcceleration(rod1.r_CM_0))*rod1.v_CM_0;
   else
    totalPower = 0;
   end if;
   connect(prismatic.frame_b,rod2.frame_a) annotation(Line(points={{35,0},{15,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_b,rod1.frame_b) annotation(Line(points={{-25,0},{-49,0}},color={95,95,95},thickness=0.5));
   connect(prismatic.frame_a,frame_b) annotation(Line(points={{75,0},{100,0}},color={95,95,95},thickness=0.5));
   connect(rod2.frame_a,frame_ib) annotation(Line(points={{15,0},{26,0},{26,70},{80,70},{80,100}},color={95,95,95},thickness=0.5));
   connect(rod1.frame_a,frame_a) annotation(Line(points={{-89,0},{-100,0}},color={95,95,95},thickness=0.5));
   connect(relativePosition.frame_b,frame_a) annotation(Line(points={{40,-80},{-95,-80},{-95,0},{-100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(relativePosition.frame_a,frame_b) annotation(Line(points={{60,-80},{96,-80},{96,0},{100,0}},color={95,95,95},pattern=LinePattern.Dot));
   connect(position_b.y,prismatic.position_b) annotation(Line(points={{1,-40},{20,-40},{20,-12},{31,-12}},color={0,0,127}));
   connect(prismatic.axis,_famefault_axis.port_b) annotation(Line(points={{39,14},{40,14},{40,60},{90,60},{90,80},{100,80}},color={0,0,0}));
   connect(prismatic.bearing,_famefault_bearing.port_b) annotation(Line(points={{63,14},{63,40},{100,40}},color={0,0,0}));
   connect(rod2.frame_b,frame_im) annotation(Line(points={{-25,0},{-35,0},{-35,60},{0,60},{0,100}},color={95,95,95},thickness=0.5));
   connect(relativePosition.r_rel,prismatic.position_a) annotation(Line(points={{50,-69},{50,-50},{90,-50},{90,-12},{79,-12}},color={0,0,127},smooth=Smooth.None));
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of a <b>spherical</b> joint 1 at frame_a, a <b>prismatic</b>
joint at frame_b and a <b>spherical</b> joint 2 which is connected via rod 1
to the spherical joint 1 and via rod 2 to the prismatic joint, see the default
animation in the following figure (the axes vectors are not part of the
default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointSSP.png\" ALT=\"model Joints.Assemblies.JointSSP\">

<p>
Besides an optional point mass in the middle of rod 1,
this joint aggregation has no mass and no inertia,
and introduces neither constraints nor potential state variables.
It should be used in kinematic loops whenever possible since
the non-linear system of equations introduced by this joint aggregation
is solved <b>analytically</b> (i.e., a solution is always computed, if a
unique solution exists).
</p>
<p>
An additional <b>frame_ib</b> is present. It is <b>fixed</b> in rod 2
connecting the prismatic and the spherical joint at the side of the prismatic
joint that is connected to this rod (= rod2.frame_a = prismatic.frame_a).
</p>
<p>
An additional <b>frame_im</b> is present. It is <b>fixed</b> in rod 2
connecting the prismatic and the spherical joint at the side of spherical
joint 2 that is connected to this rod (= rod2.frame_b).
It is always parallel to <b>frame_ib</b>.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_b and frame_ib of the JointSSP joint
should be parallel to each other when defining an instance of this
component).
</p>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Text(extent={{-140,-40},{140,-65}},lineColor={0,0,255},textString="%name"),Ellipse(extent={{-100,-30},{-40,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-93,-22},{-48,23}},lineColor={160,160,164},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-63,33},{-39,-33}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-40,-30},{20,30}},lineColor={0,0,0},fillPattern=FillPattern.Sphere,fillColor={192,192,192}),Ellipse(extent={{-33,-22},{12,23}},lineColor={192,192,192},fillColor={255,255,255},fillPattern=FillPattern.Solid),Rectangle(extent={{-44,31},{-19,-30}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Ellipse(extent={{-23,10},{-3,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{19,6},{61,-6}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{89,115},{132,92}},lineColor={128,128,128},textString="ib"),Ellipse(extent={{-80,11},{-60,-9}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Rectangle(extent={{-62,6},{-21,-5}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{19,6},{19,80},{0,80},{0,100}},color={95,95,95},thickness=0.5),Text(extent={{-49,114},{-11,92}},lineColor={128,128,128},textString="im"),Rectangle(extent={{50,20},{80,-20}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{80,30},{100,-30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{50,14},{80,20}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{80,24},{100,30}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Line(points={{50,6},{50,80},{80,80},{80,100}},color={95,95,95},thickness=0.5),Line(points={{101,80},{80,80}},color={95,95,95},thickness=0.5),Line(points={{99,40},{90,40},{90,30}},color={95,95,95},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics));
  end JointSSP;

  model JointRRR
   "Planar revolute - revolute - revolute joint aggregation (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointRRR
      model _famefaults_axis = FAME.Dampers.RotationalWithConnectEquations;
      model _famefaults_bearing = FAME.Dampers.RotationalWithConnectEquations;

  // components of JointRRR
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_guess=0 "Select the configuration such that at initial time |phi(t0) - from_deg(phi_guess)|is minimal";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_offset=0 "Relative angle offset of revolute joint at frame_b (angle = phi(t) + from_deg(phi_offset))";
   final parameter Real n_b[3](each final unit="1",fixed=false)={0,0,1} "Axis of revolute joint fixed and resolved in frame_b" annotation(Evaluate=true);
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_a={0,0,1} "Axes of revolute joints resolved in frame_a (all axes are parallel to each other)" annotation(Evaluate=true);
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   parameter Modelica.SIunits.Position rRod1_ia[3]={1,0,0} "Vector from origin of frame_a to revolute joint in the middle, resolved in frame_ia" annotation(Evaluate=true);
   Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the right revolute joint at frame_b" annotation(Placement(transformation(extent={{105,85},{95,75}},rotation=0)));
   FAME.Dampers.RotationalWithConnectEquations _famefault_axis(amount=0.0);
   final parameter Real e_a[3](each final unit="1")=Modelica.Math.Vectors.normalize(n_a,0.0) "Unit vector along axes of rotations, resolved in frame_a";
   Modelica.SIunits.Power totalPower=jointUSR.totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position rRod2_ib[3]={-1,0,0} "Vector from origin of frame_ib to revolute joint in the middle, resolved in frame_ib";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_im "Coordinate system at origin of revolute joint in the middle fixed at connecting rod of middle and right revolute joint" annotation(Placement(transformation(origin={0,100},extent={{8,-8},{-8,8}},rotation=270)));
   input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUSR jointUSR(animation=false,n1_a=n_a,n_b=n_b,phi_offset=phi_offset,rRod2_ib=rRod2_ib,showUniversalAxes=false,rRod1_ia=rRod1_ia,checkTotalPower=checkTotalPower,phi_guess=phi_guess) annotation(Placement(transformation(extent={{-30,-20},{10,20}},rotation=0)));
   final parameter Real e_ia[3](each final unit="1")=jointUSR.e2_ia "Unit vector along axes of rotations, resolved in frame_ia";
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   final parameter Real e_b[3](each final unit="1")=jointUSR.revolute.e "Unit vector along axes of rotations, resolved in frame_b, frame_ib and frame_im";
   parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Diameter rodDiameter=1.1*cylinderDiameter "Diameter of the two rods connecting the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at connecting rod of middle and right revolute joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_ia "Coordinate system at origin of frame_a fixed at connecting rod of left and middle revolute joint" annotation(Placement(transformation(origin={-80,100},extent={{-8,-8},{8,8}},rotation=90)));
   Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing of the right revolute joint at frame_b" annotation(Placement(transformation(extent={{95,45},{105,35}},rotation=0)));
   FAME.Dampers.RotationalWithConnectEquations _famefault_bearing(amount=0.0);
   input Modelica.Mechanics.MultiBody.Types.Color rodColor=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of the two rods connecting the revolute joint" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  protected
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rev2(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e_b,widthDirection={0,1,0},r_shape=(-e_b)*cylinderLength/(2),r=frame_im.r_0,R=frame_im.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rev1(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e_a,widthDirection={0,1,0},r_shape=(-e_a)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rev3(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e_b,widthDirection={0,1,0},r_shape=(-e_b)*cylinderLength/(2),r=frame_b.r_0,R=frame_b.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rod1(shapeType="cylinder",color=rodColor,specularCoefficient=specularCoefficient,length=Modelica.Math.Vectors.length(rRod1_ia),width=rodDiameter,height=rodDiameter,lengthDirection=rRod1_ia,widthDirection=e_ia,r=frame_ia.r_0,R=frame_ia.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rod2(shapeType="cylinder",color=rodColor,specularCoefficient=specularCoefficient,length=Modelica.Math.Vectors.length(rRod2_ib),width=rodDiameter,height=rodDiameter,lengthDirection=rRod2_ib,widthDirection=e_b,r=frame_ib.r_0,R=frame_ib.R) if world.enableAnimation and animation;
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointRRR
  initial equation
   n_b = Frames.resolve2(frame_b.R,Frames.resolve1(frame_a.R,n_a));
  equation
   connect(jointUSR.frame_a,frame_a) annotation(Line(points={{-30,0},{-100,0}},color={95,95,95},thickness=0.5));
   connect(jointUSR.frame_b,frame_b) annotation(Line(points={{10,0},{100,0}},color={95,95,95},thickness=0.5));
   connect(jointUSR.frame_ia,frame_ia) annotation(Line(points={{-26,20},{-26,70},{-80,70},{-80,100}},color={95,95,95},thickness=0.5));
   connect(jointUSR.frame_im,frame_im) annotation(Line(points={{-10,20},{-10,70},{0,70},{0,100}},color={95,95,95},thickness=0.5));
   connect(jointUSR.frame_ib,frame_ib) annotation(Line(points={{6,20},{6,50},{80,50},{80,100}},color={95,95,95},thickness=0.5));
   connect(jointUSR.axis,_famefault_axis.port_b) annotation(Line(points={{10,16},{86,16},{86,80},{100,80}},color={0,0,0}));
   connect(jointUSR.bearing,_famefault_bearing.port_b) annotation(Line(points={{10,8},{94,8},{94,40},{100,40}},color={0,0,0}));
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of <b>3 revolute</b> joints with parallel
axes of rotation that are connected together by two rods, see the default
animation in the following figure (the axes vectors are not part of the
default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointRRR.png\" ALT=\"model Joints.Assemblies.JointRRR\">

<p>
This joint aggregation introduces neither constraints nor state variables and
should therefore be used in kinematic loops whenever possible to
avoid non-linear systems of equations. It is only meaningful to
use this component in <b>planar loops</b>. Basically, the position
and orientation of the 3 revolute joints as well as of frame_ia, frame_ib, and
frame_im are calculated by solving analytically a non-linear equation,
given the position and orientation at frame_a and at frame_b.
</p>
<p>
Connector <b>frame_a</b> is the \"left\" side of the first revolute joint
whereas <b>frame_ia</b> is the \"right side of this revolute joint, fixed in rod 1.
Connector <b>frame_b</b> is the \"right\" side of the third revolute joint
whereas <b>frame_ib</b> is the \"left\" side of this revolute joint, fixed in rod 2.
Finally, connector <b>frame_im</b> is the connector at the \"right\" side
of the revolute joint in the middle, fixed in rod 2.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_a, frame_ia, frame_im, frame_ib, frame_b of the JointRRR joint
should be parallel to each other when defining an instance of this
component).
</p>
<p>
Basically, the JointRRR model consists internally of a universal -
spherical - revolute joint aggregation (= JointUSR). In a planar
loop this will behave as if 3 revolute joints with parallel axes
are connected by rigid rods.
</p>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Rectangle(extent={{-90,90},{90,-90}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-140,-55},{140,-80}},lineColor={0,0,255},textString="%name"),Text(extent={{36,114},{71,92}},lineColor={128,128,128},textString="ib"),Text(extent={{-126,115},{-87,90}},lineColor={128,128,128},textString="ia"),Ellipse(extent={{-100,25},{-50,-25}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-85,10},{-65,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{50,25},{100,-25}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{65,10},{85,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{-26,80},{24,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-10,66},{10,46}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Polygon(points={{-71,9},{-24,45},{-19,39},{-66,3},{-71,9}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Polygon(points={{54,12},{5,47},{10,52},{59,18},{54,12}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Polygon(points={{100,-4},{83,-4},{84,3},{100,3},{100,-4}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Line(points={{80,24},{80,80},{80,80},{80,100}},color={95,95,95},thickness=0.5),Text(extent={{-128,-29},{136,-47}},lineColor={0,0,0},textString="n_a=%n_a"),Line(points={{0,57},{0,86},{0,86},{0,100}},color={95,95,95},thickness=0.5),Text(extent={{-46,114},{-7,91}},lineColor={128,128,128},textString="im"),Line(points={{-80,100},{-80,8}},color={95,95,95},thickness=0.5),Line(points={{80,80},{101,80}},color={95,95,95},thickness=0.5),Line(points={{100,40},{93,40},{93,3}},color={95,95,95},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics));
  end JointRRR;

  model JointRRP
   "Planar revolute - revolute - prismatic joint aggregation (no constraints, no potential states)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;
   import Modelica.Mechanics.MultiBody.Types;

  // locally defined classes in JointRRP
      model _famefaults_axis = FAME.Dampers.TranslationalWithConnectEquations;
      model _famefaults_bearing = FAME.Dampers.TranslationalWithConnectEquations;

  // components of JointRRP
   parameter Modelica.SIunits.Position s_guess=0 "Select the configuration such that at initial time |s(t0)-s_guess|is minimal";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{92,-8},{108,8}})));
   parameter Modelica.SIunits.Distance boxHeight=boxWidth "Height of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position s_offset=0 "Relative distance offset of prismatic joint (distance between the prismatic joint frames = s(t) + s_offset)";
   parameter Modelica.SIunits.Distance boxWidth=world.defaultJointWidth "Width of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis boxWidthDirection={0,1,0} "Vector in width direction of prismatic joint, resolved in frame_b" annotation(Evaluate=true,Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_b={-1,0,0} "Axis of prismatic joint fixed and resolved in frame_b (must be orthogonal to revolute joint axes)" annotation(Evaluate=true);
   parameter Modelica.Mechanics.MultiBody.Types.Axis n_a={0,0,1} "Axes of the two revolute joints resolved in frame_a (both axes are parallel to each other)" annotation(Evaluate=true);
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-108,-8},{-92,8}})));
   parameter Modelica.SIunits.Position rRod1_ia[3]={1,0,0} "Vector from origin of frame_a to revolute joint in the middle, resolved in frame_ia" annotation(Evaluate=true);
   final parameter Real e_a[3](each final unit="1")=Modelica.Math.Vectors.normalize(n_a,0.0) "Unit vector along axes of rotations, resolved in frame_a";
   Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the prismatic joint" annotation(Placement(transformation(extent={{95,75},{105,85}},rotation=0)));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_axis(amount=0.0);
   Modelica.SIunits.Power totalPower=jointUSP.totalPower "Total power flowing into this element, if checkTotalPower=true (otherwise dummy)";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   final parameter Real e_im[3](each final unit="1",each fixed=false) "Unit vector along axes of rotations, resolved in frame_im";
   parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinders representing the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUSP jointUSP(animation=false,showUniversalAxes=false,n1_a=n_a,n_b=n_b,s_offset=s_offset,s_guess=s_guess,rRod1_ia=rRod1_ia,rRod2_ib=rRod2_ib,checkTotalPower=checkTotalPower) annotation(Placement(transformation(extent={{-30,-20},{10,20}},rotation=0)));
   parameter Modelica.SIunits.Position rRod2_ib[3]={-1,0,0} "Vector from origin of frame_ib to revolute joint in the middle, resolved in frame_ib (frame_ib is parallel to frame_b)";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_im "Coordinate system at origin of revolute joint in the middle fixed at connecting rod of revolute and prismatic joint" annotation(Placement(transformation(origin={0,100},extent={{8,-8},{-8,8}},rotation=270)));
   input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   final parameter Real e_ia[3](each final unit="1")=jointUSP.e2_ia "Unit vector along axes of rotations, resolved in frame_ia";
   parameter Boolean checkTotalPower=false "= true, if total power flowing into this component shall be determined (must be zero)" annotation(Dialog(tab="Advanced"));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   final parameter Real e_b[3](each final unit="1")=jointUSP.prismatic.e "Unit vector along axes of translation of the prismatic joint, resolved in frame_b and frame_ib";
   parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinders representing the revolute joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Diameter rodDiameter=1.1*cylinderDiameter "Diameter of the two rods connecting the joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_ib "Coordinate system at origin of frame_b fixed at connecting rod of revolute and prismatic joint" annotation(Placement(transformation(origin={80,100},extent={{-8,8},{8,-8}},rotation=270)));
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_ia "Coordinate system at origin of frame_a fixed at connecting rod of revolute joints" annotation(Placement(transformation(origin={-80,100},extent={{-8,-8},{8,8}},rotation=90)));
   Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing of the prismatic joint" annotation(Placement(transformation(extent={{105,35},{95,45}},rotation=0)));
   FAME.Dampers.TranslationalWithConnectEquations _famefault_bearing(amount=0.0);
   input Modelica.Mechanics.MultiBody.Types.Color rodColor=Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of the two rods connecting the joints" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.Color boxColor=cylinderColor "Color of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  protected
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rev2(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e_im,widthDirection={0,1,0},r_shape=(-e_im)*cylinderLength/(2),r=frame_im.r_0,R=frame_im.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rev1(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e_a,widthDirection={0,1,0},r_shape=(-e_a)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_prism(shapeType="box",color=boxColor,specularCoefficient=specularCoefficient,length=jointUSP.prismatic.distance,width=boxWidth,height=boxHeight,lengthDirection=e_b,widthDirection=e_im,r=frame_b.r_0,R=frame_b.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rod1(shapeType="cylinder",color=rodColor,specularCoefficient=specularCoefficient,length=Modelica.Math.Vectors.length(rRod1_ia),width=rodDiameter,height=rodDiameter,lengthDirection=rRod1_ia,widthDirection=e_ia,r=frame_ia.r_0,R=frame_ia.R) if world.enableAnimation and animation;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape_rod2(shapeType="cylinder",color=rodColor,specularCoefficient=specularCoefficient,length=Modelica.Math.Vectors.length(rRod2_ib),width=rodDiameter,height=rodDiameter,lengthDirection=rRod2_ib,widthDirection=e_b,r=frame_ib.r_0,R=frame_ib.R) if world.enableAnimation and animation;
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of JointRRP
  initial equation
   e_im = Frames.resolve2(frame_im.R,Frames.resolve1(frame_a.R,e_a));
  equation
   connect(jointUSP.frame_a,frame_a) annotation(Line(points={{-30,0},{-100,0}},color={95,95,95},thickness=0.5));
   connect(jointUSP.frame_b,frame_b) annotation(Line(points={{10,0},{100,0}},color={95,95,95},thickness=0.5));
   connect(jointUSP.frame_ia,frame_ia) annotation(Line(points={{-26,20},{-26,70},{-80,70},{-80,100}},color={95,95,95},thickness=0.5));
   connect(jointUSP.frame_im,frame_im) annotation(Line(points={{-10,20},{-10,70},{0,70},{0,100}},color={95,95,95},thickness=0.5));
   connect(jointUSP.frame_ib,frame_ib) annotation(Line(points={{6,20},{6,50},{80,50},{80,100}},color={95,95,95},thickness=0.5));
   connect(jointUSP.axis,_famefault_axis.port_b) annotation(Line(points={{10,16},{86,16},{86,80},{100,80}},color={0,0,0}));
   connect(jointUSP.bearing,_famefault_bearing.port_b) annotation(Line(points={{10,8},{94,8},{94,40},{100,40}},color={0,0,0}));
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Documentation(info="<html>
<p>
This component consists of <b>2 revolute</b> joints with parallel
axes of rotation that and a <b>prismatic</b> joint with a translational
axis that is orthogonal to the revolute joint axes, see the default
animation in the following figure (the axes vectors are not part of the
default animation):
</p>

<IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointRRP.png\" ALT=\"model Joints.Assemblies.JointRRP\">

<p>
This joint aggregation introduces neither constraints nor state variables and
should therefore be used in kinematic loops whenever possible to
avoid non-linear systems of equations. It is only meaningful to
use this component in <b>planar loops</b>. Basically, the position
and orientation of the 3 joints as well as of frame_ia, frame_ib, and
frame_im are calculated by solving analytically a non-linear equation,
given the position and orientation at frame_a and at frame_b.
</p>
<p>
Connector <b>frame_a</b> is the \"left\" side of the first revolute joint
whereas <b>frame_ia</b> is the \"right side of this revolute joint, fixed in rod 1.
Connector <b>frame_b</b> is the \"right\" side of the prismatic joint
whereas <b>frame_ib</b> is the \"left\" side of this prismatic joint, fixed in rod 2.
Finally, connector <b>frame_im</b> is the connector at the \"right\" side
of the revolute joint in the middle, fixed in rod 2. The frames
frame_b, frame_ib, frame_im are always parallel to each other.
</p>
<p>
The easiest way to define the parameters of this joint is by moving the
MultiBody system in a <b>reference configuration</b> where <b>all frames</b>
of all components are <b>parallel</b> to each other (alternatively,
at least frame_a, frame_ia, frame_im, frame_ib, frame_b of the JointRRP joint
should be parallel to each other when defining an instance of this
component).
</p>
<p>
Basically, the JointRRP model consists internally of a universal -
spherical - prismatic joint aggregation (= JointUSP). In a planar
loop this will behave as if 2 revolute joints with parallel axes
and 1 prismatic joint are connected by rigid rods.
</p>
</html> "),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics={Rectangle(extent={{-90,90},{90,-90}},lineColor={255,255,255},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-139,-53},{141,-78}},lineColor={0,0,255},textString="%name"),Text(extent={{26,124},{68,93}},lineColor={128,128,128},textString="ib"),Text(extent={{-134,128},{-94,94}},lineColor={128,128,128},textString="ia"),Ellipse(extent={{-100,25},{-50,-25}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-85,10},{-65,-10}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Ellipse(extent={{-26,80},{24,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Ellipse(extent={{-10,66},{10,46}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Polygon(points={{-71,9},{-24,45},{-19,39},{-66,3},{-71,9}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Polygon(points={{54,5},{5,47},{8,53},{58,11},{54,5}},lineColor={0,0,0},fillColor={0,0,0},fillPattern=FillPattern.Solid),Text(extent={{-128,-29},{139,-47}},lineColor={0,0,0},textString="n_a=%n_a"),Line(points={{0,57},{0,86},{0,86},{0,100}},color={95,95,95},thickness=0.5),Text(extent={{-55,126},{-15,92}},lineColor={128,128,128},textString="im"),Line(points={{-80,100},{-80,8}},color={95,95,95},thickness=0.5),Line(points={{80,80},{101,80}},color={95,95,95},thickness=0.5),Line(points={{100,40},{93,40},{93,3}},color={95,95,95},thickness=0.5),Rectangle(extent={{80,15},{100,21}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{53,5},{80,11}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{53,5},{80,-15}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{80,15},{100,-21}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Line(points={{80,100},{80,80},{57,11}},color={95,95,95},thickness=0.5)}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1},initialScale=0.2),graphics));
  end JointRRP;

 annotation(Documentation(info="<HTML>
<p>
The joints in this package are mainly designed to be used
in <b>kinematic loop</b> structures. Every component consists of
<b>3 elementary joints</b>. These joints are combined in such a
way that the kinematics of the 3 joints between frame_a and
frame_b are computed from the movement of frame_a and frame_b,
i.e., there are <b>no constraints</b> between frame_a and frame_b.
This requires to solve a <b>non-linear system of equations</b> which
is performed <b>analytically</b> (i.e., when a mathematical
solution exists, it is computed efficiently and reliably).
A detailed description how to use these joints is provided in
<a href=\"modelica://Modelica.Mechanics.MultiBody.UsersGuide.Tutorial.LoopStructures.AnalyticLoopHandling\">MultiBody.UsersGuide.Tutorial.LoopStructures.AnalyticLoopHandling</a>.
</p>
<p>
The assembly joints in this package are named <b>JointXYZ</b> where
<b>XYZ</b> are the first letters of the elementary joints used in the
component, in particular:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>P</b></td><td valign=\"top\">Prismatic joint</td></tr>
  <tr><td valign=\"top\"><b>R</b></td><td valign=\"top\">Revolute joint</td></tr>
  <tr><td valign=\"top\"><b>S</b></td><td valign=\"top\">Spherical joint</td></tr>
  <tr><td valign=\"top\"><b>U</b></td><td valign=\"top\">Universal joint</td></tr>
</table>
<p>
For example, JointUSR is an assembly joint consisting
of a universal, a spherical and a revolute joint.
</p>
<p> This package contains the following models:
</p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Model</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUPS\">JointUPS</a></td>
      <td valign=\"top\"> Universal - prismatic - spherical joint aggregation<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointUPS.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUSR\">JointUSR</a></td>
      <td valign=\"top\"> Universal - spherical - revolute joint aggregation<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointUSR.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointUSP\">JointUSP</a></td>
      <td valign=\"top\"> Universal - spherical - prismatic joint aggregation<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointUSP.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointSSR\">JointSSR</a></td>
      <td valign=\"top\"> Spherical - spherical - revolute joint aggregation
           with an optional mass point at the rod connecting
           the two spherical joints<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointSSR.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointSSP\">JointSSP</a></td>
      <td valign=\"top\"> Spherical - spherical - prismatic joint aggregation
           with an optional mass point at the rod connecting
           the two spherical joints<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointSSP.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointRRR\">JointRRR</a></td>
      <td valign=\"top\"> Revolute - revolute - revolute joint aggregation for planar loops<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointRRR.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies.JointRRP\">JointRRP</a></td>
      <td valign=\"top\"> Revolute - revolute - prismatic joint aggregation for planar loops<br>
     <img src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/JointRRP.png\">
      </td>
  </tr>
</table>
<p>
Note, no component of this package has potential states, since the
components are designed in such a way that the generalized coordinates
of the used elementary joints are computed from the frame_a and frame_b
coordinates. Still, it is possible to use the components in a
tree structure. In this case states are selected from bodies that are
connected to the frame_a or frame_b side of the component.
In most cases this gives a less efficient solution, as if elementary
joints of package Modelica.Mechanics.MultiBody.Joints would be used directly.
</p>
<p>
The analytic handling of kinematic loops by using joint aggregations
with 6 degrees of freedom as provided in this package, is a <b>new</b>
methodology. It is based on a more general method for solving
non-linear equations of kinematic loops developed by Woernle and
Hiller. An automatic application of this more general method
is difficult, and a manual application is only suited for
specialists in this field. The method introduced here is a
compromize: It can be quite easily applied by an end user, but
for a smaller class of kinematic loops. The method of the \"characteristic
pair of joints\" from Woernle and Hiller is described in:
</p>
<dl>
<dt>Woernle C.:</dt>
<dd><b>Ein systematisches Verfahren zur Aufstellung der geometrischen
    Schliessbedingungen in kinematischen Schleifen mit Anwendung
    bei der R&uuml;ckw&auml;rtstransformation f&uuml;r
    Industrieroboter.</b><br>
    Fortschritt-Berichte VDI, Reihe 18, Nr. 59, Duesseldorf: VDI-Verlag 1988,
    ISBN 3-18-145918-6.<br>&nbsp;</dd>
<dt>Hiller M., and Woernle C.:</dt>
<dd><b>A Systematic Approach for Solving the Inverse Kinematic
    Problem of Robot Manipulators</b>.<br>
    Proceedings 7th World Congress Th. Mach. Mech., Sevilla 1987. </dd>
</dl>
</HTML>"));
 end Assemblies;

 package Internal
  "Components used for analytic solution of kinematic loops (use only if you know what you are doing)"
  extends Modelica.Icons.Package;

  model RevoluteWithLengthConstraint
   "Revolute joint where the rotation angle is computed from a length constraint (1 degree-of-freedom, no potential state)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;

  // locally defined classes in RevoluteWithLengthConstraint
      model _famefaults_axis = FAME.Dampers.RotationalWithoutConnectEquations;
      model _famefaults_bearing = FAME.Dampers.RotationalWithoutConnectEquations;

  // components of RevoluteWithLengthConstraint
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{84,-16},{116,16}},rotation=0)));
   final parameter Boolean positiveBranch(fixed=false) "Based on phi_guess, selection of one of the two solutions of the non-linear constraint equation";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_guess=0 "Select the configuration such that at initial time |phi - from_deg(phi_guess)|is minimal";
   parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg phi_offset=0 "Relative angle offset (angle = phi + from_deg(phi_offset))";
   parameter Modelica.SIunits.Position lengthConstraint(start=1) "Fixed length of length constraint";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-116,-16},{-84,16}},rotation=0)));
   Modelica.SIunits.Angle phi "Rotation angle of revolute joint";
   Modelica.Mechanics.Rotational.Interfaces.Flange_a axis "1-dim. rotational flange that drives the joint" annotation(Placement(transformation(extent={{10,90},{-10,110}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_axis(amount=0.0);
   final parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(n,0.0) "Unit vector in direction of rotation axis, resolved in frame_a";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   parameter Modelica.SIunits.Distance cylinderLength=world.defaultJointLength "Length of cylinder representing the joint axis" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.Mechanics.MultiBody.Types.Axis n={0,0,1} "Axis of rotation resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
   input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder representing the joint axis" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Angle angle "= phi + from_deg(phi_offset) (relative rotation angle between frame_a and frame_b)";
   Modelica.Mechanics.MultiBody.Frames.Orientation R_rel "Relative orientation object from frame_a to frame_b";
   parameter Modelica.SIunits.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinder representing the joint axis" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Blocks.Interfaces.RealInput position_a[3](each final quantity="Position",each final unit="m") "Position vector from frame_a to frame_a side of length constraint, resolved in frame_a of revolute joint" annotation(Placement(transformation(extent={{-140,-80},{-100,-40}},rotation=0)));
   Modelica.Blocks.Interfaces.RealInput position_b[3](each final quantity="Position",each final unit="m") "Position vector from frame_b to frame_b side of length constraint, resolved in frame_b of revolute joint" annotation(Placement(transformation(extent={{140,-80},{100,-40}},rotation=0)));
   Modelica.SIunits.Torque tau "= axis.tau (driving torque in the axis)";
   Modelica.Mechanics.Rotational.Interfaces.Flange_b bearing "1-dim. rotational flange of the drive bearing" annotation(Placement(transformation(extent={{-50,90},{-70,110}},rotation=0)));
   FAME.Dampers.RotationalWithoutConnectEquations _famefault_bearing(amount=0.0);
  protected

   function selectBranch
    "Determine branch which is closest to initial angle=0"

    import Modelica.Math.*;

   // components of selectBranch
    input SI.Length L "Length of length constraint";
    input Real e[3](each final unit="1") "Unit vector along axis of rotation, resolved in frame_a (= same in frame_b)";
    input SI.Angle angle_guess "Select the configuration such that at initial time |angle-angle_guess|is minimal (angle=0: frame_a and frame_b coincide)";
    input SI.Position r_a[3] "Position vector from frame_a to frame_a side of length constraint, resolved in frame_a of revolute joint";
    input SI.Position r_b[3] "Position vector from frame_b to frame_b side of length constraint, resolved in frame_b of revolute joint";
    output Boolean positiveBranch "Branch of the initial solution";
   protected
    Real e_r_a "Projection of r_a on e";
    Real e_r_b "Projection of r_b on e";
    Real A "Coefficient A of equation: A*cos(phi) + B*sin(phi) + C = 0";
    Real B "Coefficient B of equation: A*cos(phi) + B*sin(phi) + C = 0";
    Real C "Coefficient C of equation: A*cos(phi) + B*sin(phi) + C = 0";
    Real k1 "Constant of quadratic equation";
    Real k2 "Constant of quadratic equation";
    Real k1a;
    Real k1b;
    Real kcos1 "k1*cos(angle1)";
    Real ksin1 "k1*sin(angle1)";
    Real kcos2 "k2*cos(angle2)";
    Real ksin2 "k2*sin(angle2)";
    SI.Angle angle1 "solution 1 of nonlinear equation";
    SI.Angle angle2 "solution 2 of nonlinear equation";

   // algorithms and equations of selectBranch
   algorithm
      e_r_a:=e*r_a;
      e_r_b:=e*r_b;
      A:=(-2)*(r_b*r_a-e_r_b*e_r_a);
      B:=2*r_b*cross(e,r_a);
      C:=r_a*r_a+r_b*r_b-L*L-2*e_r_b*e_r_a;
      k1:=A*A+B*B;
      k1a:=k1-C*C;
      assert(k1a>1.e-10,"
Singular position of loop (either no or two analytic solutions;
the mechanism has lost one-degree-of freedom in this position).
Try first to use another Modelica.Mechanics.MultiBody.Joints.Assemblies.JointXXX component.
In most cases it is best that the joints outside of the JointXXX
component are revolute and NOT prismatic joints. If this also
lead to singular positions, it could be that this kinematic loop
cannot be solved analytically. In this case you have to build
up the loop with basic joints (NO aggregation JointXXX components)
and rely on dynamic state selection, i.e., during simulation
the states will be dynamically selected in such a way that in no
position a degree of freedom is lost.
");
      k1b:=max(k1a,1.0e-12);
      k2:=sqrt(k1b);
      kcos1:=(-A)*C+B*k2;
      ksin1:=(-B)*C-A*k2;
      angle1:=atan2(ksin1,kcos1);
      kcos2:=(-A)*C-B*k2;
      ksin2:=(-B)*C+A*k2;
      angle2:=atan2(ksin2,kcos2);
      if abs(angle1-angle_guess)<=abs(angle2-angle_guess) then
        positiveBranch:=true;
      else
        positiveBranch:=false;
      end if;
   end selectBranch;
  protected
   Real A "Coefficient A of equation: A*cos(phi) + B*sin(phi) + C = 0";
   Real B "Coefficient B of equation: A*cos(phi) + B*sin(phi) + C = 0";
   Real C "Coefficient C of equation: A*cos(phi) + B*sin(phi) + C = 0";
   Modelica.SIunits.Position r_a[3]=position_a "Position vector from frame_a to frame_a side of length constraint, resolved in frame_a of revolute joint";
   Modelica.SIunits.Position r_b[3]=position_b "Position vector from frame_b to frame_b side of length constraint, resolved in frame_b of revolute joint";
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape cylinder(shapeType="cylinder",color=cylinderColor,specularCoefficient=specularCoefficient,length=cylinderLength,width=cylinderDiameter,height=cylinderDiameter,lengthDirection=e,widthDirection={0,1,0},r_shape=(-e)*cylinderLength/(2),r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
   Real k1 "Constant of quadratic equation";
   Real ksin_angle "= k1*sin(angle)";
   Real k2 "Constant of quadratic equation";
   Real k1a(start=1);
   Real k1b;
   Real kcos_angle "= k1*cos(angle)";
   Real e_r_b "Projection of r_b on e";
   Real e_r_a "Projection of r_a on e";
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of RevoluteWithLengthConstraint
  initial equation
   positiveBranch = selectBranch(lengthConstraint,e,Cv.from_deg(phi_offset+phi_guess),r_a,r_b);
  equation
   Connections.branch(frame_a.R,frame_b.R);
   _famefault_axis.port_b.tau = tau;
   _famefault_axis.port_b.phi = phi;
   _famefault_bearing.port_b.phi = 0;
   angle = Cv.from_deg(phi_offset)+phi;
   frame_b.r_0 = frame_a.r_0;
   R_rel = Frames.planarRotation(e,angle,der(angle));
   frame_b.R = Frames.absoluteRotation(frame_a.R,R_rel);
   zeros(3) = frame_a.f+Frames.resolve1(R_rel,frame_b.f);
   zeros(3) = frame_a.t+Frames.resolve1(R_rel,frame_b.t);
   e_r_a = e*r_a;
   e_r_b = e*r_b;
   A = (-2)*(r_b*r_a-e_r_b*e_r_a);
   B = 2*r_b*cross(e,r_a);
   C = r_a*r_a+r_b*r_b-lengthConstraint*lengthConstraint-2*e_r_b*e_r_a;
   k1 = A*A+B*B;
   k1a = k1-C*C;
   assert(k1a>1.e-10,"
Singular position of loop (either no or two analytic solutions;
the mechanism has lost one-degree-of freedom in this position).
Try first to use another Modelica.Mechanics.MultiBody.Joints.Assemblies.JointXXX component.
In most cases it is best that the joints outside of the JointXXX
component are revolute and NOT prismatic joints. If this also
lead to singular positions, it could be that this kinematic loop
cannot be solved analytically. In this case you have to build
up the loop with basic joints (NO aggregation JointXXX components)
and rely on dynamic state selection, i.e., during simulation
the states will be dynamically selected in such a way that in no
position a degree of freedom is lost.
");
   k1b = Frames.Internal.maxWithoutEvent(k1a,1.0e-12);
   k2 = sqrt(k1b);
   kcos_angle = (-A)*C+(if positiveBranch then B else -B)*k2;
   ksin_angle = (-B)*C+(if positiveBranch then -A else A)*k2;
   angle = Modelica.Math.atan2(ksin_angle,kcos_angle);
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-30,10},{10,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,-60},{-30,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{30,-60},{100,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Text(extent={{-139,-168},{137,-111}},textString="%name",lineColor={0,0,255}),Rectangle(extent={{-100,60},{-30,-60}},lineColor={0,0,0}),Rectangle(extent={{30,60},{100,-60}},lineColor={0,0,0}),Text(extent={{-142,-108},{147,-69}},lineColor={0,0,0},textString="n=%n"),Line(points={{-60,60},{-60,90}},color={0,0,0}),Line(points={{-20,70},{-60,70}},color={0,0,0}),Line(points={{-20,80},{-20,60}},color={0,0,0}),Line(points={{20,80},{20,60}},color={0,0,0}),Line(points={{20,70},{41,70}},color={0,0,0}),Polygon(points={{-9,30},{10,30},{30,50},{-29,50},{-9,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(points={{10,30},{30,50},{30,-51},{10,-31},{10,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-10,90},{10,50}},lineColor={0,0,0},fillPattern=FillPattern.VerticalCylinder,fillColor={192,192,192})}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-100,-60},{-30,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Rectangle(extent={{-30,10},{10,-10}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{30,-60},{100,60}},lineColor={0,0,0},fillPattern=FillPattern.HorizontalCylinder,fillColor={192,192,192}),Line(points={{-60,60},{-60,96}},color={0,0,0}),Line(points={{-20,70},{-60,70}},color={0,0,0}),Line(points={{-20,80},{-20,60}},color={0,0,0}),Line(points={{20,80},{20,60}},color={0,0,0}),Line(points={{20,70},{41,70}},color={0,0,0}),Polygon(points={{-9,30},{10,30},{30,50},{-29,50},{-9,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Polygon(points={{10,30},{30,50},{30,-51},{10,-31},{10,30}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Rectangle(extent={{-10,50},{10,100}},lineColor={0,0,0},fillPattern=FillPattern.VerticalCylinder,fillColor={192,192,192})}),Documentation(info="<html>
<p>
Joint where frame_b rotates around axis n which is fixed in frame_a.
The two frames coincide when \"phi + phi_offset = 0\", where
\"phi_offset\" is a parameter with a zero default
and \"phi\" is the rotation angle.
</p>
<p>
This variant of the revolute joint is designed to work together
with a length constraint in a kinematic loop. This means that the
angle of the revolute joint, phi, is computed such that the
length constraint is fulfilled.
</p>
<p>
<b>Usually, this joint should not be used by a user of the MultiBody
library. It is only provided to built-up the Modelica.Mechanics.MultiBody.Joints.Assemblies.JointXYZ
joints.</b>
</p>

<p>
In releases before version 3.0 of the Modelica Standard Library, it was possible
to activate the torque projection equation (= cut-torque projected to the rotation
axis must be identical to the drive torque of flange axis) via parameter
<b>axisTorqueBalance</b>. This is no longer possible, since otherwise this
model would not be \"balanced\" (= same number of unknowns as equations).
Instead, when using this model in version 3.0 and later versions,
the force in the length constraint component (Joints.SphericalSpherical or
Joints.UniversalSpherical) must be calculated such that the driving torque
in direction of the rotation
axis is (RC shall be the name of the instance of RevoluteWithLenghtConstraint):
</p>
<pre>
    0 = RC.axis.tau + RC.e*RC.frame_b.t;
</pre>
<p>
If this equation is used, usually the force in the length constraint
and the second derivative of the revolute angle will be part of a linear
algebraic system of equations. In some cases it is possible to solve
this system of equations locally, i.e., provide the rod force directly
as function of the revolute constraint torque. In any case, this projection
equation or an equivalent one has to be provided via variable \"constraintResidue\" in the \"Advanced\"
menu of \"Joints.SphericalSpherical\" or \"Joints.UniversalSpherical\".
</p>

</html>
"));
  end RevoluteWithLengthConstraint;

  model PrismaticWithLengthConstraint
   "Prismatic joint where the translational distance is computed from a length constraint (1 degree-of-freedom, no potential state)"

   import SI = Modelica.SIunits;
   import Cv = Modelica.SIunits.Conversions;

  // locally defined classes in PrismaticWithLengthConstraint
      model _famefaults_axis = FAME.Dampers.TranslationalWithoutConnectEquations;
      model _famefaults_bearing = FAME.Dampers.TranslationalWithoutConnectEquations;

  // components of PrismaticWithLengthConstraint
   parameter Modelica.SIunits.Position s_guess=0 "Select the configuration such that at initial time |s(t0)-s_guess|is minimal";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{84,-16},{116,16}},rotation=0)));
   final parameter Boolean positiveBranch(fixed=false) "Selection of one of the two solutions of the non-linear constraint equation";
   parameter Modelica.SIunits.Distance boxHeight=boxWidth "Height of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Position r_rel_a[3] "Position vector from frame_a to frame_b resolved in frame_a";
   parameter Modelica.SIunits.Position s_offset=0 "Relative distance offset (distance between frame_a and frame_b = s(t) + s_offset)";
   parameter Modelica.SIunits.Distance boxWidth=world.defaultJointWidth "Width of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.SIunits.Position distance "Relative distance between frame_a and frame_b along axis n";
   parameter Modelica.Mechanics.MultiBody.Types.Axis boxWidthDirection={0,1,0} "Vector in width direction of box, resolved in frame_a" annotation(Evaluate=true,Dialog(tab="Animation",group="if animation = true",enable=animation));
   parameter Modelica.SIunits.Position length(start=1) "Fixed length of length constraint";
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent={{-116,-16},{-84,16}},rotation=0)));
   Modelica.Mechanics.Translational.Interfaces.Flange_a axis "1-dim. translational flange that drives the joint" annotation(Placement(transformation(extent={{70,80},{90,60}},rotation=0)));
   FAME.Dampers.TranslationalWithoutConnectEquations _famefault_axis(amount=0.0);
   Modelica.SIunits.Force f "= axis.f (driving force in the axis)";
   final parameter Real e[3](each final unit="1")=Modelica.Math.Vectors.normalize(n,0.0) "Unit vector in direction of translation axis, resolved in frame_a";
   parameter Boolean animation=true "= true, if animation shall be enabled";
   parameter Modelica.Mechanics.MultiBody.Types.Axis n={1,0,0} "Axis of translation resolved in frame_a (= same as in frame_b)" annotation(Evaluate=true);
   input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient=world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
   Modelica.Blocks.Interfaces.RealInput position_a[3] "Position vector from frame_a to frame_a side of length constraint, resolved in frame_a of revolute joint" annotation(Placement(transformation(extent={{-140,-80},{-100,-40}},rotation=0)));
   Modelica.SIunits.Position s "Relative distance between frame_a and frame_b along axis n = s + s_offset)";
   Modelica.Blocks.Interfaces.RealInput position_b[3] "Position vector from frame_b to frame_b side of length constraint, resolved in frame_b of revolute joint" annotation(Placement(transformation(extent={{140,-80},{100,-40}},rotation=0)));
   Modelica.Mechanics.Translational.Interfaces.Flange_b bearing "1-dim. translational flange of the drive bearing" annotation(Placement(transformation(extent={{-30,80},{-50,60}},rotation=0)));
   FAME.Dampers.TranslationalWithoutConnectEquations _famefault_bearing(amount=0.0);
   input Modelica.Mechanics.MultiBody.Types.Color boxColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of prismatic joint box" annotation(Dialog(tab="Animation",group="if animation = true",enable=animation));
  protected

   function selectBranch
    "Determine branch which is closest to initial angle=0"

    import Modelica.Math.*;

   // components of selectBranch
    input SI.Length L "Length of length constraint";
    input Real e[3](each final unit="1") "Unit vector along axis of translation, resolved in frame_a (= same in frame_b)";
    input SI.Position d_guess "Select the configuration such that at initial time |d-d_guess|is minimal (d: distance between origin of frame_a and origin of frame_b)";
    input SI.Position r_a[3] "Position vector from frame_a to frame_a side of length constraint, resolved in frame_a of prismatic joint";
    input SI.Position r_b[3] "Position vector from frame_b to frame_b side of length constraint, resolved in frame_b of prismatic joint";
    output Boolean positiveBranch "Branch of the initial solution";
   protected
    Modelica.SIunits.Position rbra[3] "= rb - ra";
    Real B "Coefficient B of equation: d*d + B*d + C = 0";
    Real C "Coefficient C of equation: d*d + B*d + C = 0";
    Real k1 "Constant of quadratic equation solution";
    Real k2 "Constant of quadratic equation solution";
    Real k1a;
    Real k1b;
    Real d1 "solution 1 of quadratic equation";
    Real d2 "solution 2 of quadratic equation";

   // algorithms and equations of selectBranch
   algorithm
      rbra:=r_b-r_a;
      B:=2*e*rbra;
      C:=rbra*rbra-L*L;
      k1:=B/(2);
      k1a:=k1*k1-C;
      assert(noEvent(k1a>1.e-10),"
Singular position of loop (either no or two analytic solutions;
the mechanism has lost one-degree-of freedom in this position).
Try first to use another Modelica.Mechanics.MultiBody.Joints.Assemblies.JointXXX component.
If this also lead to singular positions, it could be that this
kinematic loop cannot be solved analytically with a fixed state
selection. In this case you have to build up the loop with
basic joints (NO aggregation JointXXX components) and rely on
dynamic state selection, i.e., during simulation the states will
be dynamically selected in such a way that in no position a
degree of freedom is lost.
");
      k1b:=max(k1a,1.0e-12);
      k2:=sqrt(k1b);
      d1:=-k1+k2;
      d2:=-k1-k2;
      if abs(d1-d_guess)<=abs(d2-d_guess) then
        positiveBranch:=true;
      else
        positiveBranch:=false;
      end if;
   end selectBranch;
  protected
   Real B "Coefficient B of equation: s*s + B*s + C = 0";
   Real C "Coefficient C of equation: s*s + B*s + C = 0";
   Modelica.SIunits.Position r_a[3]=position_a "Position vector from frame_a to frame_a side of length constraint, resolved in frame_a of revolute joint";
   Modelica.SIunits.Position r_b[3]=position_b "Position vector from frame_b to frame_b side of length constraint, resolved in frame_b of revolute joint";
   Modelica.SIunits.Position rbra[3] "= rb - ra";
   Real k1 "Constant of quadratic equation solution";
   Real k2 "Constant of quadratic equation solution";
   Real k1a(start=1);
   Real k1b;
   Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape box(shapeType="box",color=boxColor,specularCoefficient=specularCoefficient,length=(if noEvent(abs(s+s_offset)>1.e-6) then s+s_offset else 1.e-6),width=boxWidth,height=boxHeight,lengthDirection=e,widthDirection=boxWidthDirection,r=frame_a.r_0,R=frame_a.R) if world.enableAnimation and animation;
   outer Modelica.Mechanics.MultiBody.World world;

  // algorithms and equations of PrismaticWithLengthConstraint
  initial equation
   positiveBranch = selectBranch(length,e,s_offset+s_guess,r_a,r_b);
  equation
   Connections.branch(frame_a.R,frame_b.R);
   _famefault_axis.port_b.f = f;
   _famefault_axis.port_b.s = s;
   _famefault_bearing.port_b.s = 0;
   distance = s_offset+s;
   r_rel_a = e*distance;
   frame_b.r_0 = frame_a.r_0+Frames.resolve1(frame_a.R,r_rel_a);
   frame_b.R = frame_a.R;
   zeros(3) = frame_a.f+frame_b.f;
   zeros(3) = frame_a.t+frame_b.t+cross(r_rel_a,frame_b.f);
   rbra = r_b-r_a;
   B = 2*e*rbra;
   C = rbra*rbra-length*length;
   k1 = B/(2);
   k1a = k1*k1-C;
   assert(noEvent(k1a>1.e-10),"
Singular position of loop (either no or two analytic solutions;
the mechanism has lost one-degree-of freedom in this position).
Try first to use another Modelica.Mechanics.MultiBody.Joints.Assemblies.JointXXX component.
If this also lead to singular positions, it could be that this
kinematic loop cannot be solved analytically with a fixed state
selection. In this case you have to build up the loop with
basic joints (NO aggregation JointXXX components) and rely on
dynamic state selection, i.e., during simulation the states will
be dynamically selected in such a way that in no position a
degree of freedom is lost.
");
   k1b = Frames.Internal.maxWithoutEvent(k1a,1.0e-12);
   k2 = sqrt(k1b);
   distance = -k1+(if positiveBranch then k2 else -k2);
   assert(cardinality(frame_a)>0,"Connector frame_a of component is not connected");
   assert(cardinality(frame_b)>0,"Connector frame_b of component is not connected");
   connect(axis,_famefault_axis.port_a);
   connect(bearing,_famefault_bearing.port_a);

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Rectangle(extent={{-30,-40},{100,30}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-30,40},{100,-40}},lineColor={0,0,0}),Rectangle(extent={{-100,-60},{-30,50}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-100,50},{-30,60}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-30,30},{100,40}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Text(extent={{-136,-170},{140,-113}},textString="%name",lineColor={0,0,255}),Rectangle(extent={{-100,60},{-30,-60}},lineColor={0,0,0}),Line(points={{100,-40},{100,-60}},color={0,0,255}),Rectangle(extent={{100,40},{90,80}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid),Text(extent={{-136,-116},{153,-77}},lineColor={0,0,0},textString="n=%n")}),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}},grid={1,1}),graphics={Line(points={{-30,-50},{-30,50}},color={0,0,0}),Line(points={{0,-67},{90,-67}},color={128,128,128}),Text(extent={{31,-68},{68,-81}},lineColor={128,128,128},textString="s"),Line(points={{-100,-67},{0,-67}},color={128,128,128}),Polygon(points={{-39,-64},{-29,-67},{-39,-70},{-39,-64}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{-77,-70},{-43,-85}},lineColor={128,128,128},textString="s_offset"),Line(points={{-100,-71},{-100,-51}},color={128,128,128}),Line(points={{-30,-73},{-30,-33}},color={128,128,128}),Line(points={{100,-70},{100,-30}},color={128,128,128}),Polygon(points={{90,-64},{100,-67},{90,-70},{90,-64}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Rectangle(extent={{-100,50},{-30,60}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-100,-60},{-30,50}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-30,40},{100,-40}},lineColor={0,0,0}),Rectangle(extent={{-30,-40},{100,30}},pattern=LinePattern.None,fillColor={192,192,192},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-30,30},{100,40}},pattern=LinePattern.None,fillColor={0,0,0},fillPattern=FillPattern.Solid,lineColor={0,0,255}),Rectangle(extent={{-100,60},{-30,-60}},lineColor={0,0,0}),Line(points={{100,-40},{100,-60}},color={0,0,255}),Text(extent={{42,91},{57,76}},textString="f",lineColor={0,0,255}),Line(points={{40,75},{70,75}},color={0,0,255}),Polygon(points={{-21,78},{-31,75},{-21,72},{-21,78}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Line(points={{-8,75},{-31,75}},color={0,0,255}),Text(extent={{-21,90},{-6,75}},textString="f",lineColor={0,0,255}),Polygon(points={{60,78},{70,75},{60,72},{60,78}},lineColor={0,0,255},fillColor={0,0,255},fillPattern=FillPattern.Solid),Line(points={{-30,64},{70,64}},color={128,128,128}),Polygon(points={{60,67},{70,64},{60,61},{60,67}},lineColor={128,128,128},fillColor={128,128,128},fillPattern=FillPattern.Solid),Text(extent={{0,63},{37,50}},lineColor={128,128,128},textString="s"),Rectangle(extent={{100,40},{90,80}},lineColor={0,0,0},fillColor={192,192,192},fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
<p>
Joint where frame_b is translated along axis n which is fixed in frame_a.
The two frames coincide when \"s + s_offset = 0\", where
\"s_offset\" is a parameter with a zero default
and \"s\" is the relative distance.
</p>
<p>
This variant of the prismatic joint is designed to work together
with a length constraint in a kinematic loop. This means that the
relative distance \"s\" of the joint is computed such that the
length constraint is fulfilled.
</p>
<p>
<b>Usually, this joint should not be used by a user of the MultiBody
library. It is only provided to built-up the Modelica.Mechanics.MultiBody.Joints.Assemblies.JointXYZ
joints.</b>
</p>

<p>
In releases before version 3.0 of the Modelica Standard Library, it was possible
to activate the force projection equation (= cut-force projected to the translation
axis must be identical to the driving force of flange axis) via parameter
<b>axisForceBalance</b>. This is no longer possible, since otherwise this
model would not be \"balanced\" (= same number of unknowns as equations).
Instead, when using this model in version 3.0 and later versions,
the force in the length constraint component (Joints.SphericalSpherical or
Joints.UniversalSpherical) must be calculated such that the driving force
in direction of the translation
axis is (RC shall be the name of the instance of PrismaticWithLenghtConstraint):
</p>
<pre>
    0 = RC.axis.f + RC.e*RC.frame_b.f;
</pre>
<p>
If this equation is used, usually the force in the length constraint
and the second derivative of the prismatic distance will be part of a linear
algebraic system of equations. In some cases it is possible to solve
this system of equations locally, i.e., provide the rod force directly
as function of the prismatic constraint force. In any case, this projection
equation or an equivalent one has to be provided via variable \"constraintResidue\" in the \"Advanced\"
menu of \"Joints.SphericalSpherical\" or \"Joints.UniversalSpherical\".
</p>

</HTML>
"));
  end PrismaticWithLengthConstraint;

  model RollingConstraintVerticalWheel
   "Rolling constraint for wheel that is always perpendicular to x-y plane"

   import SI = Modelica.SIunits;
   import Modelica.Mechanics.MultiBody.Frames;

  // components of RollingConstraintVerticalWheel
   Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Frame fixed in wheel center point. x-Axis: upwards, y-axis: along wheel axis" annotation(Placement(transformation(extent={{-16,4},{16,36}}),iconTransformation(extent={{-16,4},{16,36}})));
   parameter SI.Radius radius "Wheel radius";
   parameter Boolean lateralSlidingConstraint=true "= true, if lateral sliding constraint taken into account, = false if lateral force = 0 (needed to avoid overconstraining if two ideal rolling wheels are connect on one axis)" annotation(choices(__Dymola_checkBox=true),HideResult=true,Evaluate=true);
   SI.Force f_wheel_0[3] "Contact force acting on wheel, resolved in world frame";
   SI.Force f_lat "Contact force acting on wheel in lateral direction";
   SI.Force f_long "Contact force acting on wheel in longitudinal direction";
  protected
   Real e_axis_0[3] "Unit vector along wheel axis, resolved in world frame";
   SI.Position rContact_0[3] "Distance vector from wheel center to contact point, resolved in world frame";
   Real e_n_0[3] "Unit vector in normal direction of road at contact point, resolved in world frame";
   Real e_lat_0[3] "Unit vector in lateral direction of wheel at contact point, resolved in world frame";
   Real e_long_0[3] "Unit vector in longitudinal direction of wheel at contact point, resolved in world frame";
   SI.Velocity v_0[3] "Velocity of wheel center, resolved in world frame";
   SI.AngularVelocity w_0[3] "Angular velocity of wheel, resolved in world frame";
   SI.Velocity vContact_0[3] "Velocity of wheel contact point, resolved in world frame";
   Real aux[3];

  // algorithms and equations of RollingConstraintVerticalWheel
  equation
   e_n_0 = {0,0,1};
   e_axis_0 = Frames.resolve1(frame_a.R,{0,1,0});
   aux = cross(e_n_0,e_axis_0);
   e_long_0 = aux/(Modelica.Math.Vectors.length(aux));
   e_lat_0 = cross(e_long_0,e_n_0);
   rContact_0 = {0,0,-radius};
   v_0 = der(frame_a.r_0);
   w_0 = Frames.angularVelocity1(frame_a.R);
   vContact_0 = v_0+cross(w_0,rContact_0);
   0 = vContact_0*e_long_0;
   if lateralSlidingConstraint then
    0 = vContact_0*e_lat_0;
    f_wheel_0 = f_lat*e_lat_0+f_long*e_long_0;
   else
    0 = f_lat;
    f_wheel_0 = f_long*e_long_0;
   end if;
   zeros(3) = frame_a.f+Frames.resolve2(frame_a.R,f_wheel_0);
   zeros(3) = frame_a.t+Frames.resolve2(frame_a.R,cross(rContact_0,f_wheel_0));

  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,-60},{100,-80}},lineColor={0,0,0},fillColor={175,175,175},fillPattern=FillPattern.Solid),Text(extent={{-148,-86},{152,-126}},lineColor={0,0,255},textString="%name"),Line(points={{0,-60},{0,4}},color={0,0,0},smooth=Smooth.None,pattern=LinePattern.Dot),Line(visible=lateralSlidingConstraint,points={{-98,-30},{-16,-30}},color={0,0,0},smooth=Smooth.None),Polygon(visible=lateralSlidingConstraint,points={{-40,-16},{-40,-42},{-6,-30},{-40,-16}},lineColor={0,0,0},smooth=Smooth.None,fillColor={255,255,255},fillPattern=FillPattern.Solid)}),Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),graphics));
  end RollingConstraintVerticalWheel;

 annotation(Documentation(info="<HTML>
<p>
The models in this package should not be used by the user.
They are designed to build up other models in the MultiBody library
and some of them cannot be used in an arbitrary way and require
particular knowledge how to set the options in the parameter menu.
Don't use the models of this package.
</p>
</HTML>"));
 end Internal;

annotation(Documentation(info="<HTML>
<p>
This package contains <b>joint components</b>,
that is, idealized, massless elements that constrain
the motion between frames. In subpackage <b>Assemblies</b>
aggregation joint components are provided to handle
kinematic loops analytically (this means that non-linear systems
of equations occuring in these joint aggregations are analytically
solved, i.e., robustly and efficiently).
</p>
<h4>Content</h4>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Model</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Prismatic\">Prismatic</a>
      <td valign=\"top\">Prismatic joint and actuated prismatic joint
          (1 translational degree-of-freedom, 2 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Prismatic.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Revolute\">Revolute</a>
 </td>
      <td valign=\"top\">Revolute and actuated revolute joint
          (1 rotational degree-of-freedom, 2 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Revolute.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Cylindrical\">Cylindrical</a></td>
      <td valign=\"top\">Cylindrical joint (2 degrees-of-freedom, 4 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Cylindrical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Universal\">Universal</a></td>
      <td valign=\"top\">Universal joint (2 degrees-of-freedom, 4 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Universal.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Planar\">Planar</a></td>
      <td valign=\"top\">Planar joint (3 degrees-of-freedom, 6 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Planar.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Spherical\">Spherical</a></td>
      <td valign=\"top\">Spherical joint (3 constraints and no potential states, or 3 degrees-of-freedom and 3 states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/Spherical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.FreeMotion\">FreeMotion</a></td>
      <td valign=\"top\">Free motion joint (6 degrees-of-freedom, 12 potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/FreeMotion.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.SphericalSpherical\">SphericalSpherical</a></td>
      <td valign=\"top\">Spherical - spherical joint aggregation (1 constraint,
          no potential states) with an optional point mass in the middle<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/SphericalSpherical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.UniversalSpherical\">UniversalSpherical</a></td>
      <td valign=\"top\">Universal - spherical joint aggregation (1 constraint, no potential states)<br>
      <IMG src=\"modelica://Modelica/Resources/Images/MultiBody/Joints/UniversalSpherical.png\">
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.GearConstraint\">GearConstraint</a></td>
      <td valign=\"top\">Ideal 3-dim. gearbox (arbitrary shaft directions)
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Mechanics.MultiBody.Joints.Assemblies\">MultiBody.Joints.Assemblies</a></td>
      <td valign=\"top\"><b>Package</b> of joint aggregations for analytic loop handling.
      </td>
  </tr>
</table>
</HTML>"));
end Joints;

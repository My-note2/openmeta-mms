// processed by FAME Modelica Library Fault-Augmentor [version 19011]

within Modelica.Electrical.QuasiStationary;

package Types
 "Definiton of types for quasistationary AC models"
 extends Modelica.Icons.Package;

 record Reference
  "Reference angle"

 // locally defined classes in Reference

  function equalityConstraint
   "Equality constraint for reference angle"

  // components of equalityConstraint
   input Reference reference1;
   input Reference reference2;
   output Real residue[0];

  // algorithms and equations of equalityConstraint
  algorithm
     assert(abs(reference1.gamma-reference2.gamma)<(1E-6*2*Modelica.Constants.pi),"Reference angles should be equal!");

  annotation(Documentation(info="<html>
Equality constraint for the reference angle, according to the Modelica Specification (Overdetermined connection sets).
</html>"));
  end equalityConstraint;

 // components of Reference
  Modelica.SIunits.Angle gamma;

 annotation(Documentation(info="<html>
Reference angle, used in the AC connectors.
</html>"));
 end Reference;

annotation(Documentation(info="<html>
Type defintions needed for quasistaionary AC models.
</html>"));
end Types;

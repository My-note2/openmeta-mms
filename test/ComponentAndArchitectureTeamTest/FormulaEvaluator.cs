﻿﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Xunit;
using System.IO;
using GME.MGA;
using GME.CSharp;
using CyPhy = ISIS.GME.Dsml.CyPhyML.Interfaces;
using CyPhyClasses = ISIS.GME.Dsml.CyPhyML.Classes;
using System.Runtime.InteropServices;

namespace ComponentAndArchitectureTeamTest
{
    public class FormulaEvaluatorFixture : IDisposable
    {
        public string mgaPath;
        public static readonly string testPath = Path.Combine(
            META.VersionInfo.MetaPath,
            "models",
            "ComponentsAndArchitectureTeam",
            "FormulaEvaluator"
            );

        public virtual string xmePath
        {
            get
            {
                return Path.Combine(
                    testPath,
                    "FormulaEvaluator.xme"
                    );
            }
        }

        public FormulaEvaluatorFixture()
        {
            String mgaConnectionString;
            GME.MGA.MgaUtils.ImportXMEForTest(xmePath, out mgaConnectionString);
            mgaPath = mgaConnectionString.Substring("MGA=".Length);

            Assert.True(File.Exists(Path.GetFullPath(mgaPath)),
                        String.Format("{0} not found. Model import may have failed.", mgaPath));

            proj = new MgaProject();
            bool ro_mode;
            proj.Open("MGA=" + Path.GetFullPath(mgaPath), out ro_mode);
            proj.EnableAutoAddOns(true);
        }

        public void Dispose()
        {
            proj.Save();
            proj.Close();
            proj = null;
        }

        public MgaProject proj { get; private set; }
    }

    internal static class Utils
    {
        public static void PerformInTransaction(this MgaProject project, MgaGateway.voidDelegate del)
        {
            var mgaGateway = new MgaGateway(project);
            mgaGateway.PerformInTransaction(del, abort: false);
        }

        public static IEnumerable<CyPhy.Component> GetComponentsByName(this MgaProject project, String name)
        {
            MgaFilter filter = project.CreateFilter();
            filter.Kind = "Component";
            filter.Name = name;

            return project.AllFCOs(filter)
                          .Cast<MgaFCO>()
                          .Select(x => CyPhyClasses.Component.Cast(x))
                          .Cast<CyPhy.Component>()
                          .Where(c => c.ParentContainer.Kind == "Components");

        }
    }

    public class FormulaEvaluator : IUseFixture<FormulaEvaluatorFixture>
    {
        #region Fixture
        FormulaEvaluatorFixture fixture;
        public void SetFixture(FormulaEvaluatorFixture data)
        {
            fixture = data;
        }
        #endregion

        public string[] RunFormulaEvaluator(MgaFCO currentobj, string automation = "true")
        {
            // create formula evaluator type
            Type typeFormulaEval = Type.GetTypeFromProgID("MGA.Interpreter.CyPhyFormulaEvaluator");
            IMgaComponentEx formulaEval = Activator.CreateInstance(typeFormulaEval) as IMgaComponentEx;

            // empty selected object set
            Type typeMgaFCOs = Type.GetTypeFromProgID("Mga.MgaFCOs");
            MgaFCOs selectedObjs = Activator.CreateInstance(typeMgaFCOs) as MgaFCOs;

            // initialize formula evaluator
            formulaEval.Initialize(fixture.proj);

            // automation means no UI element shall be shown by the interpreter
            formulaEval.ComponentParameter["automation"] = automation;

            // do not write to the console
            formulaEval.ComponentParameter["console_messages"] = "off";

            // do not generate the post processing python scripts
            // FIXME: Why should we generate them ???
            formulaEval.ComponentParameter["do_not_generate_post_processing"] = "true";

            // call the formula evaluator and update all parameters starting from the current object
            formulaEval.InvokeEx(fixture.proj, currentobj, selectedObjs, 16);

            string[] numericLeafNodes = (string[])formulaEval.ComponentParameter["numericLeafNodes"];
            return numericLeafNodes;
        }

        [Fact]
        public void ValueAssign_Fraction()
        {
            // Find the object we want
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("ValueAssign_Fraction").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var Prop2 = comp.Children.PropertyCollection.Where(p => p.Name == "Prop2").First();
                Assert.True(Prop2.Attributes.Value == "0.25",
                            String.Format("{0} should have had value {1}; instead found {2}", Prop2.Name, "0.25", Prop2.Attributes.Value)
                            );
            });
        }

        [Fact]
        public void SimpleFormula_Fraction()
        {
            // Find the object we want
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("SimpleFormula_Fraction").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var Prop2 = comp.Children.PropertyCollection.Where(p => p.Name == "Prop3").First();
                Assert.True(Prop2.Attributes.Value == "1",
                            String.Format("{0} should have had value {1}; instead found {2}", Prop2.Name, "1", Prop2.Attributes.Value)
                            );
            });
        }

        [Fact]
        public void CustomFormula_Fraction()
        {
            // Find the object we want
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("CustomFormula_Fraction").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var Prop2 = comp.Children.PropertyCollection.Where(p => p.Name == "Prop3").First();
                Assert.True(Prop2.Attributes.Value == "1",
                            String.Format("{0} should have had value {1}; instead found {2}", Prop2.Name, "1", Prop2.Attributes.Value)
                            );
            });
        }

        [Fact]
        public void CustomFormula_Circular()
        {
            // Find the object we want
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("CustomFormula_Circular").First();
                try
                {
                    RunFormulaEvaluator(comp.Impl as MgaFCO);
                }
                catch (COMException e)
                {
                    Assert.True(e.Message.Contains("CustomFormula_Circular/Prop1"));
                    Assert.True(e.Message.Contains("CustomFormula_Circular/Prop2"));
                    Assert.True(e.Message.Contains("CustomFormula_Circular/Prop3"));
                    Assert.True(e.Message.Contains("CustomFormula_Circular/Prop4"));
                    return;
                }
                Assert.True(false, "FormulaEvaluator should have failed");
            });
        }

        [Fact]
        public void DivideByZero()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("DivideByZero")
                                       .First();

                var prop3 = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop3")
                                         .First();
                var prop3_OldValue = prop3.Attributes.Value;

                Assert.Throws(typeof(COMException), delegate
                {
                    RunFormulaEvaluator(comp.Impl as MgaFCO);
                });

                var prop3_NewValue = prop3.Attributes.Value;
                Assert.True(prop3_OldValue == prop3_NewValue, "Value of Prop3 shouldn't have changed");
            });
        }

        [Fact]
        public void ConstantPropagation_Prop()
        {
            // test for constant propagation into a property and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("ConstantPropagation_Prop")
                                       .First();

                var propuut = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "PropFromConst")
                                         .First();
                var propuut_preValue = propuut.Attributes.Value;
                var constseed = comp.Children.ConstantCollection
                                         .Where(p => p.Name == "Const2Prop")
                                         .First();

                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var propuut_postValue = propuut.Attributes.Value;
                Assert.False(propuut_preValue == propuut_postValue, String.Format("{0} should have changed from {1} to {2} but it is {3}", propuut.Name, propuut_preValue, constseed.Attributes.ConstantValue, propuut_postValue));
            });
        }

        [Fact]
        public void ConstantPropagation_Param()
        {
            // test for constant propagation into a parameter
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("ConstantPropagation_Param")
                                       .First();

                var paramuut = comp.Children.ParameterCollection
                                         .Where(p => p.Name == "ParamFromConst")
                                         .First();
                var paramuut_preValue = paramuut.Attributes.Value;
                var constseed = comp.Children.ConstantCollection
                                         .Where(p => p.Name == "Const2Param")
                                         .First();

                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var paramuut_postValue = paramuut.Attributes.Value;
                Assert.False(paramuut_preValue == paramuut_postValue, String.Format("{0} should have changed from {1} to {2} but it is {3}", paramuut.Name, paramuut_preValue, constseed.Attributes.ConstantValue, paramuut_postValue));
            });
        }

        [Fact]
        public void ConstantPropagation_Simple_Formula()
        {
            // test for constant propagation into a Simple Fomula and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("ConstantPropagation_Simple_Formula")
                                       .First();

                var propuut = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "PropFromSimple")
                                         .First();
                var propuut_preValue = propuut.Attributes.Value;

                var constseed = comp.Children.ConstantCollection
                                         .Where(p => p.Name == "Const2Simple")
                                         .First();
                var propseed = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop2Simple")
                                         .First();

                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var propuut_postValue = propuut.Attributes.Value;
                var desired_result = constseed.Attributes.ConstantValue * int.Parse(propseed.Attributes.Value);
                Assert.False(propuut_preValue == propuut_postValue, String.Format("{0} should have changed from {1} to {2} but it is {3}", propuut.Name, propuut_preValue, desired_result, propuut_postValue));
            });
        }

        [Fact]
        public void ConstantPropagation_Custom_Formula()
        {
            // test for constant propagation into a Custom Fomula and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("ConstantPropagation_Custom_Formula")
                                       .First();

                var propuut = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "PropFromCustom")
                                         .First();
                var propuut_preValue = propuut.Attributes.Value;

                var constseed = comp.Children.ConstantCollection
                                         .Where(p => p.Name == "Const2Custom")
                                         .First();
                var propseed = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop2Custom")
                                         .First();

                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var propuut_postValue = propuut.Attributes.Value;
                var desired_result = constseed.Attributes.ConstantValue * (int.Parse(propseed.Attributes.Value) - constseed.Attributes.ConstantValue);
                Assert.False(propuut_preValue == propuut_postValue, String.Format("{0} should have changed from {1} to {2} but it is {3}", propuut.Name, propuut_preValue, desired_result, propuut_postValue));
            });
        }

        [Fact]
        public void TryAssignConstant()
        {
            // test for constant propagation into a Custom Fomula and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("TryAssignConstant")
                                       .First();

                Assert.Throws(typeof(COMException), delegate
                {
                    RunFormulaEvaluator(comp.Impl as MgaFCO);
                });
            });
        }

        [Fact]
        public void Minimum_with_Negatives()
        {
            // test for constant propagation into a Custom Fomula and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("Minimum_with_negatives")
                                       .First();

                var prop3uut = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop3")
                                         .First();
                var prop6uut = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop6")
                                         .First();
                var prop1seed = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop1")
                                         .First();
                var prop2seed = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop2")
                                         .First();
                var prop4seed = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop4")
                                         .First();
                var prop5seed = comp.Children.PropertyCollection
                                         .Where(p => p.Name == "Prop5")
                                         .First();

                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var desired3 = Math.Min(int.Parse(prop1seed.Attributes.Value), int.Parse(prop2seed.Attributes.Value));
                Assert.True(int.Parse(prop3uut.Attributes.Value) == desired3, String.Format("{0} should have a value of {1} and not {2}", prop3uut.Name, desired3, prop3uut.Attributes.Value));

                var desired6 = Math.Min(int.Parse(prop4seed.Attributes.Value), int.Parse(prop5seed.Attributes.Value));
                Assert.True(int.Parse(prop6uut.Attributes.Value) == desired6, String.Format("{0} should have a value of {1} and not {2}", prop6uut.Name, desired6, prop6uut.Attributes.Value));
            });
        }

        [Fact]
        public void SimpleFormulaIntoCADTest()
        {
            // Find the object we want
            fixture.proj.PerformInTransaction(delegate
            {
                // open the correct component
                var comp = fixture.proj.GetComponentsByName("SimpleFormulaIntoCAD").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                // retrieve values
                var Prop1 = comp.Children.PropertyCollection.Where(p => p.Name == "Prop_1").First();
                var Prop2 = comp.Children.PropertyCollection.Where(p => p.Name == "Prop_2").First();
                var mdl = comp.Children.CADModelCollection.Where(p => p.Name == "CADModel1").First();

                // check math by hand
                var correct_result = int.Parse(Prop1.Attributes.Value) * int.Parse(Prop2.Attributes.Value);

                // get GME result
                var actual_result = mdl.Children.CADParameterCollection.Where(p => p.Name == "Param_Product").First();

                //compare
                Assert.True(actual_result.Attributes.Value.Equals(correct_result.ToString()),
                            String.Format("{0} should have had value {1} (from multiplying {2} and {3}); instead found {4}", actual_result.Name, correct_result, Prop1.Attributes.Value, Prop2.Attributes.Value, actual_result.Attributes.Value)
                            );
            });
        }

        [Fact]
        public void GeometricMean_with_Negatives()
        {
            // test for constant propagation into a Custom Fomula and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                // open correct component
                var comp = fixture.proj.GetComponentsByName("GeoMean_with_negatives")
                                       .First();

                var prop3uut = comp.Children.PropertyCollection
                         .Where(p => p.Name == "Prop3")
                         .First();

                // run the evaluator
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                // Should return a value of -1 and an error message to the user.
                Assert.True(prop3uut.Attributes.Value == "-1", String.Format("{0} should have a value of {1} and not {2}", prop3uut.Name, "-1", prop3uut.Attributes.Value));
            });
        }

        [Fact]
        public void CADComputation()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var sot = (MgaFCO)fixture.proj.get_ObjectByPath("/@Testing/@TestBenchSuites/@CADComputation");
                Assert.NotNull(sot);
                string[] numericLeafNodes = RunFormulaEvaluator(sot);
                var mass_g = (MgaFCO)fixture.proj.get_ObjectByPath("/@Testing/@TestBenchSuites/@CADComputation/@Mass");
                Assert.NotNull(mass_g);
                Assert.Equal("10000", mass_g.get_StrAttrByName("Value"));
                Assert.Equal(new string[] { "Mass" }, numericLeafNodes);
            });
        }

        [Fact]
        public void CADComputation_NoUnit()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var sot = (MgaFCO)fixture.proj.get_ObjectByPath("/@Testing/@TestBenchSuites/@CADComputation_NoUnit");
                Assert.NotNull(sot);
                string[] numericLeafNodes = RunFormulaEvaluator(sot);
                var mass_g = (MgaFCO)fixture.proj.get_ObjectByPath("/@Testing/@TestBenchSuites/@CADComputation_NoUnit/@Mass");
                Assert.NotNull(mass_g);
                Assert.Equal("10", mass_g.get_StrAttrByName("Value"));
                Assert.Equal(new string[] { "Mass" }, numericLeafNodes);
            });
        }

        [Fact]
        public void StringValue()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("StringValue").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var srcProp = comp.Children.PropertyCollection.First(p => p.Name == "SrcStringProp");
                var dstProp = comp.Children.PropertyCollection.First(p => p.Name == "DstStringProp");
                Assert.Equal(srcProp.Attributes.Value, dstProp.Attributes.Value);
            });
        }

        [Fact]
        public void StringFormula()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("StringFormula").First();
                Assert.Throws(typeof(COMException), () => RunFormulaEvaluator(comp.Impl as MgaFCO));
            });
        }
        [Fact]

        public void EmptyInputFormula()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("EmptyInputFormula").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var srcProp = comp.Children.PropertyCollection.First(p => p.Name == "Property");
                var dstProp = comp.Children.PropertyCollection.First(p => p.Name == "DstProp");
                Assert.Equal(srcProp.Attributes.Value, dstProp.Attributes.Value);
            });
        }

        [Fact]
        public void DegreesUnitFlow()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("DegreesUnitFlow").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var srcProp = comp.Children.PropertyCollection.First(p => p.Name == "PropertyInDegrees");
                var dstProp = comp.Children.PropertyCollection.First(p => p.Name == "UnspecifiedUnit");
                Assert.Equal(srcProp.Attributes.Value, dstProp.Attributes.Value);
            });
        }

        [Fact]
        public void ModelicaMatrix()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.GetComponentsByName("ModelicaMatrix").First();
                RunFormulaEvaluator(comp.Impl as MgaFCO);

                var srcProp = comp.Children.PropertyCollection.First(p => p.Name == "Property");
                var dstParam = CyPhyClasses.ModelicaParameter.Cast(comp.Impl.ObjectByPath["/@ModelicaModel/@Parameter"]);
                Assert.Equal(srcProp.Attributes.Value, dstParam.Attributes.Value);
            });
        }


        [Fact]
        public void BaseAssembly()
        {
            MgaFCO fcoAsm = null;
            fixture.proj.PerformInTransaction(delegate
            {
                var path = "/@ComponentAssemblies/@BaseAssembly";
                fcoAsm = (MgaFCO)fixture.proj.get_ObjectByPath(path);
                Assert.True(fcoAsm != null, String.Format("Could not find {0} in {1}", path, fixture.proj.ProjectConnStr));
            });

            RunFormulaEvaluator(fcoAsm, "false");

            fixture.proj.PerformInTransaction(delegate
            {
                var asm = CyPhyClasses.ComponentAssembly.Cast(fcoAsm);
                var outMetric = asm.Children.MetricCollection.Single(p => p.Name == "OutMetric");
                Assert.Equal("100", outMetric.Attributes.Value);
                var outParamater = asm.Children.ParameterCollection.Single(p => p.Name == "OutParameter");
                Assert.Equal("100", outParamater.Attributes.Value);

                Assert.Equal(1, asm.Children.ComponentRefCollection.Count());
                Assert.Equal(0, asm.Children.ComponentCollection.Count());
            });
        }

        [Fact]
        public void HierarchyWithRef()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var path = "/@ComponentAssemblies/@IntoReferences";
                var fcoAsm = (MgaFCO)fixture.proj.get_ObjectByPath(path);
                Assert.True(fcoAsm != null, String.Format("Could not find {0} in {1}", path, fixture.proj.ProjectConnStr));

                RunFormulaEvaluator(fcoAsm);

                var asm = CyPhyClasses.ComponentAssembly.Cast(fcoAsm);

                var parameters = asm.Children.ParameterCollection.Where(p => p.Name.StartsWith("Derived"))
                                    .Union(asm.Children.ComponentAssemblyCollection.SelectMany(ca => ca.Children.ParameterCollection));
                foreach (var param in parameters)
                {
                    Assert.Equal("5", param.Attributes.Value);
                }

                var props = asm.Children.PropertyCollection.Where(p => p.Name.StartsWith("Derived"));
                foreach (var prop in props)
                {
                    Assert.Equal("5", prop.Attributes.Value);
                }
            });
        }

        [Fact]
        public void DriveHigherLevel_RunFormulaEvalHere()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var path = "/@ComponentAssemblies/@DriveHigherLevel/@RunFormulaEvalHere";
                var fcoAsm = (MgaFCO)fixture.proj.get_ObjectByPath(path);
                Assert.True(fcoAsm != null, String.Format("Could not find {0} in {1}", path, fixture.proj.ProjectConnStr));

                RunFormulaEvaluator(fcoAsm);

                var asm = CyPhyClasses.ComponentAssembly.Cast(fcoAsm);

                foreach (var param in asm.Children.PropertyCollection)
                {
                    Assert.Equal("0.10000000000000002", param.Attributes.Value);
                }
            });
        }

        [Fact]
        public void UnitsAndFormulas()
        {
            // test for constant propagation into a Custom Fomula and back to a constant
            fixture.proj.PerformInTransaction(delegate
            {
                var comp = fixture.proj.ObjectByPath["/@ComponentAssemblies/@UnitsAndFormulas"];

                var output = (IMgaFCO)comp.ObjectByPath["@Output"];

                RunFormulaEvaluator(comp as MgaFCO);

                Assert.Equal((2 * 3 * 4 * 100 * 100).ToString(), output.StrAttrByName["Value"]);
            });
        }

    }

    public class FormulaEvaluator2Fixture : FormulaEvaluatorFixture
    {
        public override string xmePath
        {
            get
            {
                return Path.Combine(
                    testPath,
                    "FormulaEvaluator2.xme"
                    );
            }
        }
    }
    public class FormulaEvaluator2 : IUseFixture<FormulaEvaluator2Fixture>
    {

        #region Fixture
        FormulaEvaluator2Fixture fixture;
        public void SetFixture(FormulaEvaluator2Fixture data)
        {
            fixture = data;
        }
        #endregion

        [Fact]
        public void GenericParameters()
        {
            fixture.proj.PerformInTransaction(delegate
            {
                var asm = fixture.proj.ObjectByPath["/@ComponentAssemblies/@GenericParameters"];

                CyPhyElaborateCS.CyPhyElaborateCSInterpreter elaborator = new CyPhyElaborateCS.CyPhyElaborateCSInterpreter();
                elaborator.Initialize(asm.Project);
                int verbosity = 128;
                elaborator.RunInTransaction(asm.Project, (MgaFCO)asm, null, verbosity);

                var output = (IMgaFCO)asm.ObjectByPath["@ComponentWithGeneric/@GenericDomainModel/@GenericDomainModelParameter1"];
                Assert.Equal("1 2 3", output.StrAttrByName["Value"]);
                output = (IMgaFCO)asm.ObjectByPath["@ComponentWithGeneric/@GenericDomainModel/@GenericDomainModelParameter2"];
                Assert.Equal("123", output.StrAttrByName["Value"]);
            });
        }
    }
}

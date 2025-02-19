rem Unregisters all CyPhyML interpreters, then registers CyPhyML.mta and all interpreters
rem  Useful for removing old interpreters that don't exist in git anymore, or switching trees

: META_PATH=C:\Users\kevin\Documents\meta-tonka\
Setlocal EnableDelayedExpansion
bin\Python27\Scripts\Python.exe -c "reg = __import__('win32com.client').client.DispatchEx('Mga.MgaRegistrar'); [reg.UnregisterComponent(progid, 2) for progid in reg.GetAssociatedComponentsDisp('CyPhyML', 7, 2)]" || exit /b !ERRORLEVEL!
bin\Python27\Scripts\Python.exe -c "reg = __import__('win32com.client').client.DispatchEx('Mga.MgaRegistrar'); [reg.UnregisterComponent(progid, 1) for progid in reg.GetAssociatedComponentsDisp('CyPhyML', 7, 1)]" || exit /b !ERRORLEVEL!
bin\Python27\Scripts\Python.exe -c "import sys; import os.path; filename=r'generated\CyPhyML\models\CyPhyML.mta'; not os.path.isfile(filename) and sys.exit(0); reg = __import__('win32com.client').client.DispatchEx('Mga.MgaRegistrar'); reg.RegisterParadigmFromDataDisp('MGA=' + os.path.abspath(filename), 1)" || exit /b !ERRORLEVEL!
%windir%\SysWOW64\reg add HKLM\Software\META /v META_PATH /t REG_SZ /d "%~dp0\" /f || exit /b !ERRORLEVEL!
rem TODO: register more Decorators?
rem not being built:
rem meta/MaterialLibImporter
rem src/CyPhyMasterInterpreterChecker
set PATH=C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.2 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6 Tools;c:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v8.0A\bin\NETFX 4.0 Tools
@rem need to uninstall, as the version isn't bumped for every change
gacutil.exe /nologo /u JobManagerLib
if exist "src\JobManager\JobManagerLib\bin\Release\JobManagerLib.dll" gacutil.exe /nologo /i "src\JobManager\JobManagerLib\bin\Release\JobManagerLib.dll"  || exit /b !ERRORLEVEL!
gacutil.exe /l JobManagerLib
if exist "src\DesignConsistencyChecker\bin\Release\DesignConsistencyChecker.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\DesignConsistencyChecker\bin\Release\DesignConsistencyChecker.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyComponentFidelitySelector\bin\Release\CyPhyComponentFidelitySelector.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyComponentFidelitySelector\bin\Release\CyPhyComponentFidelitySelector.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyGUIs\bin\Release\CyPhyGUIs.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase /tlb "src\CyPhyGUIs\bin\Release\CyPhyGUIs.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CPMDecorator.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CPMDecorator.dll" || exit /b !ERRORLEVEL!
if exist "src\WorkflowDecorator\bin\Release\WorkflowDecorator.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\WorkflowDecorator\bin\Release\WorkflowDecorator.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyAddOn.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyAddOn.dll" || exit /b !ERRORLEVEL!
if exist "src\ComponentLibraryManagerAddOn\bin\Release\ComponentLibraryManagerAddOn.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\ComponentLibraryManagerAddOn\bin\Release\ComponentLibraryManagerAddOn.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyDecoratorAddon\bin\Release\CyPhyDecoratorAddon.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyDecoratorAddon\bin\Release\CyPhyDecoratorAddon.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyMdaoAddOn\bin\Release\CyPhyMdaoAddOn.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyMdaoAddOn\bin\Release\CyPhyMdaoAddOn.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyMetaLink\bin\Release\CyPhyMetaLink.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyMetaLink\bin\Release\CyPhyMetaLink.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhySignalBlocksAddOn\bin\Release\CyPhySignalBlocksAddOn.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhySignalBlocksAddOn\bin\Release\CyPhySignalBlocksAddOn.dll" || exit /b !ERRORLEVEL!
if exist "src\AddConnector\bin\Release\AddConnector.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\AddConnector\bin\Release\AddConnector.dll" || exit /b !ERRORLEVEL!
if exist "src\CLM_light\bin\Release\CLM_light.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CLM_light\bin\Release\CLM_light.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2CAD_CSharp\bin\Release\CyPhy2CAD_CSharp.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2CAD_CSharp\bin\Release\CyPhy2CAD_CSharp.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2CADPCB\bin\Release\CyPhy2CADPCB.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2CADPCB\bin\Release\CyPhy2CADPCB.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2MfgBom\bin\Release\CyPhy2MfgBom.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2MfgBom\bin\Release\CyPhy2MfgBom.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2Modelica_v2\bin\Release\CyPhy2Modelica_v2.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2Modelica_v2\bin\Release\CyPhy2Modelica_v2.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2PCBMfg\bin\Release\CyPhy2PCBMfg.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2PCBMfg\bin\Release\CyPhy2PCBMfg.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2RF\CyPhy2RF\bin\Release\CyPhy2RF.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2RF\CyPhy2RF\bin\Release\CyPhy2RF.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2Schematic\bin\Release\CyPhy2Schematic.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2Schematic\bin\Release\CyPhy2Schematic.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2SystemC\bin\Release\CyPhy2SystemC.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2SystemC\bin\Release\CyPhy2SystemC.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyCADAnalysis\bin\Release\CyPhyCADAnalysis.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyCADAnalysis\bin\Release\CyPhyCADAnalysis.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyCAExporter.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyCAExporter.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyComplexity\bin\Release\CyPhyComplexity.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyComplexity\bin\Release\CyPhyComplexity.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyComponentAuthoring\bin\Release\CyPhyComponentAuthoring.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyComponentAuthoring\bin\Release\CyPhyComponentAuthoring.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyComponentExporter\bin\Release\CyPhyComponentExporter.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyComponentExporter\bin\Release\CyPhyComponentExporter.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyComponentImporter\bin\Release\CyPhyComponentImporter.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyComponentImporter\bin\Release\CyPhyComponentImporter.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyComponentParameterEditor\bin\Release\CyPhyComponentParameterEditor.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyComponentParameterEditor\bin\Release\CyPhyComponentParameterEditor.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyCriticalityMeter.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyCriticalityMeter.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyDesignExporter\bin\Release\CyPhyDesignExporter.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyDesignExporter\bin\Release\CyPhyDesignExporter.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyDesignImporter\bin\Release\CyPhyDesignImporter.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyDesignImporter\bin\Release\CyPhyDesignImporter.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyDesignSpaceRefactor.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyDesignSpaceRefactor.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyDSRefiner.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyDSRefiner.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyElaborate.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyElaborate.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyElaborateCS\bin\Release\CyPhyElaborateCS.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyElaborateCS\bin\Release\CyPhyElaborateCS.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\CyPhyFormulaEvaluator.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\CyPhyFormulaEvaluator.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyMasterInterpreter\bin\Release\CyPhyMasterInterpreter.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyMasterInterpreter\bin\Release\CyPhyMasterInterpreter.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyMetaLink\bin\Release\CyPhyMetaLink.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyMetaLink\bin\Release\CyPhyMetaLink.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyMultiJobRun\bin\Release\CyPhyMultiJobRun.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyMultiJobRun\bin\Release\CyPhyMultiJobRun.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyPET\bin\Release\CyPhyPET.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyPET\bin\Release\CyPhyPET.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyPrepareIFab\bin\Release\CyPhyPrepareIFab.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyPrepareIFab\bin\Release\CyPhyPrepareIFab.dll" || exit /b !ERRORLEVEL!
if exist "src\Release\CyPhyPython.dll" %windir%\SysWOW64\regsvr32 /s "src\Release\CyPhyPython.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhyReliabilityAnalysis\bin\Release\CyPhyReliabilityAnalysis.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyReliabilityAnalysis\bin\Release\CyPhyReliabilityAnalysis.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhySoT\bin\Release\CyPhySoT.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhySoT\bin\Release\CyPhySoT.dll" || exit /b !ERRORLEVEL!
if exist "src\bin\DesignSpaceHelper.dll" %windir%\SysWOW64\regsvr32 /s "src\bin\DesignSpaceHelper.dll" || exit /b !ERRORLEVEL!
if exist "src\ModelicaImporter\bin\Release\ModelicaImporter.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\ModelicaImporter\bin\Release\ModelicaImporter.dll" || exit /b !ERRORLEVEL!
if exist "src\Run_PRISMATIC_toolchain\bin\Release\Run_PRISMATIC_toolchain.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\Run_PRISMATIC_toolchain\bin\Release\Run_PRISMATIC_toolchain.dll" || exit /b !ERRORLEVEL!
if exist "src\SubTreeMerge\bin\Release\SubTreeMerge.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\SubTreeMerge\bin\Release\SubTreeMerge.dll" || exit /b !ERRORLEVEL!
if exist "src\ShowNet\bin\Release\ShowNet.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\ShowNet\bin\Release\ShowNet.dll" || exit /b !ERRORLEVEL!
if exist "src\AcmEditor\bin\Release\AcmEditor.exe" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\AcmEditor\bin\Release\AcmEditor.exe" || exit /b !ERRORLEVEL!
if exist "src\CyPhyResultsViewer\bin\Release\CyPhyResultsViewer.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhyResultsViewer\bin\Release\CyPhyResultsViewer.dll" || exit /b !ERRORLEVEL!
if exist "src\CyPhy2Simulink\bin\Release\CyPhy2Simulink.dll" %windir%\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /nologo /codebase "src\CyPhy2Simulink\bin\Release\CyPhy2Simulink.dll" || exit /b !ERRORLEVEL!

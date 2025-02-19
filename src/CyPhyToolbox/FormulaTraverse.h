#ifndef FORMULA_TRAVERSE_H
#define FORMULA_TRAVERSE_H

#include "Uml.h"
#include "UmlExt.h"
#include "UdmUtil.h"
#include "CyPhyML.h"

#include "UnitUtil.h"
#include <unordered_map>
#include "../CyPhyElaborate/CyPhyElaborateTraceability.h"
#include "UdmConsole.h"


/** \file
    \brief Definition of FormulaTraverse class used to traverse a model and calls functions in EvaluateFormula.h to evaluate formulas.
*/

using namespace std;


void Traverse(const Udm::Object &focusObject);
void Traverse(const std::set<Udm::Object> &selectedObjects);

void Cleanup(multimap<std::string, double*> &parameters);


  /** \brief New traversal class that is used currently.
  */
class NewTraverser 
{
public:
	NewTraverser() {
		// it is not possible to have both strValue and actualValue set from model elements
		circularConnectionSentinel.strValue = "circular reference detected";
		circularConnectionSentinel.actualValue = 99e5;
	}
	NewTraverser(std::string fileName)
		:m_fileName(fileName){}
	~NewTraverser() {}

public: // member variables
	string m_fileName;											///< This name is used to name the Graphviz file and gif that are produced when cycles are encountered
	vector<string> numericLeafNodes;
	IUnknownPtr traceability;
	std::string getLink(const Udm::Object& o) {
		CyPhyCOMInterfaces::IMgaTraceabilityPtr p;
		p = traceability;
		if (p) {
			_bstr_t original(UdmGme::UdmId2GmeId(o.uniqueId()).c_str());
			_bstr_t copy;
			if (p->TryGetMappedObject(original, copy.GetAddress()) == VARIANT_FALSE) {
				copy = original;
			}
			// FIXME escape o.name
			// FIXME fix copy encoding
			return "<a href=\"mga:" + std::string(static_cast<const char*>(copy)) + "\">" + UdmUtil::ExtractName(o) + "</a>";
		}
		return o.getPath2("/", false);
	}
	void throwOverspecified(const Udm::Object& o, const char* kind="ValueFlow") {
		string message = "FormulaEvaluator - " + getLink(o) + " has >1 incoming " + kind + " connections";
		GMEConsole::Console::writeLine(message, MSG_ERROR);
		throw udm_exception(message);
	}

public: // member fcn
	void Traverse(const Udm::Object &udmObject);

	void FindRootNodes(const CyPhyML::Component &, set<CyPhyML::ValueFlowTarget> &);
	void FindRootNodes(const CyPhyML::TestComponent &, set<CyPhyML::ValueFlowTarget> &);
	void FindRootNodes(const CyPhyML::ComponentAssembly &, set<CyPhyML::ValueFlowTarget> &);
	void FindRootNodes(const CyPhyML::TestBenchType &, set<CyPhyML::ValueFlowTarget> &);
	void FindLeafNodes(const set<CyPhyML::ValueFlowTarget> &, set<CyPhyML::ValueFlowTarget> &);
	void FindLeafNodes(const CyPhyML::ValueFlowTarget &, set<CyPhyML::ValueFlowTarget> &);
	void FindLeafNodes(const CyPhyML::TestBenchType&, set<CyPhyML::ValueFlowTarget> &);				// TODO: 12/20/11 Test Injection Point stuff
	bool IsLeafNode(const CyPhyML::ValueFlowTarget &);											// TODO: 12/20/11 Test Injection Point stuff
	bool IsRootNode(const CyPhyML::ValueFlowTarget &);
	bool CheckValueFormula(const CyPhyML::ValueFormula &);
	bool IsNamedElementStandAlone(const CyPhyML::ValueFlowTarget &);

	void NamedElements2Process(CyPhyML::ValueFlowTarget&);

	void EvaluateLeafNodes(set<CyPhyML::ValueFlowTarget> &leafNodes);

	// stuff for outputting graph viz files	
	void PrintUnProcessedNamedElements();
	void PrintUnProcessedNamedElements(const CyPhyML::ValueFlowTarget&, set<long>&, map<long, string>&, vector<string>&);
	void PrintGraphOfCycles(map<long, string>&, vector<string>&);	

protected:
	void UpdateNamedElementValue(CyPhyML::ValueFlowTarget &, CyPhyML::ValueFlowTarget &, double);
	void UpdateNamedElementValue(CyPhyML::ValueFlowTarget &vfTarget, double value);
	void UpdateNamedElementValue(CyPhyML::ValueFlowTarget &vfTarget, CyPhyML::unit&, double value);
	void UpdateNamedElementValue(CyPhyML::ValueFlowTarget &vfTarget, CyPhyML::unit&, std::string valueStr);


	set<CyPhyML::ValueFlowTarget> m_allNamedElements2Process;	///< List of all ValueFlowTargets in the model that have not been evaluated
	string m_outPath;											///< Output path of gv and gif files
	map<long, double> m_calculatedValueFlowTargets;		///< Map of all ValueFlowTargets and their calculated value with their GME ID as the key
	map<long, int> m_visitedNodes;						///< Keeps track of ValueFlowTargets (only Parameter, CADParameter, CyberParameter, Property, and Metric) and their state (done visiting, unvisited, currently visiting) to find cycles
	set<CyPhyML::ValueFlowTarget> m_rootNodes;			///< List of VF rootNodes
	Udm::Object m_BoundingBox;
	UnitUtil unitUtil;

	UnitUtil::ValueUnitRep circularConnectionSentinel;

	set<CyPhyML::ValueFlowTarget> leafNodes;

protected:
	// Provide a version of this function that uses a cache, and speed up this slow function a bit
	enum idfCacheValue {
		NOT_IN_CACHE = 0,
		NO,
		YES
	};
	map<std::pair<Uml::Class,Uml::Class>,idfCacheValue> idfCache;
	bool IsDerivedFrom(const Uml::Class &derived, const Uml::Class &base) {
		std::pair<Uml::Class,Uml::Class> toCompare(derived,base);
		idfCacheValue icv = idfCache[toCompare];
		switch (icv) {
			case YES:
				return true;
				break;
			case NO:
				return false;
				break;
			default:
				bool result = Uml::IsDerivedFrom(derived,base);
				if (result) {
					idfCache[toCompare] = YES;
					return true;
				} else {
					idfCache[toCompare] = NO;
					return false;
				}
				break;
		}
		return false;
	}


// new stuff - check for unit compatibility
protected:
	unordered_map<long, UnitUtil::ValueUnitRep> m_convertedValueFlowTargets_SIMap;


	bool EvaluatePPC(CyPhyML::ValueFlowTarget &, UnitUtil::ValueUnitRep &);
	bool EvaluateFormula(CyPhyML::ValueFormula &, UnitUtil::ValueUnitRep &);

	void PrintNodes(set<CyPhyML::ValueFlowTarget>& leafNodes, string type);


	// 7-3-2012: CADParameter inside CADModel instead of Component
	set<CyPhyML::CarParameter> m_carParameters;
	set<CyPhyML::CADParameter> m_cadParameters;
	set<CyPhyML::ManufacturingModelParameter> m_manufactureParameters;
	set<CyPhyML::ModelicaParameter> m_modelicaParameters; 	// ZL 11/20/2013 support modelica parameters as value flow targets
	set<CyPhyML::EDAModelParameter> m_edaModelParameters;
	set<CyPhyML::SPICEModelParameter> m_spiceModelParameters;
	set<CyPhyML::SystemCParameter> m_systemcParameters;
	set<CyPhyML::GenericDomainModelParameter> m_genericDomainModelParameters;
	set<CyPhyML::Units> m_units_folders;
	unordered_map<string, CyPhyML::unit> m_unit_name_table;
	void EvaluateCADParameters();
	void EvaluateManufactureParameters();
	void EvaluateEDAParameters();
	void EvaluateSPICEParameters();
	void EvaluateSystemCParameters();
	void EvaluateGenericDomainModelParameters();
	void EvaluateCarParameters();

	std::string NonRealValueFixture( CyPhyML::ValueFlowTarget &vft, std::string &value );

	void EvaluateModelicaParameters();					// ZL 11/20/2013 support modelica parameters as value flow targets
	CyPhyML::unit FindUnitByName(string);				// 11-29-2012: Added lookup of CyPhyML::Unit by string
	CyPhyML::RootFolder FindTopRootFolder(const Udm::Object &);
	void FindUnitsFolders(const Udm::Object &);
	void FindUnitsFolders(const CyPhyML::RootFolder &);


	// 8-30-2012: PostProcessing generation for Jason
	//string output_dir_;
	//void GeneratePostProcessingScripts(CyPhyML::TestBench &);

	// 2-20-2013: Test Bench Suite
	void EvaluateTestBenchSuite(CyPhyML::TestBenchSuite &);
	string GetVftUnitAndValue(const CyPhyML::ValueFlowTarget&, UnitUtil::ValueUnitRep&);
};


#endif
// UdmApp.h: interface for the CUdmApp class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_UDMAPP_H__296A93EB_6DB6_4179_AA0B_A3D799FB3A1C__INCLUDED_)
#define AFX_UDMAPP_H__296A93EB_6DB6_4179_AA0B_A3D799FB3A1C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// Udm includes
#include "UdmBase.h"
#include "Uml.h"
#include "UmlExt.h"

#ifdef _USE_DOM
	#include "UdmDOM.h"
#endif

#include "UdmGme.h"
#include "UdmStatic.h"
#include "GMECOM.h"

#include "Mga.h"

class CUdmApp  
{
public:
	int Initialize();
	void UdmMain(Udm::DataNetwork* p_backend,Udm::Object currentObject, set<Udm::Object> selectedObjects, long param, CComPtr<IMgaProject> mgaProject);
	CString mgaPath;
#ifdef _DEBUG
	static string ExtractName(Udm::Object ob);
#endif
	CComPtr<IUnknown> traceability;
};

#endif // !defined(AFX_UDMAPP_H__296A93EB_6DB6_4179_AA0B_A3D799FB3A1C__INCLUDED_)

// stdafx.h : include file for standard system include files,
//      or project specific include files that are used frequently,
//      but are changed infrequently

#if !defined(AFX_STDAFX_H__C4EFDDFC_C095_4509_B571_632F0986D162__INCLUDED_)
#define AFX_STDAFX_H__C4EFDDFC_C095_4509_B571_632F0986D162__INCLUDED_

#pragma once

#define TEST_META_CONFORMANCE_INSIDE_BON // by ZolMol

#ifndef VC_EXTRALEAN
#define VC_EXTRALEAN            // Exclude rarely-used stuff from Windows headers
#endif

#include "targetver.h"

#define _ATL_APARTMENT_THREADED

#include <afxwin.h>
#include <afxdisp.h>

#include <atlbase.h>
//You may derive a class from CComModule and use it if you want to override
//something, but do not change the name of _Module
extern CComModule _Module;
#include <atlcom.h>

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#include <string>
#include <vector>
#include <map>
#include <UdmBase.h>
#include <Uml.h>
#include <UmlExt.h>
#include "CyPhyML.h"

#define GME_COMPONENT_ISUPPORTERRORINFO 1

#endif // !defined(AFX_STDAFX_H__C4EFDDFC_C095_4509_B571_632F0986D162__INCLUDED)

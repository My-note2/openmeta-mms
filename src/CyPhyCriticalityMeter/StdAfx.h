// stdafx.h : include file for standard system include files,
//      or project specific include files that are used frequently,
//      but are changed infrequently

#if !defined(AFX_STDAFX_H__C4EFDDFC_C095_4509_B571_632F0986D162__INCLUDED_)
#define AFX_STDAFX_H__C4EFDDFC_C095_4509_B571_632F0986D162__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define STRICT
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0501
#endif

#ifndef _WIN32_IE
#define _WIN32_IE 0x0401
#endif
#define _ATL_APARTMENT_THREADED

#include <afxwin.h>
#include <afxdisp.h>

#include <atlbase.h>
//You may derive a class from CComModule and use it if you want to override
//something, but do not change the name of _Module
extern CComModule _Module;
#include <atlcom.h>
#include <afxdhtml.h>
#include <afxcontrolbars.h>

#pragma warning( disable : 4666)

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#include <string>
#include <vector>
#include <map>
#include <UdmBase.h>
#include <Uml.h>
#include <UmlExt.h>

#endif // !defined(AFX_STDAFX_H__C4EFDDFC_C095_4509_B571_632F0986D162__INCLUDED)

Third-party software used by OpenMETA
=====================================

`3rdParty` directory
------------------

Primarily tools used at build/development time

  * `antlr` - [ANTLR](http://www.antlr.org/) - BSD License
  * `apache-maven-3.0.5` - [Apache Maven](https://maven.apache.org/) - Apache License, Version 2.0
  * `cloc` - [Count Lines of Code](http://cloc.sourceforge.net/) - GPLv2
  * `cppcheck` - [Cppcheck](http://cppcheck.sourceforge.net/) - GPLv3
  * `cppunit-1.13.2` - [CppUnit](https://sourceforge.net/projects/cppunit/) - LGPLv2.1
  * `dot_bin` - [Graphviz](http://www.graphviz.org/) - Eclipse Public License, v 1.0
  * `doxygen` - [Doxygen](http://www.stack.nl/~dimitri/doxygen/) - GPLv2
  * `Ionic.Zip` - [Ionic.Zip](https://dotnetzip.codeplex.com/) - Microsoft Public License
  * `json_spirit` - [JSON Spirit](https://www.codeproject.com/Articles/20027/JSON-Spirit-A-C-JSON-Parser-Generator-Implemented) - MIT License
  * `Json.NET` - [Json.NET](https://www.newtonsoft.com/json) - MIT License
  * `libcmdline` - [Command Line Parser Library](https://commandline.codeplex.com/) - MIT License
  * `MetaGME2Doc` - *Unknown*
  * `muparser` - [muParser][muparser] - MIT License
  * `protobuf_net_r640` - [Protocol Buffers for .NET][Protobuf.NET] - Apache License, Version 2.0
  * `protoc-2.6.1-win32` - [Protocol Buffers compiler][Protobuf] - BSD License
  * `restsharp` - [RestSharp](http://restsharp.org/) - Apache License, Version 2.0
  * `System.Data.SQLite` - [System.Data.SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki)
      * `System.Data.SQLite.dll` is public domain
      * `System.Data.SQLite.Linq.dll` is Microsoft Public License
  * `xsd2code` - [Xsd2Code community edition](https://xsd2code.codeplex.com/) - MIT License
  * `xunit-1.9.1` - [xUnit.net](https://xunit.github.io/) - Apache License 2.0
  * `Microsoft.Office.Interop.Excel.dll`, `Office.dll` - Office Primary Interop Assemblies

`bin` directory
---------------

Runtimes and tools shipped with OpenMETA

  * `cad.js` - [cad.js](https://github.com/ghemingway/cad.js) - MIT License
  * `Python27` - [CPython](https://www.python.org/) - Python Software Foundation License
  * `spice` - [ngspice](http://ngspice.sourceforge.net/) - BSD License
  * `udm.pyd` - [Unified Data Model (UDM) Python module][UDM] - Vanderbilt University End User License Agreement
  * `UdmCopy.exe` - [Unified Data Model (UDM)][UDM] - Vanderbilt University End User License Agreement

`deploy` directory
------------------

Installer source files, plus merge modules and other resources for some dependencies

  * `xerces_c/`, `xerces_c.msm`, `xerces-c_2_8*.dll` - [Apache Xerces](http://xerces.apache.org/) - Apache License, Version 2.0
  * `Microsoft_VC*_CRT_*.msm`, `policy_9_0_Microsoft_VC90_CRT_x86` - Visual C++ Runtime Merge Modules
  * `UdmDll_*.wixlib` - [Unified Data Model (UDM)][UDM] - Vanderbilt University End User License Agreement

[UDM]: http://www.isis.vanderbilt.edu/tools/UDM

`externals` directory
---------------------

  * `DecoratorLib`
  * `desert` - [DESERT](http://repo.isis.vanderbilt.edu/) - MIT License
  * `HCDDES`
  
`meta\DesignDataPackage\tools` directory
---------------
  * `jaxb-ri-2.2.6` - [Java Architecture for XML Binding](https://www.oracle.com/technical-resources/articles/javase/jaxb.html) CDDL 1.1

NuGet dependencies
------------------

  * `boost` - [Boost C++ Libraries](http://www.boost.org/) - Boost Software License
  * `CsvHelper` - [CSVHelper](https://joshclose.github.io/CsvHelper/) - Microsoft Public License *or* Apache License, Version 2.0
  * `gecode` - [Gecode](http://www.gecode.org/) - MIT License
  * `Google.Protobuf` - [C# runtime library for Protocol Buffers][Protobuf] - BSD License
  * `Grpc`, `Grpc.Core`, `Grpc.Core.Api`, `Grpc.Tools` - [Grpc](https://grpc.io/) - Apache License, Version 2.0
  * `jsoncpp` - [JsonCpp](https://github.com/open-source-parsers/jsoncpp) - Public Domain *or* MIT License
  * `log4cpp` - [Log for C++](http://log4cpp.sourceforge.net/) - LGPLv2.1+
  * `muparser` - [muParser][muparser] - MIT License
  * `Ookii.Dialogs` - [Ookii.Dialogs](http://www.ookii.org/software/dialogs/) - BSD License
  * `protobuf` - [Protocol Buffers][Protobuf] - BSD License
  * `protobuf-net` - [Protocol Buffers for .NET][Protobuf.NET] - Apache License, Version 2.0
  * `protobuf-vc110` - [Protocol Buffers][Protobuf] - BSD License
  * `Selenium.Support`, `Selenium.WebDriver`, `Selenium.WebDriver.ChromeDriver` - [Selenium](http://www.seleniumhq.org/) - Apache License, Version 2.0
  * `System.Buffers` - [System.Buffers](https://www.nuget.org/packages/System.Buffers/) - MIT License
  * `System.Memory` - [System.Memory](https://www.nuget.org/packages/System.Memory/) - MIT License
  * `System.Runtime.CompilerServices.Unsafe` - [System.Runtime.CompilerServices.Unsafe](https://www.nuget.org/packages/System.Runtime.CompilerServices.Unsafe/) - MIT License

[muparser]: http://beltoforion.de/article.php?a=muparser
[Protobuf]: https://developers.google.com/protocol-buffers/
[Protobuf.NET]: https://github.com/mgravell/protobuf-net

Bundled Python packages
-----------------------

* `_markerlib` - [Markerlib](https://bitbucket.org/dholth/markerlib/) - MIT License
* `adodbapi` - [adodbapi](http://sourceforge.net/projects/adodbapi) - LGPLv2.1
* `alabaster` - [Alabaster Sphinx theme](https://alabaster.readthedocs.io/) - BSD License
* `babel` - [Babel](http://babel.pocoo.org/) - BSD License
* `backports`, `backports.functools_lru_cache` - [backports.functools_lru_cache](https://github.com/jaraco/backports.functools_lru_cache) - MIT license
* `BeautifulSoup.py`, `BeautifulSoupTests.py` - [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/) - MIT License
* `Cheetah` - [Cheetah Template](http://cheetahtemplate.org/) - BSD-like license
* `colorama` - [Colorama](https://github.com/tartley/colorama) - BSD License
* `concurrent.futures` - [futures](https://github.com/agronholm/pythonfutures) - Python Software Foundation License
* `cycler.py` - [Cycler](https://github.com/matplotlib/cycler) - BSD License
* `dateutil` - [python-dateutil](https://dateutil.readthedocs.io/en/stable/) - BSD License
* `decorator.py` - [decorator](https://github.com/micheles/decorator) - BSD License
* `docutils` - [docutils - Python Documentation Utilities](http://docutils.sourceforge.net/) - Mostly public domain, with some components licensed under BSD License or GPLv3
* `elementtree-1.2.7_20070827_preview-py2.7-win32.egg` - [ElementTree](http://effbot.org/zone/element-index.htm) - Python License (MIT-style)
* `enum` - [enum34](https://bitbucket.org/stoneleaf/enum34/src/default/) - BSD License
* `euclid.py` - [Euclid](https://code.google.com/archive/p/pyeuclid/) - LGPLv2.1+
* `excel_wrapper` - [OpenMDAO Excel Wrapper](https://github.com/metamorph-inc/excel_wrapper) - GPLv2
* `google.protobuf` - [Google Protocol Buffers](https://developers.google.com/protocol-buffers/) - BSD License
* `grpc` - [Grpc](https://grpc.io/) - Apache License, Version 2.0
* `imagesize` - [imagesize](https://github.com/shibukawa/imagesize_py) - MIT License
* `isodate` - [isodate](https://github.com/gweis/isodate/) - BSD License
* `jinja2` - [Jinja](http://jinja.pocoo.org/) - BSD License
* `lazy_object_proxy` - [lazy_object_proxy](https://github.com/ionelmc/python-lazy-object-proxy) - BSD license
* `logilab` - [logilab-common](https://www.logilab.org/project/logilab-common) - LGPLv2.1
* `lxml` - [lxml](http://lxml.de/) - BSD License
* `markdown` - [Python-Markdown](https://pythonhosted.org/Markdown/) - BSD License
* `markupsafe` - [MarkupSafe](https://github.com/pallets/markupsafe) - BSD License
* `matlab_proxy`, `matlab_wrapper` - [MATLAB OpenMDAO Component](https://github.com/metamorph-inc/matlab_wrapper) - MIT License
* `matplotlib`, `mpl_toolkits`, `pylab.py` - [Matplotlib](http://matplotlib.org/) - [Matplotlib license](https://github.com/matplotlib/matplotlib/blob/master/LICENSE/LICENSE)
* `mgardf` - [mgardf](https://github.com/metamorph-inc/mgardf) - MIT License
* `mpmath` - [mpmath](http://mpmath.org/) - BSD License
* `networkx` - [NetworkX](http://networkx.github.io/) - BSD License
* `nose` - [Nose](https://nose.readthedocs.io/en/latest/) - LGPL
* `numexpr` - [NumExpr](https://github.com/pydata/numexpr) - MIT License
* `numpy`, `numpydoc` - [NumPy](http://www.numpy.org/) - BSD License
* `omniORB` - [omniORB](http://www.omniorb.net) - LGPL2.1 or later + explicit Python link permission
* `OMPython`, `OMPythonIDL` - [OpenModelica-Python API Interface](https://github.com/OpenModelica/OMPython) - BSD, OSMC-PL 1.2, GPL (user's choice)
* `openmdao` - [OpenMDAO](http://openmdao.org/) - Apache License, Version 2.0
* `pip` - [pip](https://pip.pypa.io/en/stable/) - MIT License
* `pygame` - [PyGame](http://www.pygame.org/news) - LGPLv2.1
* `pygments` - [Pygments](http://pygments.org/) - BSD License
* `pyparsing.py` - [Pyparsing](http://pyparsing.wikispaces.com/) - MIT License
* `PyQt4`, `sip.pyd` - [PyQt4](https://riverbankcomputing.com/software/pyqt/intro) - GPLv3
* `pyqtgraph` [PyQtGraph](http://www.pyqtgraph.org/) - MIT License
* `pytz` [pytz](http://pythonhosted.org/pytz/) - MIT License
* `pywin32-219-py2.7-win32.egg`, `pywin32-220-py2.7-win32.egg`, `isapi`, `win32`, `win32com`, `win32context` - [Python for Windows Extensions](https://sourceforge.net/projects/pywin32/) - Python Software Foundation License
* `pyxb` - [PyXB](http://pyxb.sourceforge.net/) - Apache License, Version 2.0
* `rdflib` - [RDFLib](https://github.com/RDFLib/rdflib) - BSD License
* `requests` - [Requests](http://python-requests.org/) - Apache License, Version 2.0
* `scipy` - [SciPy](https://www.scipy.org/) - BSD License
* `setuptools`, `easy_install.py`, `pkg_resources` - [Setuptools](https://github.com/pypa/setuptools) - MIT license
* `six.py` - [Six](https://pypi.python.org/pypi/six/) - MIT License
* `smop` - [SMOP](https://github.com/metamorph-inc/smop) - MIT License
* `snowballstemmer` - [Snowball stemming library collection for Python](https://github.com/shibukawa/snowball_py) - BSD License
* `solid` - [solid](https://github.com/haaksmash/solid) - LGPLv3+
* `sphinx`, `sphinxcontrib` - [Sphinx](http://sphinx-doc.org/) - BSD License
* `sphinx_rtd_theme` - [Read the Docs Sphinx Theme](https://github.com/rtfd/sphinx_rtd_theme/) - MIT License
* `sqlitedict.py` - [sqlitedict](https://github.com/RaRe-Technologies/sqlitedict) - Apache License, Version 2.0
* `svgwrite` - [svgwrite](https://github.com/mozman/svgwrite) - MIT License
* `sympy` - [SymPy](http://www.sympy.org/en/index.html) - BSD License
* `tables` - [PyTables](http://www.pytables.org/) - BSD License
* `typing.py` - [Typing - Type Hints for Python](https://pypi.python.org/pypi/typing/3.6.2) - Python Software Foundation License
* `vitables` - [ViTables](http://vitables.org/) - GPLv3
* `wheel` - [Wheel](https://github.com/pypa/wheel) - MIT License
* `wrapt` - [wrapt](https://github.com/GrahamDumpleton/wrapt) - BSD License

![CaSSiuS](res/logo.png?raw=true)
CaSSius is a tool to create beautiful paginated PDF documents from NLM/JATS. Under the hood, v0.2 of CaSSius uses the pagination polyfill from [pagedjs](https://gitlab.pagedmedia.org/tools/pagedjs). It is intended to be part of [XML-first/XML-in workflows](https://www.martineve.com/2015/07/20/building-a-real-xml-first-workflow-for-scholarly-typesetting/) for scholarly communications but may have alternative uses.

CaSSius: heavyweight typesetting with lightweight technology.

# Usage and Quick Start Guide
    Usage:
        cassius.py <in-file> <out-file> [options]
        cassius.py (-h | --help)
        cassius.py --version
        cassius.py --debug


CaSSius takes NLM/JATS XML and produces a PDF file from the results. To begin using CaSSius on a Linux system, follow these steps:

1. Ensure that you have all of the requirements in requirements.txt installed and are using Python 3.
2. Install Google Chrome in order to generate the PDF.
3. Install the GNU "screen" utility.
4. Run src/cassius.py specifying the input XML and the desired output PDF file.

# Troubleshooting
If something isn't working, please try with the --debug option. Furthermore, please verify the JATS structure against the provided samples.

# Samples
Various sample XML files can be found in the ["samples" directory](samples/).

# Headless Printing
CaSSius creates PDF files by headless printing of documents in Google Chrome.

# Components and Licensing
CaSSius is copyright Martin Paul Eve 2020. It is released under the terms specified in [LICENSE](LICENSE).

CaSSius makes use of several other open-source/free-software projects, including:

* [paged.js](https://gitlab.pagedmedia.org/tools/pagedjs). Copyright (c) 2018 Adam Hyde under the [MIT license](https://gitlab.pagedmedia.org/tools/pagedjs/blob/master/LICENSE.md).
* [jQuery](https://jquery.org). Under [the MIT license](https://jquery.org/license/).
* [docopt](https://github.com/docopt). Copyright (c) 2012 Vladimir Keleshev, <vladimir@keleshev.com> with an [MIT license](https://github.com/docopt/docopt/blob/master/LICENSE-MIT).
* The Open Library of Humanities logo, distributed with samples, is (c) and a trademark of the Open Library of Humanities. No re-use rights of this logo beyond distribution with the samples are bestowed by the above license.  
* The CaSSius logo is a derivative of a work by [Lil Squid from the Noun Project](https://thenounproject.com/search/?q=type&i=150037), licensed under the Creative Commons Attribution License.
* Parts of the cassius library contain materials from the National Library of Medicine, specifically [adaptations of their XSLT suite and entity resolution files, which are public domain](http://dtd.nlm.nih.gov/tools/tools.html).


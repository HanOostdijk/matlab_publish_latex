## matlab_publish_latex
`publish_mpl` is an extension of the MATLAB `publish` function with extra possibilities for latex.
Motivation for creating this new function is that I want more control than the pdf and html format of `publish` can offer. 
So LaTeX is the obvious choice but at the same time I want to avoid manual editing of the tex file as much as possible. 
By using an adapted xsl file, the package matlab-prettifier created by Julien Cretel 
and additional `publish` options we can achieve the following:
 * specify the documentclass and layout of the document 
 * show MATLAB code (and also listings of mfiles) in a nice layout
 * specify hyperref options that determine the pdf attributes
 * specify how the header of the document is presented (titel, author, contents, list of figures and listings)
 * include captions and references

For converting the tex-file to a pdf-file I use TeXworks (a component of MiKTeX).

### Examples
See publish_mpl_examples in the example folder for examples of use.

### Workings
As usual the options for `publish` are specified in a structure. 
Additional options of `publish` are used to make changes to a base xsl file (publish_mpl.xsl).
The standard `publish` function is then called with the modified xsl file.

References and captions to plots are supported.  
A plot of a script `xxx` will get a label `xxx-0n.eps` if it is the n-th plot. In a latex block you can then refer to
the second plot with e.g. `figure \ref{xxx_02.eps} on page \pageref{xxx_02.eps}` .  
A plot will get as caption `captionX` with X = 'A' for the first, 'B' for the second plot and so on. 
The caption for the second plot can be set in such a latex block (before the plot is actually
done) by e.g.  
`\global\def\captionB{my caption for the second plot}`.
### Additional options:

| option        | description 	|
| ------------- |:--------------| 
|  newname              | for all formats, to rename the resulting file 
|  documentclass        | only for latex, default 'article'             
|  paper                | only for latex, default 'a4paper' 
|  sizes                | only for latex, default 'margin=1in'  
|  graph_width   		| only for latex, default '4in'   
|  orientation          | only for latex, default 'landscape' 
|  prettifier_options   | only for latex, default 'framed,numbered'
|  style                | only for latex, default 'Matlab-editor'
|  pdftitle             | only for latex, default ''
|  pdfauthor            | only for latex, default ''
|  pdfsubject           | only for latex, default ''
|  pdfkeywords          | only for latex, default ''	
|  pdfproducer          | only for latex, default ''	
|  pdfcreator           | only for latex, default '' 
|  title                | only for latex, default ''	
|  author               | only for latex, default '' 	
|  maketitle            | only for latex, default false 
|  maketableofcontents  | only for latex, default false		
|  makelistoflistings   | only for latex, default false	
|  makelistoffigures    | only for latex, default false	

### Acknowledgement
This code builds heavily on `mxdom2latex.xsl` by Ned Gulley and Matthew Simoneau, September 2003
 ( Copyright 1984-2013 The MathWorks, Inc. ). The fine MATLAB layout it produces is made possible
by the LaTeX package `matlab-prettifier` created by Julien Cretel. 

### Contents
The applications contains
 * publish_mpl.m (main function)
 * publish_mpl.xsl (stylesheet)
 * package matlab-prettifier (matlab-prettifier.sty will suffice)
 * publish_mpl_examples.m, exampleA.m and exampleB.m (example files) and their outputs in the html subfolder

### Future developments
No future developments are planned. However you could check [this repository]
(https://github.com/HanOostdijk/matlab_publish_latex.git) to see if something new has come up.

### License
This software is distributed under the MIT License (MIT): see copyright.txt
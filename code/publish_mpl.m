 
%% publish_mpl
% this an extension of the |publish| function with extra possibilities for latex.
% See publish_mpl_examples for usage examples.
%
% As usual the options for publish are specified in a structure. 
% Additional options of publish are used to make changes to a base xsl file (publish_mpl.xsl).
% The original publish function is then called with the modified xsl file.
%
% References and captions to plots are supported.  
% A plot of a script *xxx* will get a label *xxx-0n.eps* if it is the n-th plot. 
% In a latex block you can then refer to
% the second plot with e.g. *figure \ref{xxx_02.eps} on page \pageref{xxx_02.eps}* .
% A plot will get as caption *captionX* with X = 'A' for the first, 'B' for the second plot and so on.
% The caption for the second plot can be set in such a latex block (before the plot is actually
% done) by e.g. *\global\def\captionB{my caption for the second plot}* .
%
% Also available are the options *first_preamblex*, *last_preamblex*, *first_bodyx* and *last_bodyx* (with x 
% a sequence number 1,2, ... that indicate latex statements that are to inserted as first or last lines of
% the preamble or the fixed body part.  The sequence numbers must be consecutive: if the numbers 1, 2 and 3 are present
% and number 4 is missing the code will stop after handling number 3.
%
% The additional options are:
%%
% 
%  newname              : for all formats, to rename the resulting file
%  documentclass        : only for latex, default 'article'
%  paper                : only for latex, default 'a4paper' 
%  sizes                : only for latex, default 'margin=1in'   
%  graph_width          : only for latex, default '4in'   
%  orientation          : only for latex, default 'landscape' 
%  prettifier_options   : only for latex, default 'frame=single,numbers=left,basicstyle=\small\ttfamily'
%  listing_options      : only for latex, default ''
%  style                : only for latex, default 'Matlab-editor'
%  pdftitle             : only for latex, default ''
%  pdfauthor            : only for latex, default ''
%  pdfsubject           : only for latex, default ''
%  pdfkeywords          : only for latex, default ''	
%  pdfproducer          : only for latex, default ''	
%  pdfcreator           : only for latex, default '' 
%  title                : only for latex, default ''	
%  author               : only for latex, default '' 	
%  maketitle            : only for latex, default false 	
%  maketableofcontents  : only for latex, default false 	
%  makelistoflistings   : only for latex, default false	
%  makelistoffigures    : only for latex, default false	
%  first_preamblex      : only for latex, no default x = 1, 2, ... 
%  last_preamblex       : only for latex, no default x = 1, 2, ... 
%  first_bodyx          : only for latex, no default x = 1, 2, ...  
%  last_bodyx           : only for latex, no default x = 1, 2, ... 
% 
%% Acknowledgement
% This code builds heavily on mxdom2latex.xsl by Ned Gulley and Matthew Simoneau, September 2003
% (Copyright 1984-2013 The MathWorks, Inc. ). The fine MATLAB layout it produces is made possible
% by the LaTeX package matlab-prettifier created by Julien Cretel. 
%% Dependencies
% This function needs
% 
% * the stylesheet publish_mpl.xsl
% * package matlab-prettifier (matlab-prettifier.sty will suffice)
% 
%% Future developments
% No future developments are planned. However you could check 
% <https://github.com/HanOostdijk/matlab_publish_latex.git> to see if something new has come up.
function newname = publish_mpl(file,pstruct)
% set default parameter
defparms            = {                                 % specify default parameters
    'imageFormat' , 'jpg' ;   
    'format' , 'latex' ;
    'newname' , '' ; 
    'outputDir' , '.\html' ; 
    'stylesheet' , '' ; 
    'evalcode' , true ;
    } ;
pstruct             = setdefparms(pstruct, defparms) ; 	% merge with the ones specified
mycode              = char(pstruct.call)' ;          	% convert cell array to character array
% create the 'publish' structure
p1                  = struct ;                          % empty publish structure
p1.codeToEvaluate   = mycode(:)'  ;                     % convert to string (row vector)
p1.outputDir        = pstruct.outputDir ;            	% insert output directory
p1.evalCode         = pstruct.evalcode ;             	% insert evalcode indication
p1.format           = pstruct.format;                   % insert format e.g. word, pdf or latex
if strcmpi(p1.format,'latex')                           % shows the new handling of latex format    
    p1.stylesheet  	= 'publish_mpl_temp.xsl' ;       	% new temporary stylesheet to use
    construct_xsl('publish_mpl.xsl', ...               % construct temp file using publish_mpl.xsl and the
        p1.stylesheet, pstruct)                         % parameters (fields) in the structure
    p1.imageFormat  = 'epsc2';                          % image format to use
else
    p1.stylesheet  	= pstruct.stylesheet ;              % stylesheet to use
    p1.imageFormat 	= pstruct.imageFormat;              % image format
end
if strcmpi(p1.format,'pdf') && ...
      not(ismember(p1.imageFormat,{'bmp', 'jpg'}))
  p1.imageFormat    = 'jpg';                         	% image format to use
end
% execute the standard MATLAB 'publish' function
docfile           	= publish(file,p1) ;                % publish the file to indicated format and standard name
outdir            	= p1.outputDir ;                    % directory the file is created in
if strcmpi(pstruct.format,'latex')
    delete('publish_mpl_temp.xsl') ;                 	% delete the temporary xsl file just created
    sty_file=fullfile(outdir,'matlab-prettifier.sty');  % name of sty file in output directory
    if ~(exist(sty_file,'file') > 0)                    % if sty file in output directory does not exist
        dos(sprintf('copy "%s" "%s"', ...               % copy sty-file
            which('matlab-prettifier.sty'),sty_file)) ;
    end
end
newname                 = pstruct.newname ;             % newname to assign
if numel(newname) > 0                                   % if new name is specified
    [~, name1, ext1] = fileparts(docfile) ;             % name and extension published file (standard name)
    [~, name2, ext2] = fileparts(newname) ;         	% new name and extension
    if not(strcmp(name1,name2) && strcmp(ext1,ext2))  	% if new name == old name then no rename
        if exist(fullfile(outdir,newname) ,'file') > 0	% if file with newname already exists
            delete(fullfile(outdir,newname) ) ;         % then delete the existing file
        end        
        dos(sprintf('rename "%s" "%s"',docfile,newname))  ; 	% rename published file
    end
    newname = fullfile(outdir,newname) ;                % full name of renamed result file
else
    newname = docfile ;                                 % full name of standard result file
end

end
%% subfunction setdefparms
function parmstruct2 = setdefparms(parmstruct1, defparms)
% set parameters from cell array in structure if they are not already defined

%{
 example of use:
defparms  = {                                           % specify (all) default parameters
    'seed' , 1954 ;                                 		
    'insample' , 100 ;                              		
    } 
parmstruct = struct('seed', 12) ;                       % define a structure with only seed specified

parmstruct = setdefparms(parmstruct, defparms)          % merge 
parmstruct = setdefparms(struct(), defparms)            % copy in empty structure
%}

parmstruct2 = parmstruct1 ;                             % copy old to new structure
for i = 1:size(defparms,1)                           	% for all parameters specified here
    if not(isfield(parmstruct2,defparms{i,1}))         	% if not existing as a field in the structure
        parmstruct2.(defparms{i,1}) = defparms{i,2} ; 	% set the field with the indicated value
    end
end

end
%% subfunction construct_xsl
function construct_xsl(file_in, file_out, varpart)
% construct an xsl file by inserting variable part in existing file
%{
Warning this function is tailored explicitly for the publish_mpl.xsl 
if changes to the xsl file are made the variable 'xsl_lines' must
be checked/changed just as the 'insert_xsl' function.
If new options are introduced also 'use_defaults' should specify
defaults for these options
example of use:
mystruct = struct('orientation','portrait', ...
        'pdfauthor','Han Oostdijk Quantitative Consultancy (han@hanoostdijk.nl)') ;
construct_xsl('base.xsl', 'temp.xsl', mystruct)
%}

if nargin < 3
    varpart = struct ;     
else
    if not(isstruct(varpart))
        error('construct_xsl: 3th argument should be struct')
    end    
end
ds      = use_defaults(varpart) ;                       % overwrite default values
fin  	= fopen(file_in) ;                           	% open input file
fout  	= fopen(file_out,'wt') ;                       	% open output file
blocknr = 0 ;                                         	% number of insert block
tline = fgetl(fin);                                     % read first line of last block (without inserts)
while ischar(tline)                                     % if character then not yet end-of-file
    if (length(tline) > 10) && ...
            (strcmpi(tline(1:11),'insert_hoqc'))
        blocknr = blocknr + 1 ; 						% number of block to insert
        insert_xsl(fout,ds,blocknr) ; 					% insert lines of block
    else
        fprintf(fout,'%s\n',tline) ;                 	% and write it
    end
    tline = fgetl(fin);                                 % try to read next line
end

fclose(fin);                                            % close input file
fclose(fout);                                           % close output file
end

%% subfunction use_defaults
function ds= use_defaults(varpart)
% specify default values in fields of structure
ds = struct( ...                                        
    'documentclass', 'article', ...
    'paper', 'a4paper',  ...   
    'sizes', 'margin=1in', ...     
    'graph_width', '4in', ... 
    'orientation', 'landscape',  ...                 	% 'landscape' or 'portrait'
    'prettifier_options', 'framed,numbered', ...        % (un)framed, (un)numbered
    'listing_options', ...                              % options for listings in case that Matlab prettifier is not used
       'frame=single,numbers=left,basicstyle=\small\ttfamily', ... % (i.e. when style ='Matlab-noformat')
    'style', 'Matlab-editor',  ...                     	% 'Matlab-editor', 'Matlab-bw', 'Matlab-Pyglike', 'Matlab-noformat'
    'pdftitle', '',  ...                                % 	
    'pdfauthor', '',  ...                               % 	
    'pdfsubject', '',  ...                              % 	
    'pdfkeywords', '',  ...                             % 	
    'pdfproducer', '',  ...                             % 	
    'pdfcreator', '',   ...                            	% 
  	'title', '',  ...                                   % 	
    'author', '',   ...                              	% 	
  	'maketitle', false,   ...                       	% 	
    'maketableofcontents', false,   ...                 % 	
  	'makelistoflistings', false,   ...                  % 	
  	'makelistoffigures', false ...
    ) ;
deffields = fieldnames(ds)' ;                           % fields of default structure                    
for f1 = deffields                                      % for each of the fields
    f   = f1{1} ;                                       % unpack fieldname
    if isfield(varpart,f)                               % if field exists in varpart
        ds.(f) = varpart.(f) ;                          % copy field to defstruct
    end
end
% copy fields like first_preamble2 and last_body3
vf = fieldnames(varpart) ;                              % fields of input structure
vf = vf(cellfun(@(x)length(x) ==1, ...                  % fields like first_preamblex etc.
    regexpi(vf,'^(first|last)_(preamble|body)\d+')));
for f1 = vf'                                         	% for each of the fields
    f   = f1{1} ;                                       % unpack fieldname
    ds.(lower(f)) = varpart.(f) ;                       % copy field to defstruct
end
  
end

%% subfunction insert_xsl
function insert_xsl(fout,ds,i)
% insert step for block i (called by construct_xsl)
%{
fout    : handle to output xsl file
ds      : structure with fields to be used
i       : number of block that is to be handled
%}
switch i
    case 1  % insert_hoqc_1
        %  \documentclass{article}                      % base value
        t1 = '\\documentclass{%s}' ;                    % format for new line
        t1 = sprintf(t1,ds.documentclass);              % create the new line
        fprintf(fout,'%s\n',t1) ;                       % write the new line to output xsl file
        insert_first_last(fout,ds,'first_preamble')
    case 2 % % insert_hoqc_2
        %  \usepackage[a4paper,margin=1in,landscape]{geometry}
        t1 = '\\usepackage[%s,%s,%s]{geometry}';
        t1 = sprintf(t1,ds.paper,ds.sizes,ds.orientation);
        fprintf(fout,'%s\n',t1) ;
        if strcmpi(ds.style,'Matlab-noformat')          % style set to 'Matlab-noformat'
            t1 = '\usepackage{listings}';               % indicate use of listings package
            fprintf(fout,'%s\n',t1) ;                   % without prettifier package
            t1 = '\\lstset{%s}';                        % options for listings package
            t1 = sprintf(t1,ds.listing_options);
            fprintf(fout,'%s\n',t1) ;
        else
            %  \usepackage[framed,numbered]{matlab-prettifier}
            t1 = '\\usepackage[%s]{matlab-prettifier}';
            t1 = sprintf(t1,ds.prettifier_options);
            fprintf(fout,'%s\n',t1) ;
            t1 = ['% package matlab-prettifier created by Julien Cretel. ', ...
                'Available CTAN (only matlab-prettifier.sty is needed)'];
            fprintf(fout,'%s\n',t1) ;
            %  \lstset{style = Matlab-editor}
            t1 = '\\lstset{style = %s}';
            t1 = sprintf(t1,ds.style);
            fprintf(fout,'%s\n',t1) ;
        end
        %  \usepackage[unicode=true,pdftitle={},
        t1 = '\\usepackage[unicode=true,pdftitle={%s},';
        t1 = sprintf(t1,ds.pdftitle);
        fprintf(fout,'%s\n',t1) ;
        %  pdfauthor={Han Oostdijk Quantitative Consultancy (han@hanoostdijk.nl)},
        t1 = 'pdfauthor={%s},';
        t1 = sprintf(t1,ds.pdfauthor);
        fprintf(fout,'%s\n',t1) ;
        %  pdfsubject={},
        t1 = 'pdfsubject={%s},';
        t1 = sprintf(t1,ds.pdfsubject);
        fprintf(fout,'%s\n',t1) ;
        %  pdfkeywords={},
        t1 = 'pdfkeywords={%s},';
        t1 = sprintf(t1,ds.pdfkeywords);
        fprintf(fout,'%s\n',t1) ;
        %  pdfproducer={},
        t1 = 'pdfproducer={%s},';
        t1 = sprintf(t1,ds.pdfproducer);
        fprintf(fout,'%s\n',t1) ;
        %  pdfcreator={},
        t1 = 'pdfcreator={%s},';
        t1 = sprintf(t1,ds.pdfcreator);
        fprintf(fout,'%s\n',t1) ;
    case 3
        insert_first_last(fout,ds,'last_preamble')
    case 4
        insert_first_last(fout,ds,'first_body')
        %  \title{mytitle}
        t1 = '\\title{%s}';
        t1 = sprintf(t1,ds.title);
        fprintf(fout,'%s\n',t1) ;
        %  \author{myauthor}
        t1 = '\\author{%s}';
        t1 = sprintf(t1,ds.author);
        fprintf(fout,'%s\n',t1) ;
        %  \maketitle
        t1 = '%s\\maketitle';
        if ds.maketitle
            s1 = '' ;
        else
            s1 = '%' ;
        end
        t1 = sprintf(t1,s1);
        fprintf(fout,'%s\n',t1) ;
        %  \tableofcontents
        t1 = '%s\\tableofcontents';
        if ds.maketableofcontents
            s1 = '' ;
        else
            s1 = '%' ;
        end
        t1 = sprintf(t1,s1);
        fprintf(fout,'%s\n',t1) ;
        %  \lstlistoflistings
        t1 = '%s\\lstlistoflistings';
        if ds.makelistoflistings
            s1 = '' ;
        else
            s1 = '%' ;
        end
        t1 = sprintf(t1,s1);
        fprintf(fout,'%s\n',t1) ;
        %  \listoffigures
        t1 = '%s\\listoffigures';
        if ds.makelistoffigures
            s1 = '' ;
        else
            s1 = '%' ;
        end
        t1 = sprintf(t1,s1);
        fprintf(fout,'%s\n',t1) ;
        %  \def\graphwidth{4in}
        t1 = '\\def\\graphwidth{%s}';
        t1 = sprintf(t1,ds.graph_width);
        fprintf(fout,'%s\n',t1) ;
    case 5
        insert_first_last(fout,ds,'last_body')
  	case 6
        if ds.maketableofcontents
            s1 = '<!--' ;
        else
            s1 = ' ' ;
        end
        fprintf(fout,'%s\n',s1) ;
   	case 7
      	if ds.maketableofcontents
            s1 = '-->' ;
        else
            s1 = ' ' ;
        end
        fprintf(fout,'%s\n',s1) ;
    case 8
        %  \<xsl:value-of select="$headinglevel"/>*{<xsl:apply-templates select="steptitle"/>}
        t1 = '\\<xsl:value-of select="$headinglevel"/>%s{<xsl:apply-templates select="steptitle"/>}';
        if ds.maketableofcontents
            s1 = '' ;
        else
            s1 = '*' ;
        end
        t1 = sprintf(t1,s1);
        fprintf(fout,'%s\n',t1) ;
end
end

function insert_first_last(fout,ds,prefix)
% insert blocks for first_preamble and last_body
j = 1 ;
while (j > 0)
    f = sprintf('%s%.0f',prefix,j);
    if ~(isfield(ds,f))
        break
    else
        fprintf(fout,'%s\n',ds.(f)) ;
        j = j + 1 ;
    end
end
end

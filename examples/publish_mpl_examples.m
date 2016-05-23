addpath('../code')
%% example1: -> pdf
% Use the function to create pdf-file.
% This is the same as using the publish user interface.
mycode = { ...                                          % example of code to execute (two lines)   
          	'avalue = 2;'   ...   
            'exampleA'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' , 'pdf' , ...                              % output format
    'call' , {mycode} , ...                             % code to execute (defined above)
    'newname' , 'exampleA1.pdf' );                      % new name of output file 
newname = publish_mpl('exampleA', pstruct) ;            % produce the output file (pdf)             

%% example2: -> latex 
% Use the function to create tex-file
% with as much as possible the same layout
% as the original tex file but with references, captions
% and listings
mycode = { ...                                          % example of code to execute (one line)   
            'exampleA'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' , 'latex' , ...                            % output format latex using the new xsl file
    'call' , {mycode} , ...                             % code to execute (defined above)
    'orientation', 'portrait', ...                      % overwrite orientation (default 'landscape')
    'newname' , 'exampleA2.tex' , ...                   % new name of output file 
    'prettifier_options' , '' ) ;                       % overwrite prettify options (default 'framed,numbered')
  
newname = publish_mpl('exampleA', pstruct) ;           	% produce the output file (tex)    

%% example3: -> latex  
% Same as example2 but the layout is landscape and
% the MATLAB code will be in frames with numbers.
mycode = { ...                                          % example of code to execute (one line)  
            'exampleA'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' , 'latex' , ...                            % output format latex using the new xsl file
    'call' , {mycode} , ...                             % code to execute (defined above)
    'newname' , 'exampleA3.tex');                       % new name of output file 
 %  'orientation', 'landscape', ...                     % use default orientation ('landscape')
 %  'prettifier_options', 'framed,numbered' , ...       % use default prettify options ('framed,numbered')
   
newname = publish_mpl('exampleA', pstruct) ;           	% produce the output file (tex)    
%% example4: -> latex  
% same as example3 but listings have their own
% caption in exampleB and they are listed by
% setting 'makelstlistoflistings' to true
mycode = { ...                                          % example of code to execute (one line)  
            'exampleB'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' , 'latex' , ...                            % output format latex using the new xsl file
    'call' , {mycode} , ...                             % code to execute (defined above)
    'newname' , 'exampleB1.tex' , ...                   % new name of output file     
    'pdfauthor', 'han@hanoostdijk.nl' , ...         	% insert a pdf option
    'makelstlistoflistings', true);                     % create lstlistoflistings
newname = publish_mpl('exampleB', pstruct) ;           	% produce the output file (tex)    

%% example5: -> latex  
% same as example4 but now with a regular LaTeX contents 
% by setting 'maketableofcontents' to true
mycode = { ...                                          % example of code to execute (one line)  
            'exampleB'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' , 'latex' , ...                            % output format latex using the new xsl file
    'call' , {mycode} , ...                             % code to execute (defined above)
    'newname' , 'exampleB2.tex' , ...                   % new name of output file     
    'pdfauthor', 'han@hanoostdijk.nl' , ...         	% insert a pdf option    
    'maketableofcontents', true , ...                   % create tableofcontents
    'makelstlistoflistings', true);                     % create lstlistoflistings
newname = publish_mpl('exampleB', pstruct) ;           	% produce the output file (tex)    

%% example6: -> xml 
% same as example3 but now to xml format
mycode = { ...                                          % example of code to execute (one line)  
            'exampleB'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' , 'xml' , ...                            	% output format latex using the new xsl file
    'call' , {mycode} , ...                             % code to execute (defined above)
    'newname' , 'exampleB3.xml' , ...                  	% new name of output file     
    'pdfauthor', 'han@hanoostdijk.nl' , ...         	% insert a pdf option
    'makelstlistoflistings', true);                     % create lstlistoflistings
newname = publish_mpl('exampleB', pstruct) ;           	% produce the output file (tex)    

%% example7: -> latex  
% example with additional latex statements
% by using first/last preamble options
mycode = { ...                                          % example of code to execute (one line)  
            'exampleC'   ...
            } ; 
pstruct = struct( ...                                   % publish options
    'format' ,  ...                                     % output format latex using the new xsl file
        'latex' , ... 
    'call' , ...                                        % code to execute (defined above)
        {mycode} , ...
    'newname' , ...                                     % new name of output file    
        'exampleC.tex' , ...       
    'first_preamble1', ...                              % to insert at start of preamble:
        '\usepackage[T1]{fontenc}' , ...                %   for translation special symbols 
    'first_preamble2', ...                              % to insert at start of preamble:
        '\newcommand{\bslash}[0]{\char`\\}' , ...       %   for printing a backslash 
    'first_preamble3', ...                              % to insert at start of preamble:
        '\renewcommand*{\familydefault}{\sfdefault}' , ... % make sans serif the default 
    'last_preamble1', ...                               % to insert at end of preamble 
                      ...                               % (because dependent on orientation)
        '\usepackage{fancyhdr}' , ...                   %   use fancyhdr for handling headers and footers
    'last_preamble2', ...                               % to insert at end of preamble 
        '\pagestyle{fancy}' , ...                       %   set page style
    'last_preamble3', ...                               % to insert at end of preamble 
        '\fancyhf{}' , ...                              %   clear header and footer information
    'last_preamble4', ...                               % to insert at end of preamble 
        '\lhead{Example CL (left header)}' , ...        %   set left header
 	'last_preamble5', ...                               % to insert at end of preamble 
        '\chead{Example CM (mid header)}' , ...      	%   set mid header
 	'last_preamble6', ...                               % to insert at end of preamble 
        '\rhead{Example CR (right header)}' , ...     	%   set right header
    'last_preamble7', ...                               % to insert at end of preamble 
        '\cfoot{mid footer Page \thepage~of \pageref{LastPage}}' , ... % set (only) mid footer
    'last_preamble8', ...                               % to insert at end of preamble 
        '\usepackage{lastpage}' , ...                   % use lastpage in footer
    'prettifier_options', ...                           % matlab and listing will get frame without numbering
        'framed,unnumbered', ...   
    'pdftitle', ...                                     % title in pdf attributes 
        'Example C', ... 
    'pdfauthor', ...                                    % author in pdf attributes  
        'han@hanoostdijk.nl' , ... 
    'orientation', ...                                  % portrait or landscape 
        'landscape', ...      
    'title', ...                                        % title in document 
        'Example C: advanced (?) use of LaTeX', ... 
    'author', ...                                       % auhor in document 
        'Han Oostdijk (han@hanoostdijk.nl)', ...
    'maketitle', ...                                    % create title
        true , ... 
    'maketableofcontents', ...                          % create tableofcontents
        true , ...  
    'makelistoflistings', ...                           % create lstlistoflistings
    true);   
newname = publish_mpl('exampleC', pstruct) ;            % produce the output file (tex)    
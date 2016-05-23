%%
%% Introduction
% In this example we show how can add some LaTeX functionality
% by directly inserting LaTeX statements. Of course we can always
% simply insert a LaTeX section as show in the next paragraph.
% Such a section will be added to the body section of the tex document.
% In other cases however we need to include statements in the
% preamble and this we can do with the _first_preamblex_ and 
% _last_preamblex_ statements. For 'reasons of symmetry' we 
% have added _first_bodyx_ and _last_bodyx_ statements.  
%
% *NB* The listing of the two files that were used to produce
% this document are included at the end of this document
%% Insert an external reference
% <latex> 
% % First section has no title. A title is provided by the 
% % \textit{title} option in the struct that is passed to the
% % publish function.
% An external reference such as e.g. 
% \url{https://github.com/HanOostdijk/matlab_publish_latex.git} 
% can be inserted by enclosing it in a <latex> block.  
% </latex>
%% Inserting 'strange' symbols
% <latex> 
% The '<' and '>' symbols in a <latex> block will not be printed 
% correctly unless a \textit{\bslash usepackage[T1]{fontenc}} statement is inserted
% in the preamble of the latex source. Here this is done by specifying
% the \textit{first\_preamble1} option in the publish struct. And for correctly
% printing the \bslash in this section we defined the \bslash bslash macro in the
% \textit{first\_preamble2} option.
% </latex>
%% Using a sans serif letter type
% Normally a serif letter type is used. You can indicate that a sans serif
% letter will be used (for the standard text). Here this is done by specifying
% the _first_preamble3_ option in the publish struct.
%% Using a header and footer
% The LaTeX package _fancyhdr_ can be used to specify headers and footers for the document. 
% The statements for this package can be included in the preamble by using the _first_preamble_x_ 
% or _last_preamble_x_  statements. In this case it is important that the _last_preamble_x_ 
% (and not the _first_preamble_x_) statements are used because the information from the geometry 
% statement will be used by the _fancyhdr_ package. And because the geometry statement will be generated
% from the _paper_, _sizes_ and _orientation_ options in the fixed part of the preamble, the only way
% to guarantee that this information is available is placing the _fancyhdr_ statements at the very end of
% the preamble.
%%
% <latex>
% % the following statements define the captions of the first plot:
% \global\def\captionA{a sinoid plot} 
% </latex>
%% Just a plot to see that this _is_ MATLAB
% <latex>
% Until now in this whole document not a single MATLAB statement was used. 
% To correct for that,  we use MATLAB to create the plot in 
% figure \ref{exampleC_01.eps} on page \pageref{exampleC_01.eps}.
% </latex>
t   = 0:.01:pi*4;
k   = 6 ;
y   = sin(k*t)./(1+t);
figure(1)
plot(t,y);
%%
% <latex>
% \lstinputlisting[frame=single,numbers=none,caption=exampleC script]{../exampleC.m}
% \lstinputlisting[frame=single,numbers=none,firstline=89,caption=publish\_mpl\_examples script (example C only)]{../publish_mpl_examples.m}
% </latex>
% 
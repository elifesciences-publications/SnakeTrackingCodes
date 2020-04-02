%================================== plot =================================
%
%  function plot(g, label, linecolor)
%
%  Plots the coordinate frame associated to g.  The figure is cleared, 
%  so this will clear any existing graphic in the figure.  To plot on
%  top of an existing figure, set hold to on.
%
%  Inputs:
%    g		- The SE2 coordinate frame to plot.
%    label	- The label to assign the frame.
%    linecolor  - The line color to use for plotting.  (See `help plot`) 
%
%  Output:
%    The coordinate frame, and possibly a label,  is plotted.
%
%================================== plot =================================

%
%  Name:	plot.m
%
%  Author:	Patricio A. Vela, pvela@gatech.edu
%
%  Created:	2007/09/XX
%  Modified:	2008/08/17
%
%================================== plot =================================
function plot(g, length , flabel, lcol, s)

if ( (nargin < 2) )
  length = 10;
end

if ( (nargin < 3) )
  flabel = '';
end

if ( (nargin < 4) || isempty(lcol) )
  lcol = 'b';
end

if ( (nargin < 5) || isempty(lcol) )
  s = 1;
end

o = g.d;

x = g.R*[length;0];
y = g.R*[0;length];

isheld = ishold;

plot(o(1)+[0 x(1)],o(2) + [0 x(2)],lcol);
hold on;
plot(o(1)+[0 y(1)],o(2) + [0 y(2)],lcol);
plot(o(1), o(2), [lcol 'o'],'MarkerSize',s);

if (~isempty(flabel))
  text(o(1) + (x(1)+y(1))/2, o(2) + (x(2)+y(2))/2, flabel);
end

if (~isheld)
 hold off;
end

%
%================================== plot =================================

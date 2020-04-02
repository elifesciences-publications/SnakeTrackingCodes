%================================== plot =================================
%
%  function plot(g, label, linecolor, sc)
%
%  Plots the coordinate frame associated to g.  The figure is cleared, 
%  so this will clear any existing graphic in the figure.  To plot on
%  top of an existing figure, set hold to on.  The label is the name
%  of label given to the frame (if given is it writen out).  The 
%  linecolor is a valid plot linespec character.  Finally sc is the
%
%  Inputs:
%    g		- The SE2 coordinate frame to plot.
%    label	- The label to assign the frame.
%    linecolor  - The line color to use for plotting.  (See `help plot`) 
%    sc		- scale to plot things at.
%		  a 2x1 vector, first element is length of axes.
%		    second element is a scalar indicating roughly how far
%		    from the origin the label should be placed.
%
%  Output:
%    The coordinate frame, and possibly a label, is plotted.
%
%================================== plot =================================

%
%  Name:	plot.m
%
%  Author:	Patricio A. Vela, pvela@gatech.edu
%
%  Created:	2008/10/01
%  Modified:	2008/10/01
%
%================================== plot =================================
function plot(g, flabel, lcol, sc, Lw)

if nargin<5
   Lw = 1; 
end

if ( (nargin < 2) )
  flabel = '';
end

if ( (nargin < 3) || isempty(lcol) )
  lcol = 'brg';
end

if ( (nargin < 4) || isempty(sc) )
  sc = [1.0 0.5];
elseif (size(sc,2) == 1)
  sc = [sc 2];
end

d = g.M(1:3,4);
R = g.M(1:3,1:3);

ex = R*[sc(1);0;0];		% get rotated x-axis.
ey = R*[0;sc(1);0];		% get rotated y-axis.
ez = R*[0;0;sc(1)];		% get rotated z-axis.

isheld = ishold;

pts = [d , d+ex];
plot3(pts(1,:), pts(2,:), pts(3,:),lcol(2), 'LineWidth', Lw);		% x-axis
hold on;
  pts = [d , d+ey];
  plot3(pts(1,:), pts(2,:), pts(3,:),lcol(1), 'LineWidth', Lw);		% y-axis
  pts = [d , d+ez];
  plot3(pts(1,:), pts(2,:), pts(3,:),lcol(3), 'LineWidth', Lw);		% z-axis

  plot3(d(1), d(2), d(3), [lcol(1) 'o'],'MarkerSize',7);		% origin

if (~isempty(flabel))
  pts = d - (sc(2)/sc(1))*(ex+ey+ez);
  text(pts(1), pts(2), pts(3),flabel);
end

if (~isheld)
 hold off;
end

axis equal;
%
%================================== plot =================================

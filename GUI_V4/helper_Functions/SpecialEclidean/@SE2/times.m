%================================= times =================================
%
%  function p2 = times(g, p)
%
%
%  This function is the operator overload that implements the left action
%  of g on the point p.
%
%  Can also be typed as:  >> p2 = g.*p
%
%================================= times =================================
function p2 = times(g, p)

p2 = leftact(g,p);

%
%================================ leftact ================================

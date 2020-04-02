%================================= times =================================
%
%  function p2 = times(g, p)
%
%
%  This function is the operator overload that implements the left action
%  of g on the point p, the homogeneous point p, or on the homogeneous 
%  vector v.
%
%  Can also be typed as:  
%    >> p2 = g.*p
%    >> v2 = g.*v
%
%================================= times =================================
function p2 = times(g, p)

p2 = leftact(g,p);
end
%
%================================= times =================================

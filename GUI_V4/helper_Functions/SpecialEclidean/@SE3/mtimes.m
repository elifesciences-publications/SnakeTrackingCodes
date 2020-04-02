%================================= mtimes ================================
%
%  function g = mtimes(g1, g2)
%
%
%  Computes and returns the product of g1 with g2.
%
%  Can also be typed as:  >> g3 = g1*g2
%
%================================= mtimes ================================
function g = mtimes(g1, g2)


g.d = g1.d+g1.R*g2.d;
g.R = g1.R*g2.R;
g.M=[g.R g.d; 0 0 0 1];
g = class(g, 'SE3');

end

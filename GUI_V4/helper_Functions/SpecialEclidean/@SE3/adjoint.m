%================================ Adjoint ================================
%
%  function g = adjoint(g1, g2)
%
%
%  Computes and returns the adjoint of g.  The adjoint is defined to
%  operate as:
%
%    Ad_g1 (g2) = g1 * g2 * inverse g1
%
%================================ Adjoint ================================
function y = adjoint(g, x)
						% compute Adjoint  ...
if (isa(x,'SE3'))				%    of Lie group.
  y = g*x*inv(g);
elseif ( (size(x,1) == 6) && (size(x,2) == 1) )	%    of vector.

    a=[0 -g.M(3,4) g.M(2,4); g.M(3,4) 0 -g.M(1,4); -g.M(2,4) g.M(1,4) 0]*g.M((1:3),(1:3));
    z = [g.M((1:3),(1:3)) a; zeros(3,3) g.M((1:3),(1:3))];
    y=z*x;
end

end

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
function z = adjoint(g, x)
    if isa(x,'SE2')
        z = g*x*inv(g);
    elseif size(x,1) == 3 && size(x,2) == 1
        JJ = [0 1;-1 0];
        z = [g.R , JJ*g.d;0 0 1]*x;
    elseif  (size(x,1) == 3) && (size(x,2) == 3) 
        z = [g.R, g.d;0 0 1]*x*inv([g.R , g.d;0 0 1]);
    end
end

%================================ inverse ================================
%
%  invg = inverse(g)
%
%  
%  Computes and returns the inverse to g.
%
%================================ inverse ================================
function invg = inverse(g)

invg.d = -(g.R^-1)*g.d;
invg.R = g.R^-1;

invg = class(invg, 'SE2');


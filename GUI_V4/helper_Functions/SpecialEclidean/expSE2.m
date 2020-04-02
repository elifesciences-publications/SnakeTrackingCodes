function g = expSE2(xi, g0, tau)
% does the exponential operator in SE2
if nargin<3
    tau = 1;
end

if nargin<2 
    g0 = se2();
end

if size(xi,1) ==3
    xi =xi';
end
j = [0 1; -1 0];

if xi(3) ~=0
d = - 1/xi(3)*(eye(2)- getRSE2(SE2([0 0], xi(3)*tau)))*j*xi(1:2)';
else
d = xi(1:2)*tau;
end
g = mtimes(g0,SE2(d, xi(3)*tau));


end
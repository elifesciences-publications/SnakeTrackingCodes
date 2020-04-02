function g = expSE3(xi, g0, tau)

if size(xi,1) == 6
    xi = xi';
end

w = xi(4:6)';
v = xi(1:3)';

if nargin<3
    tau = 1;
end
if nargin<2
    g0 = SE3();
end

if norm(w)==0
    r = eye(3);
    d = v*tau;
else
    r = eye(3) + hat(w)/norm(w)*sin(norm(w)*tau) ...
        +hat(w)^2/(norm(w))^2*(1-cos(norm(w)*tau));
    
    d = (eye(3)- r)*hat(w)*v/norm(w)^2 + w*w'/norm(w)^2*v*tau;
end

g =g0 * SE3( d , r);

end
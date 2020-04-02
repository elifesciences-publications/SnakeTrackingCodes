%================================== log ==================================
%
%  function xi = log(g, tau)
%
%  Take the logarithm of the group element g.  If the time period of
%  the action is not given, it is assumed to be unity.
%
%================================== log ==================================
function xi = log3(g, tau)

if ( (nargin < 2) || isempty(tau) )
  tau = 1;
end

xi = zeros([6 1]);			% Specify size/dimensions of xi.

%--(1) Obtain the angular velocity.
WN = (1/tau)*acos((trace(g.R)-1)/2);
if WN == 0
    omega = [0;0;0];
else
    omega = WN/(2*sin(WN*tau))*[(g.R(3,2)-g.R(2,3));(g.R(1,3)-g.R(3,1));...
    (g.R(2,1)-g.R(1,2))];
end
if sum(omega ~= 0)>0
%--(2) Compute the linear velocity.
v= ((WN^2)*((eye(3)-g.R)*hat(omega)+tau*omega*omega')^-1)*g.d;
else
    v=g.d/tau;
end
xi=[v;omega];
end
%
%================================== log ==================================

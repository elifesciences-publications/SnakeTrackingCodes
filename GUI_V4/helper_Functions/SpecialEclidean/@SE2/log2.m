%================================== log ==================================
%
%  function xi = log(g, tau)
%
%  Take the logarithm of the group element g.  If the time period of
%  the action is not given, it is assumed to be unity.
%
%================================== log ==================================
function xi = log2(g, tau)
j=[0 1; -1 0];
if ( (nargin < 2) || isempty(tau) )
  tau = 1;
end

xi = zeros([3 1]);			% Specify size/dimensions of xi.

%--(1) Obtain the angular velocity.
omega=atan2(g.R(2,1),g.R(1,1))/tau;
if omega ~= 0
%--(2) Compute the linear velocity.
v= omega*j*((eye(2)-g.R)^-1)*g.d;
else
    v=g.d/tau;
end
xi=[v;omega];
end
%
%================================== log ==================================

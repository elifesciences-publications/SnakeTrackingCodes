%================================== SE2 ==================================
%
%  function g = SE2(d, theta)
%
%
%  Generates an instance of the class object SE2.  As a class, it acts as
%  though it were a Matlab variable.  Different operations and actions
%  can be applied to it.
%
%
%================================== SE2 ==================================
function obj = SE2(d, theta)

if (nargin == 0)
  g.d = [0; 0];
  g.R = eye(2);
else
  if ( (size(d,1) == 2) && (size(d,2) == 1) )
    g.d = d;
  elseif ( (size(d,1) == 1) && (size(d,2) == 2) )
    g.d = d';
  else
    error('The translation vector has incorrect dimensions');
  end
  g.R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
end

obj = class(g, 'SE2');

end
%
%================================== SE2 ==================================

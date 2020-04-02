%================================== SE3 ==================================
%
%  function g = SE3(d, R)
%
%
%  Generates an instance of the class object SE3.  As a class, it acts as
%  though it were a Matlab variable.  Different operations and actions
%  can be applied to it.
%
%
%================================== SE3 ==================================
function obj = SE3(d, R)

if (nargin == 0)					% Create as identity.
  g.d = [0 0 0].';
  g.R = eye(3);
elseif ( (size(d,1) == 1) && (size(d,2) == 3) )		% if row vector.
  g.d = d.';						%   make column.
elseif ((size(d,1) == 3) && (size(d,2) == 1))
  g.d = d;
end

if (nargin == 1)					% Only displaceme;nt
    g.R = eye(3);						%  make identity.
elseif nargin==2
    if size(R,1) == size(R,2) 
    g.R=R;
    else
    g.R = rot(R);
    end
end
%Note:  Here we are assuming that the rotation matrix is in fact a
%         rotation matrix.  We are not checking orthonormality nor
%         unity determinant.

g.M = [g.R g.d; zeros(1,3) 1]	;			% Create homogeneous matrix.
obj = class(g, 'SE3');

end
%
%================================== SE3 ==================================
function R = rot(omega)
% pass thetas, starting with x and ending with z
R = roty(omega(2))*rotz(omega(3))*rotx(omega(1));

end

function x= rotz(theta)
 x= [cos(theta)  -sin(theta) 0;  sin(theta) cos(theta) 0 ; 0 0 1];
end

function x= roty(theta)
 x= [cos(theta) 0 sin(theta); 0 1 0 ; -sin(theta) 0 cos(theta)];
end

function x= rotx(theta)
 x= [1 0 0 ;0 cos(theta)  -sin(theta) ;0 sin(theta) cos(theta) ];
end
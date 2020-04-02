function R = rotation(omega)
% pass thetas, starting with x and ending with z
R = rotx(omega(1))*roty(omega(2))*rotz(omega(3));

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
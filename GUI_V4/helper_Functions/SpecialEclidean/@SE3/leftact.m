%================================ leftact ================================
%
%  p2 = leftact(g, p)
%		with p a 2x1 specifying point coordinates.
%
%  p2 = leftact(g, v)
%		with v a 3x1 specifying a velocity.
%		This applies to pure translational velocities in homogeneous
%		form, or to SE2 velocities in vector forn.
%
%  This function takes a change of coordinates and a point/velocity,
%  and returns the transformation of that point/velocity under the change
%  of coordinates.  
%  
%  Alternatively, one can think of the change of coordinates as a 
%  transformation of the point to somewhere else, %  e.g., a displacement 
%  of the point.  It all depends on one's  perspective of the 
%  operation/situation.
%
%================================ leftact ================================
function x2 = leftact(g, x)

if  (size(x,1) == 3) 	% If three vector.
  x2 = repmat(g.d,1,size(x,2)) + g.R*x;		%  treat like a point.
elseif  (size(x,1) == 4)	% else it is homogeneous.
  x2 = repmat(g.d ,1,size(x,2)) + g.R*x(1:3);				%  do the right thing.
end
end

%
%================================ leftact ================================

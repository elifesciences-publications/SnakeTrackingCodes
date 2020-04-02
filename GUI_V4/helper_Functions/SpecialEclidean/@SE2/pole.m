%================================== pole =================================
%
%  function qpole = pole(g)
%
%  Computes the pole associated with the transformation g.
%
%================================== pole =================================
function qpole = pole(g)

qpole = inv(eye(2)- g.R)*g.d;

end

%
%================================== pole =================================

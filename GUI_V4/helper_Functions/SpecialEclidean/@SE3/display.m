%================================ display ================================
%
%  function display(g)
%
%
%  This is the default display function for the SE2 class.  It simply
%  displays the position followed by the rotation.
%
%================================ display ================================
function display(g)

if isequal(get(0,'FormatSpacing'),'compact')
  disp([inputname(1) ' =']);
  disp(g.M);
else
  disp(' ');
  disp([inputname(1) ' =']);
  disp(' ');
  disp(g.M);
end



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

gM = [g.R , g.d ; 0 0 1];
disp(gM);


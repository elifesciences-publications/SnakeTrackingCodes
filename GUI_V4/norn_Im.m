
% normalize image
function I = norn_Im(I)
I = I - min(I(:));
I = 100*I/max(I(:));
end
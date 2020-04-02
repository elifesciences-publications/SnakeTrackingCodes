function J = boundEmpty(I)


J = zeros(1.5*size(I));

J(floor(size(I,1)/4)+1: floor(5/4*size(I,1)),floor(size(I,2)/4)+1:floor(5/4*size(I,2))) = I;
clear I
end
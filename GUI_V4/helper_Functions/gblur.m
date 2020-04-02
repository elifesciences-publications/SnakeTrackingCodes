%================================= gblur =================================
%
%  Performs Gaussian blurring on an image, with a given window size.
%  Does so using the fast Fourier transform in 2D.
%
%  function J = gblur(I,sd)
%
%
%  Inputs:
%    I		-The image to blur.
%    sd		-The standard deviation of the Gaussian.
%
%================================= gblur =================================

%
%  Name:	gblur.m
%
%  Author:	Patricio A. Vela, pvela@ece.gatech.edu
%
%  Created:	01/19/2006
%  Modified:	01/19/2006
%
%================================= gblur =================================
function J = gblur(I, wdSize,  sd, type)

if sd == 0
    J = I;
    return
end

if nargin<4
    type = 'none';
end

if strcmp(type, 'none')
    J = zeros(size(I,1) , size(I,2),size(I,3));
else
    J = gsingle(zeros(size(I,1) , size(I,2),size(I,3)));
end

for m = 1:size(I,3)
    if strcmp(type, 'none')
        J(:,:,m) =  imfilter(I(:,:,m),fspecial('gaussian',wdSize,sd));
    else
        J(:,:,m) =  imfilter(gsingle(I(:,:,m)),gsingle(fspecial('gaussian',wdSize,sd)));
    end
end
end

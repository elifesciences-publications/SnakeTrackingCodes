function diff_im = anisodiffusion(im, num_iter, delta_t, kappa, debug)

if nargin< 5
    debug = 0;
end
% Convert input image to double.

% PDE (partial differential equation) initial condition.
diff_im = im;

% Center pixel distances.
dx = 1;
dy = 1;

% masks.
if isa(im, 'gsingle')
    h_N = gsingle([0 1 0; 0 -1 0; 0 0 0]);
    h_S = gsingle([0 0 0; 0 -1 0; 0 1 0]);
    h_E = gsingle([0 0 0; 0 -1 1; 0 0 0]);
    h_W = gsingle([0 0 0; 1 -1 0; 0 0 0]);
else
    h_N = ([0 1 0; 0 -1 0; 0 0 0]);
    h_S = ([0 0 0; 0 -1 0; 0 1 0]);
    h_E = ([0 0 0; 0 -1 1; 0 0 0]);
    h_W = ([0 0 0; 1 -1 0; 0 0 0]);
end



% Anisotropic diffusion.
for t = 1:num_iter
    N = imfilter(diff_im,h_N,'conv');
    S = imfilter(diff_im,h_S,'conv');
    W = imfilter(diff_im,h_W,'conv');
    E = imfilter(diff_im,h_E,'conv');
    
    e_N = 1./(1 + (N/kappa).^2);
    e_S = 1./(1 + (S/kappa).^2);
    e_W = 1./(1 + (W/kappa).^2);
    e_E = 1./(1 + (E/kappa).^2);
    
    % Discrete PDE solution.
    diff_im = diff_im + ...
        delta_t*(...
        (1/(dy^2))*e_N.*N + (1/(dy^2))*e_S.*S + ...
        (1/(dx^2))*e_W.*W + (1/(dx^2))*e_E.*E );
    
    if debug
        figure(20)
        imagesc(diff_im)
        drawnow()
        colormap gray
    end
end
end

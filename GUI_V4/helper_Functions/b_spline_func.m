% recursive algorithm for b-spline basis function
function [y, x] = b_spline_func(t_ind, order, num, i, x)

if nargin<4
    i = 1;
    x = linspace(t_ind(i), t_ind(end), (order+1)*num+1);
end


if nargin<5
    x = linspace(t_ind(i), t_ind(end), (order+1)*num+1);
end


y = b_Spline_Scheme(t_ind, order, i, x, num);
end

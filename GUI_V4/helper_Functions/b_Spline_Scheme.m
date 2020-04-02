function b = b_Spline_Scheme(t_ind, k, i, x, num)
% k : order
% i: knot index
% x: parameterization term
% num: resolution

b = zeros(size(x));
if k > 1
    %%%%%%%%%%% k-th order component %%%%%%%%%%
    
    % first part
    y = b_spline_func( t_ind, k-1, num, i, x);
    v_num = x - t_ind(i);
    v_den = t_ind(i+k-1) - t_ind(i);
    if v_den~=0
        b = b + y.*v_num/v_den;
    end
    
    % second part
    y = b_spline_func( t_ind, k-1, num, i+1, x);
    v_num = x - t_ind(i+1);
    v_den = t_ind(i+k) - t_ind(i+1);
    if v_den~=0
        b = b + (1-v_num/v_den).*y;
    end
else
    % zeroth order component
    if t_ind(i+1) == max(t_ind)
        b = t_ind(i) <= x & x <= t_ind(i+1);
    else
        b = t_ind(i) <= x & x < t_ind(i+1);
    end
end
end
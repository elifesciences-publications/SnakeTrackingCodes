function pts_k1 = hungarian_Kal_Solve_Per(state, state_Pred, pts_Obs)
global Filt
global track_Params


pts_Obs = [pts_Obs(:,1) zeros(size(pts_Obs,1),2) ...
    pts_Obs(:,2) zeros(size(pts_Obs,1),2)];

num = floor(size(state,2)/2);

% placeholders for speed
costMat = zeros(num, size(pts_Obs,1));
y = cell(num, size(pts_Obs,1));

C  = diag_With_Matrix(Filt.C);
P  = diag_With_Matrix(Filt.P);
K  = diag_With_Matrix(Filt.K);
R  = diag_With_Matrix(Filt.R);
for  m = 1:num
    for  n = 1:size(pts_Obs,1)
        
        if norm(state(1,[m m+num])-pts_Obs(n, [1 4])) < track_Params.mun_Lim
            y{m,n} = get_Meas( [state(:,m); state(:,m+num)], pts_Obs(n, :));
            
            switch track_Params.kalman.order
                case 1
                    v = C*(y{m,n}([1 4]) ...
                        - [state_Pred(:,m) state_Pred(:,m+num)]  )';
                case 2
                    v = C*(y{m,n}([1 2 4 5]) ...
                        - [state_Pred(:,m)' state_Pred(:,m+num)'] )';
                case 3
                    v = C*(y{m,n} ...
                        - [state_Pred(:,m)' state_Pred(:,m+num)'])';
            end
            
            w =(eye(size(v,1)) - C*K)*v;
            
            costMat(m,n) = sqrt(v'*K'*(P^-1)*K*v + w'*(R^-1)*w) ;
        else
            costMat(m,n) = inf;
        end
    end
end

[assignment, ~] = munkres(costMat);

% assigned points with corresponding measurements
pts_k1 = zeros(length(assignment),6);
for m = 1:length(assignment)
    if assignment(m) > 0
        pts_k1(m,:) =  y{m, assignment(m)}; % y_k_1(assignment(m),:);
    else
        switch track_Params.kalman.order
            case 1
                pts_k1(m,[1 4]) =  [state_Pred(:,m)' state_Pred(:,m+num)'];
                pts_k1(m,[2 3 5 6]) = [state(2:3,m)' state(2:3,m+num)'];
            case 2
                pts_k1(m,[1 2 4 5]) =  [state_Pred(:,m)' state_Pred(:,m+num)'];
                pts_k1(m,[3 6]) = [state(3,m) state(3,m+num)];
            case 3
                pts_k1(m,:) =  [state_Pred(:,m)' state_Pred(:,m+num)'];
        end
        
    end
end

end

% get kinematic measurement
function A = diag_With_Matrix(A)
[dx, dy] = size(A);
A  = repmat(A, [2 2]);
A(dx+1:end, 1:dy) = 0;
A(1:dx, dy+1:end) = 0;
end

% get kinematic measurement
function y_k = get_Meas(x_k0, y_k)
y_k(2) =  y_k(1) - x_k0(1);
y_k(3) =  y_k(2) - x_k0(2);
y_k(5) =  y_k(4) - x_k0(4);
y_k(6) =  y_k(5) - x_k0(5);
end

function pts = Id_Per_Parts(dt, vec_Pred, debug)
global gui_States
global track_Params
global Data
global file
global gui_Tr

ind =(Data.frame_Index == (file.range(2)-dt));
ind_At =(Data.frame_Index == (file.range(2)));
% id step
pts= [];

if debug
  K = zeros(file.dim_Y(end), file.dim_X(end));
  KKX = zeros(file.dim_Y(end), file.dim_X(end));
  switch dt
    case 1
      vec = solve_Axis(Data.Forward.pose(:,1,ind), ...
        Data.Forward.pose(:,2,ind),...
        track_Params.w_Size,  file.dim_X(end), file.dim_Y(end));
    case -1
      vec = solve_Axis(Data.Backward.pose(:,1,ind), ...
        Data.Backward.pose(:,2,ind),...
        track_Params.w_Size,  file.dim_X(end), file.dim_Y(end));
  end
end
isdef = zeros(1,Data.count(ind_At));
val_Max = nan(1,Data.count(ind_At));
val_Min = nan(1,Data.count(ind_At));
J_F_Part = cell(1,Data.count(ind_At));
for m = 1:Data.count(ind_At)
  
  switch dt
    case 1
      val = isnan(Data.Forward.pose(m,1,ind));
      
    case -1
      val = isnan(Data.Backward.pose(m,1,ind));
  end
  
  if ~val
    
    switch dt
      case 1
        JJ = gui_States.I(...
          max(1,floor(Data.Forward.pose(m,2,ind)-track_Params.w_Size )):...
          min(file.dimensions(2),floor(Data.Forward.pose(m,2,ind)+track_Params.w_Size )),...
          max(1,floor(Data.Forward.pose(m,1,ind)-track_Params.w_Size )):...
          min(file.dimensions(4), floor(Data.Forward.pose(m,1,ind)+track_Params.w_Size )));
        
      case -1
        JJ = gui_States.I(...
          max(1,floor(Data.Backward.pose(m,2,ind)-track_Params.w_Size )):...
          min(file.dimensions(2),floor(Data.Backward.pose(m,2,ind)+track_Params.w_Size )),...
          max(1,floor(Data.Backward.pose(m,1,ind)-track_Params.w_Size )):...
          min(file.dimensions(4), floor(Data.Backward.pose(m,1,ind)+track_Params.w_Size )));
        
    end
    
    
    sigma =  1/sqrt(2)*Data.radius(m);
%     J_F_Part{m}=  sqrt(2)*sigma*fftshift(ifft2(fft2((...
%       medfilt2( JJ, 7*[3 3]))).* ...
%       fft2(sigma*fspecial('log',size(JJ),sigma))));
%     
            J_F_Part{m} = sqrt(2)*sigma*fftshift(ifft2(fft2(norn_Im(JJ)).* ...
                fft2(sigma*fspecial('log',size(JJ),sigma))));
    isdef(m) = 1;
    val_Min(m) = min(J_F_Part{m}(J_F_Part{m}(:)>0));
  end
end
% should completely normalize across all fields
val_Min = min(val_Min);
for m = 1:Data.count(ind_At)
  if isdef(m)
    J_F_Part{m} = J_F_Part{m} - val_Min;
    val_Max(m) = max(J_F_Part{m}(:));
  end
end
val_Max = max(val_Max);
for m = 1:Data.count(ind_At)
  if isdef(m)
    J_F_Part{m} = J_F_Part{m}/val_Max;
  end
end

for m = 1:Data.count(ind_At)
  
  if isdef(m)
    %% update search region
    lim = .9;
    D = region_Grab(track_Params.w_Size , track_Params.w_Size , J_F_Part{m});
    KK  = double(D < track_Params.w_Size*lim);
    
    %% exclusion operator
    J_F_Part{m} = norn_Im((KK).*J_F_Part{m});
    J_F_Resp = double( J_F_Part{m} > track_Params.Thresh);
    
    % extract seperate regions
    [P,~] = bwlabel(J_F_Resp);
    
    box = double(D > track_Params.w_Size*lim);
    box_in = (1-box) .*P;
    box_out = box .*P;
    
    count = 0;
    rng = unique(box_out(:)');
    for mm = rng(rng>0);
      %             if sum(box_out(:)==mm)
      if  sum(box_out(:) == mm) > 5
       
      J_F_Resp(P==mm) = 0;
      
      if sum(J_F_Resp(:)) < 1/sqrt(2)*1/2*pi*Data.radius(m)^2
        count = 1;
      end
      end
      
      %             end
    end
    
    % extract seperate regions
    [P,~] = bwlabel(J_F_Resp);
    
    % place_holders
    x_b = zeros(max(P(:)),1);
    y_b = zeros(max(P(:)),1);
    
    % extracting centers and shifting them back to image domain
    switch dt
      case 1
        for mm = 1:max(P(:))
          [yy,xx] =ind2sub(size(P), find(P==mm));
          y_b(mm,1) = mean(yy) - track_Params.w_Size  + Data.Forward.pose(m,2,ind);
          x_b(mm,1) = mean(xx) - track_Params.w_Size  + Data.Forward.pose(m,1,ind);
        end
      case -1
        for mm = 1:max(P(:))
          [yy,xx] =ind2sub(size(P), find(P==mm));
          y_b(mm,1) = mean(yy) - track_Params.w_Size  + Data.Backward.pose(m,2,ind);
          x_b(mm,1) = mean(xx) - track_Params.w_Size  + Data.Backward.pose(m,1,ind);
        end
    end
    
    % passing back
    if ~count
      pts= [pts; x_b, y_b];
    else
      pts= [pts; x_b, y_b; ...
        vec_Pred(m,:)];
    end
    
    if debug
      switch dt
        case 1
          vec_vert = ...
            floor(Data.Forward.pose(m,2,ind)-track_Params.w_Size ):...
            floor(Data.Forward.pose(m,2,ind)+track_Params.w_Size );
          vect_horz = ...
            floor(Data.Forward.pose(m,1,ind)-track_Params.w_Size ):...
            floor(Data.Forward.pose(m,1,ind)+track_Params.w_Size );
        case -1
          vec_vert = ...
            floor(Data.Backward.pose(m,2,ind)-track_Params.w_Size ):...
            floor(Data.Backward.pose(m,2,ind)+track_Params.w_Size );
          vect_horz = ...
            floor(Data.Backward.pose(m,1,ind)-track_Params.w_Size ):...
            floor(Data.Backward.pose(m,1,ind)+track_Params.w_Size );
          
      end
      
      % update region
      K(vec_vert,...
        vect_horz) = ...
        max((1-box).*J_F_Part{m}, K(vec_vert, vect_horz));
      
      % update region
      KKX(vec_vert,...
        vect_horz) = ...
        max(J_F_Resp, KKX(vec_vert, vect_horz));
      
    end
  end
end
% 
% prevents double markers
% ind1 = [];
% dist = zeros(size(pts,1),size(pts,1));
% for  m = 1:size(pts,1)-1
%   for  n = m+1:size(pts,1)
%     dist(m,n) = norm(pts(m,:) - pts(n,:));
%     
%     if dist(m,n) < 2
%       ind1 = [ind1; m,n];
%     end
%   end
% end
% 
% if ~isempty(ind1)
%   for m = 1:max(size(unique(ind(:,1))))
%     index = find(ind1(m,1)== ind1(:,1));
%     pts(ind1(m,1),:) = mean(pts(index,:),1);
%     pts(ind1(index,2),:) = nan;
%   end
%   pts(ind1(:,2),:) = [];
% end

if debug
  
  if  gui_States.crop
    
    if Data.frame_Tracked(ind) == 3
      vec = [ ...
        max(1,-50+ min([Data.Forward.pose(:,1,ind);...
        Data.Backward.pose(:,1,ind)]))...
        min(file.dimensions(2),50+ max([Data.Forward.pose(:,1,ind);...
        Data.Backward.pose(:,1,ind)]))...
        max(1,-50+min([Data.Forward.pose(:,2,ind);...
        Data.Backward.pose(:,2,ind)]))...
        min(file.dimensions(4),50+max([Data.Forward.pose(:,2,ind);...
        Data.Backward.pose(:,2,ind)]))];
      
    elseif Data.frame_Tracked(ind) == 1
      vec = [ ...
        max(1,-50+ min(Data.Forward.pose(:,1,ind)))...
        min(file.dimensions(2),50+max(Data.Forward.pose(:,1,ind))) ...
        max(1,-50+min(Data.Forward.pose(:,2,ind)))...
        min(file.dimensions(4),50+max(Data.Forward.pose(:,2,ind)))];
      
    elseif Data.frame_Tracked(ind) == 2
      vec = [ ...
        max(1,-50+ min(Data.Backward.pose(:,1,ind)))...
        min(file.dimensions(2),50+max(Data.Backward.pose(:,1,ind))) ...
        max(1,-50+min(Data.Backward.pose(:,2,ind)))...
        min(file.dimensions(4),50+max(Data.Backward.pose(:,2,ind)))];
    end
  else
    vec = [gui_States.dimensions_Cropped];
  end
  set(gui_Tr.figure_B_1_Mag, 'XData', file.dim_X, ...
    'YData', file.dim_Y, ...
    'CData', uint8(repmat(gui_States.I,[1 1 3])))
  set(gui_Tr.plot_B_1, 'XData', pts(:,1), ...
    'YData', pts(:,2))
  set(gui_Tr.plot_B_1_C, 'XData', vec_Pred(:,1), ...
    'YData', vec_Pred(:,2))
  axis(gui_Tr.figure_B_1, vec)
  
  set(gui_Tr.figure_B_2_Mag, 'XData', file.dim_X, ...
    'YData', file.dim_Y, ...
    'CData', K)
  axis(gui_Tr.figure_B_2, vec)
  
  set(gui_Tr.figure_B_3_Mag, 'XData', file.dim_X, ...
    'YData', file.dim_Y, ...
    'CData', KKX)
  set(gui_Tr.plot_B_3_C, 'XData', pts(:,1), ...
    'YData', pts(:,2))
  axis(gui_Tr.figure_B_3, vec)
  %     colormap hot
end
end

function D = region_Grab(x, y, J)

bw = zeros(size(J));
a = and(round(y)<size(J,1),round(y)>0);
b = and(round(x)<size(J,2),round(x)>0);
bw(sub2ind(size(J),round(y(and(a,b))),round(x(and(a,b))))) = 1;
D = bwdist(bw,'euclidean');

end

function vec = solve_Axis(val_x, val_y, h,  max_x, max_y)
val_x = [min(val_x)-h, max(val_x)+h];
val_y = [min(val_y)-h, max(val_y)+h];
val_x = min(max(val_x, 1), max_x);
val_y = min(max(val_y, 1), max_y);

vec = [val_x, val_y];
end
function update_Plot_Body()
global file
global gui_Tr
global gui_States
global Data

ind = (Data.frame_Index == file.range(2));
% forward plots
if (Data.frame_Tracked(ind) == 1) || (Data.frame_Tracked(ind) == 3)
    va = Data.Forward.pose(logical((Data.type==0).*(~isnan(Data.Forward.pose(:,1,(Data.frame_Index == file.range(2)))))'), :, (Data.frame_Index == file.range(2)))';
    
    if ~isempty(va)
        % update the b-spline object only if tracked
        update_B_Spline_State(1);        
        % update the b-spline
        vec = gui_States.b_Spline_Forward_Obj.eval_X(linspace(0,1,1000))*...
            gui_States.b_Spline_Forward_Obj.basis_Coeff';
        set(gui_Tr.markers_Forward_Spine, 'XData', vec(:,1), 'YData', vec(:,2));
    end    
    
    % update the markers
    set(gui_Tr.markers_Count_Forward_Spine, ...
        'XData', Data.Forward.pose(Data.type == 0,1,ind), ...
        'YData', Data.Forward.pose(Data.type == 0,2,ind));
    set(gui_Tr.markers_Count_Forward_Limb, ...
        'XData', Data.Forward.pose(Data.type == 1,1,ind), ...
        'YData', Data.Forward.pose(Data.type == 1,2,ind));
    
    
    % update text in forward markers
    for m = 1:size(Data.Forward.pose(:, 1, ind),1)
        set(gui_Tr.markers_Text_Plus(m) , 'position',...
            [Data.Forward.pose(m, 1, ind) ...
            Data.Forward.pose(m, 2, ind) 0]);
    end
    
end

% backward plots
if (Data.frame_Tracked(ind) == 2) || (Data.frame_Tracked(ind) == 3)    
    va = Data.Backward.pose(logical((Data.type==0).*(~isnan(Data.Backward.pose(:,1,(Data.frame_Index == file.range(2)))))'), :, (Data.frame_Index == file.range(2)))';
    
    if ~isempty(va)
        % update the b-spline object only if tracked
        update_B_Spline_State(-1);
        
        % update the b-spline
        vec = gui_States.b_Spline_Backward_Obj.eval_X(linspace(0,1,1000))*...
            gui_States.b_Spline_Backward_Obj.basis_Coeff';
        set(gui_Tr.markers_Backward_Spine, 'XData', vec(:,1),'YData', vec(:,2));
    end
    
    % update the markers
    set(gui_Tr.markers_Count_Backward_Spine, ...
        'XData', Data.Backward.pose(Data.type == 0,1,ind), ...
        'YData', Data.Backward.pose(Data.type == 0,2,ind));
    set(gui_Tr.markers_Count_Backward_Limb, ...
        'XData', Data.Backward.pose(Data.type == 1,1,ind), ...
        'YData', Data.Backward.pose(Data.type == 1,2,ind));
    
    % update text in backward markers
    for m = 1:size(Data.Backward.pose(:, 1, ind),1)
        set(gui_Tr.markers_Text_Minus(m) , 'position',...
            [Data.Backward.pose(m,1,ind) ...
            Data.Backward.pose(m,2,ind) 0]);
    end
end
end
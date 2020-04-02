function update_B_Spline_State(dt)
global gui_States
global Data
global file

switch dt
    case 1
        if isfield( Data, 'Forward')
            b.states = ....
                fliplr(Data.Forward.pose(logical((Data.type==0).*(~isnan(Data.Forward.pose(:,1,(Data.frame_Index == file.range(2)))))'), :, (Data.frame_Index == file.range(2)))');
            
                % updating the b-spline states
                gui_States.b_Spline_Forward_Obj.process_Input(b);
        end
    case -1
        if isfield( Data, 'Backward')
            b.states = ...
                Data.Backward.pose(logical((Data.type==0).*(~isnan(Data.Backward.pose(:,1,(Data.frame_Index == file.range(2)))))'), :, (Data.frame_Index == file.range(2)))';
            
                % updating the b-spline states
                gui_States.b_Spline_Backward_Obj.process_Input(b);
        end
end
end
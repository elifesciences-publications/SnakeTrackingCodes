function update_B_Spline()

global track_Params
global gui_States
global Data

% update parameters in b-spline
gui_States.b_Spline_Forward_Obj.process_Input(track_Params.b_Spline);
gui_States.b_Spline_Backward_Obj.process_Input(track_Params.b_Spline);

% keep data spline consistent
Data.b_Spline = track_Params.b_Spline;

% update disp
display_At();
end
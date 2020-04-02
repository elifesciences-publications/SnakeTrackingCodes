function params_GUI(dim, dims)

if nargin< 1
    dim = [.35 .45];
end

global track_Params
global gui_Tr

% parameter gui
gui_Tr.params_GUI = setup_GUI_Screen_Template( dim, dims(1), dims(2));

% UI boxes
gui_Tr.params_GUI_Ui_Box_1 = uipanel('Parent', gui_Tr.params_GUI, 'BackgroundColor',[1 1 1],...
    'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', '', ...
    'Position', [.01 .01 .98 .98], 'fontunits', 'normalized', 'fontsize', .15 );

gui_Tr.params_GUI_Ui_Box_2 = uipanel('Parent', gui_Tr.params_GUI_Ui_Box_1, 'BackgroundColor',[0 0 0],...
    'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', 'Kalman', ...
    'Position', [.05 .025 .9 .315], 'fontunits', 'normalized', 'fontsize', .15 );

gui_Tr.params_GUI_Ui_Box_3 = uipanel('Parent', gui_Tr.params_GUI_Ui_Box_1, 'BackgroundColor',[0 0 0],...
    'units', 'normalized', 'ForegroundColor', [1 1 1], 'title','Munkres', ...
    'Position', [.05 .355 .9 .1], 'fontunits', 'normalized', 'fontsize', .25 );

gui_Tr.params_GUI_Ui_Box_4 = uipanel('Parent', gui_Tr.params_GUI_Ui_Box_1, 'BackgroundColor',[0 0 0],...
    'units', 'normalized', 'ForegroundColor', [1 1 1], 'title',  'B-Spline', ...
    'Position', [.05 .475 .9 .30], 'fontunits', 'normalized', 'fontsize', .15 );

gui_Tr.params_GUI_Ui_Box_5 = uipanel('Parent', gui_Tr.params_GUI_Ui_Box_1, 'BackgroundColor',[0 0 0],...
    'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', 'Blob Detector', ...
    'Position', [.05 .795 .9 .2], 'fontunits', 'normalized', 'fontsize', .2 );

% track parameter inputs

% % blob detector
gui_Tr.params_GUI_Box_Win_Dim = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_5, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .15  .35 .2],  'String', 'Window Dim', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Input_Win_Dim = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_5, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .15  .2 .2],  'String', num2str(track_Params.w_Size), ...
    'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@win_Check_Callback});

gui_Tr.params_GUI_Box_Thresh = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_5, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .425  .35 .2],  'String', 'Thresh', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Input_Thresh = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_5, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .425  .2 .2],  'String', num2str(track_Params.Thresh), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@thresh_Check_Callback});

% % b-Spline
gui_Tr.params_GUI_Boxb_Spline_T_Ahead = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .025  .35 .125],  'String', 'Pred lim', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Spline_Input_T_Ahead = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .025  .2 .125],  'String', ...
    num2str(track_Params.b_Spline.pred_Limit) , 'fontunits', 'normalized', 'fontsize', .5, ...
    'Callback', {@b_Spline_Pred_Limit});

gui_Tr.params_GUI_Box_Spline_Lambda = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .225  .35 .125],  'String', 'Lambda', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Spline_Input_Lambda = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .225  .2 .125],  'String',...
    num2str(track_Params.b_Spline.reg_Term) , 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@b_Spline_Reg_Term});

gui_Tr.params_GUI_Boxb_Spline_Num_Basis = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .425  .35 .125],  'String', '# Basis', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Spline_Input_Num_Basis = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .425  .2 .125],  'String',...
      num2str(track_Params.b_Spline.num_Basis) , ...
    'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@b_Spline_Num_Basis});

gui_Tr.params_GUI_Box_Spline_Order_Basis = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .625  .35 .125],  'String', 'Order', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Spline_Input_Order_Basis = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .625  .2 .125],  'String',...
    num2str(track_Params.b_Spline.order), 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@b_Spline_Order});

gui_Tr.params_GUI_Box_Spline_Res = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .825  .35 .125],  'String', 'Resolution', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Spline_Input_Res= uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .825  .2 .125],  'String',...
    num2str(track_Params.b_Spline.res), 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@b_Spline_Res});

% Munkres
gui_Tr.params_GUI_Box_Munkres_Limit = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_3, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .225  .35 .5],  'String', 'Range', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_Spline_Input_Munkres_Limit = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_3, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .225  .2 .5],  'String', '15', 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@munkres_Check_Callback});

% % Kalman
gui_Tr.params_GUI_popup_Class = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'units','normalized','position', ...
    [.05 .9 .4 .05], 'style','popup','string', {'Zeroth', 'First', 'Second'}, 'value', track_Params.kalman.order,'Callback', @set_Order_Callback);

gui_Tr.params_GUI_Box_Q = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.125  .6  .1 .1],  'String', 'Q', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.params_GUI_Box_R = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.525  .6  .1 .1],  'String', 'R', 'fontunits', 'normalized', 'fontsize', .75);

% Q
gui_Tr.params_GUI_Box_Q_0 = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.225  .425  .2 .15],  'String', num2str(track_Params.kalman.Q(1)), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@Q_0_Check_Callback});
gui_Tr.params_GUI_Box_Q_1 = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.225  .225  .2 .15],  'String', num2str(track_Params.kalman.Q(2)), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@Q_1_Check_Callback});
gui_Tr.params_GUI_Box_Q_2 = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.225  .025  .2 .15],  'String', num2str(track_Params.kalman.Q(3)), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@Q_2_Check_Callback});

% R
gui_Tr.params_GUI_Box_R_0 = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .425  .2 .15],  'String', num2str(track_Params.kalman.R(1)), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@R_0_Check_Callback});
gui_Tr.params_GUI_Box_R_1 = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .225  .2 .15],  'String', num2str(track_Params.kalman.R(2)), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@R_1_Check_Callback});
gui_Tr.params_GUI_Box_R_2 = uicontrol('Parent', gui_Tr.params_GUI_Ui_Box_2, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.725  .025  .2 .15],  'String', num2str(track_Params.kalman.R(3)), 'fontunits', 'normalized', 'fontsize', .65,...
    'Callback', {@R_2_Check_Callback});

end
% identification parameters
function win_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Input_Win_Dim, 'string'));

if val < 5 || val > 100
    val = min(max(val,5),100);
    set(gui_Tr.params_GUI_Box_Input_Win_Dim, 'string', num2str(val));
end

track_Params.w_Size = val;
end
function thresh_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Input_Thresh, 'string'));

if val < 0 || val > 100
    val = min(max(val,0),100);
    set(gui_Tr.params_GUI_Box_Input_Thresh, 'string', num2str(val));
end

track_Params.Thresh = val;
end
% b-Spline paramers
function b_Spline_Pred_Limit(~,~)
global track_Params
global gui_Tr
val = str2double(get(gui_Tr.params_GUI_Box_Spline_Input_T_Ahead, 'string'));

if val < 0 || val > 1
    val = min(max(val,0),1);
    set(gui_Tr.params_GUI_Box_Spline_Input_T_Ahead, 'string', num2str(val));
end

track_Params.b_Spline.pred_Limit = val;

% update b spline parameters
update_B_Spline()
end
function b_Spline_Reg_Term(~,~)
global track_Params
global gui_Tr
val = str2double(get(gui_Tr.params_GUI_Box_Spline_Input_Lambda, 'string'));

if val <= 0 || val > 1000
    val = min(max(val,1e-7),1000);
    set(gui_Tr.params_GUI_Box_Spline_Input_Lambda, 'string', num2str(val));
end

track_Params.b_Spline.reg_Term = val;

% update b spline parameters
update_B_Spline()
end
function b_Spline_Num_Basis(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Spline_Input_Num_Basis , 'string'));

if val < 1 || val > 1000
    val = min(max(val,1),1000);
    set(gui_Tr.params_GUI_Box_Spline_Input_Num_Basis , 'string', num2str(val));
end

track_Params.b_Spline.num_Basis = val;

% update b spline parameters
update_B_Spline()
end
function b_Spline_Order(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Spline_Input_Order_Basis , 'string'));

if val < 1 || val > 1001
    val = min(max(val,1),1001);
    set(gui_Tr.params_GUI_Box_Spline_Input_Order_Basis , 'string', num2str(val));
end

track_Params.b_Spline.order = val;

% update b spline parameters
update_B_Spline()
end
function b_Spline_Res(~,~)
global track_Params
global gui_Tr
val = str2double(get(gui_Tr.params_GUI_Box_Spline_Input_Res, 'string'));

if val < 1 || val > 1001
    val = min(max(val,1),1001);
    set(gui_Tr.params_GUI_Box_Spline_Input_Res, 'string', num2str(val));
end

track_Params.b_Spline.res = val;

% update b spline parameters
update_B_Spline()
end
% munkres parameters
function munkres_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Spline_Input_Munkres_Limit, 'string'));

if val < 5 || val > 100
    val = min(max(val,5),100);
    set(gui_Tr.params_GUI_Box_Spline_Input_Munkres_Limit, 'string', num2str(val));
end

track_Params.mun_Lim = val;
end
% Kalman parameters
function set_Order_Callback(~,~)
global track_Params
global gui_Tr

track_Params.kalman.order = get(gui_Tr.params_GUI_popup_Class , 'value');

end
% Q
function Q_0_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Q_0, 'string'));

if val < 0
    val = max(val,1e-5);
    set(gui_Tr.params_GUI_Box_Q_0, 'string', num2str(val));
end

track_Params.kalman.Q(1) = val;
end
function Q_1_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Q_1, 'string'));

if val < 0
    val = max(val,1e-5);
    set(gui_Tr.params_GUI_Box_Q_1, 'string', num2str(val));
end

track_Params.kalman.Q(2) = val;
end
function Q_2_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_Q_2, 'string'));

if val < 0
    val = max(val,1e-5);
    set(gui_Tr.params_GUI_Box_Q_2, 'string', num2str(val));
end

track_Params.kalman.Q(3) = val;
end
% R
function R_0_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_R_0, 'string'));

if val < 0
    val = max(val,1e-5);
    set(gui_Tr.params_GUI_Box_R_0, 'string', num2str(val));
end

track_Params.kalman.R(1) = val;
end
function R_1_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_R_1, 'string'));

if val < 0
    val = max(val,1e-5);
    set(gui_Tr.params_GUI_Box_R_1, 'string', num2str(val));
end

track_Params.kalman.R(2) = val;
end
function R_2_Check_Callback(~,~)
global track_Params
global gui_Tr

val = str2double(get(gui_Tr.params_GUI_Box_R_2, 'string'));

if val < 0
    val = max(val,1e-5);
    set(gui_Tr.params_GUI_Box_R_2, 'string', num2str(val));
end

track_Params.kalman.R(3) = val;
end
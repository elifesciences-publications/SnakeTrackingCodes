function test_GUI_V4_Fully_Coded_PES()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%file
% % name
% % range = [init at final]
% % dim_X
% % dim_Y
% % dimensions = [ dim_X dim_Y]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
if ispc()
  addpath([cd '/helper_Functions'])
end

%%%%%%%%%%%%%%%%%%%%%%%% main function variables %%%%%%%%%%%%%%%%%%%%%%%%%%
global syst
global gui_Tr
global gui_States

if isunix()
  syst.sl = '/';
else
  syst.sl = '\';
end

syst.default_Image = magic(100)'/100/100;
gui_States.Image = syst.default_Image;
%%%%%%%%%%%%%%%%%%%%%%%%%%% GUI Construction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up screen
[gui_Tr.pose, gui_Tr.GUI] = setup_GUI_Screen(1.5*[.4 .5]);
set(gui_Tr.GUI, 'KeyPressFcn', @KeyPressFcn_0_State)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Directory Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gui_Tr.ui_Box_1 = uipanel('Parent', gui_Tr.GUI, 'BackgroundColor','white',...
  'units', 'normalized', 'Position', [.025 .94 .7 .05]);

% directory text box
gui_Tr.t_Box_1 = uicontrol('Parent', gui_Tr.ui_Box_1, 'Style','text', 'units', 'normalized', 'BackgroundColor','white', ...
  'Position', [.0 .0 .12 .8],  'String','Directory', 'fontunits', 'normalized', 'fontsize', .65 );

% directory input text box inputs
if ispc()
  gui_Tr.t_Box_Input_1 = uicontrol('Parent', gui_Tr.ui_Box_1, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.13 .05 .75 .9],  'String',...
    '', ...
    'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@check_Exist});
else
  gui_Tr.t_Box_Input_1 = uicontrol('Parent', gui_Tr.ui_Box_1, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
    'Position', [.13 .05 .75 .9],  'String',...
    '/Users/jbravoxl/Dropbox/projects/bioestimation/Animals/data/snake/1503_dry', ...
    'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@check_Exist});
end

% directory input Push button
gui_Tr.load_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_1, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.89 .05 .1 .9],  'String','Load', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@load_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Control Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gui_Tr.ui_Box_2 = uipanel('Parent', gui_Tr.GUI, 'BackgroundColor','white',...
  'units', 'normalized', 'title', 'Control Panel', 'Position', ...
  [.75 .025 .25 .90]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% subpanels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% playback panel %%%%%%%%%%%%%%%%%%%%%%%%%
gui_Tr.ui_Box_3 = uipanel('Parent', gui_Tr.ui_Box_2, 'BackgroundColor',[0 0 0],...
  'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', '', ...
  'Position', [.025 .89 .95 .1], 'fontunits', 'normalized', 'fontsize', .5 );

% diplay text
gui_Tr.t_Box_Init = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [.05 .15+.70/3  .70/3 .70/3],  'String','Init', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.t_Box_AT = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [.70/3+.15 .15+.70/3  .70/3 .70/3],  'String','AT', 'fontunits', 'normalized', 'fontsize', .75);

gui_Tr.t_Box_End = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style','text', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [2*.70/3+.25  .15+.70/3  .70/3 .70/3],  'String','Last', 'fontunits', 'normalized', 'fontsize', .75);

% text inputs
gui_Tr.t_Box_Input_Init = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [.05 .05  .70/3 .70/3],  'String','0', ...
  'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@update_Limits});

gui_Tr.t_Box_Input_AT = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [.70/3+.15 .05  .70/3 .70/3],  'String','0', ...
  'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@update_Limits});

gui_Tr.t_Box_Input_End = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [2*.70/3+.25  .05  .70/3 .70/3],  'String','0', ...
  'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@update_Limits});

% push buttons
gui_Tr.play_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.025 .25+2*.70/3 .15 .70/3],  'String', 'Play', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@play_Callback});

gui_Tr.rewind_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.225 .25+2*.70/3 .15 .70/3],  'String', 'rewind', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@rewind_Callback});

gui_Tr.reset_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.425 .25+2*.70/3 .15 .70/3],  'String', 'Reset', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@reset_Callback});

gui_Tr.prev_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.625 .25+2*.70/3 .15 .70/3],  'String', 'prev', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@prev_Callback});

gui_Tr.next_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_3, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.825 .25+2*.70/3 .15 .70/3],  'String', 'next', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@next_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% marker input panel %%%%%%%%%%%%%%%%%%%%%%%
gui_Tr.ui_Box_4 = uipanel('Parent', gui_Tr.ui_Box_2, 'BackgroundColor',[0 0 0],...
  'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', '', ...
  'Position', [.025 .805 .95 .075], 'fontunits', 'normalized', 'fontsize', .15 );

% push buttons
gui_Tr.spine_Single_Input_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.025 .55 .2 .4],  'String', 'Spine +', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@input_Spine});

gui_Tr.marker_Single_Remove_Plus_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.25 .55 .125 .4],  'String', 'Rem +', 'fontunits', 'normalized', 'fontsize', .4, 'Callback', {@remove_Marker_Plus});

gui_Tr.marker_Single_Remove_Minus_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.375 .55 .125 .4],  'String', 'Rem -', 'fontunits', 'normalized', 'fontsize', .4, 'Callback', {@remove_Marker_Minus});

gui_Tr.marker_Correct_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.525 .55 .2 .4],  'String', 'Correct', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@correct});

gui_Tr.limb_Single_Input_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.025 .05 .2 .4],  'String', 'Limb +', 'fontunits', 'normalized', 'fontsize', .65, 'Callback',{@input_Limb});

gui_Tr.t_Box_Input_Remove = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [.275 .05 .2 .4],  'String','1', ...
  'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@update_Limits});

gui_Tr.t_Box_Input_Correct = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'edit', 'units', 'normalized', 'BackgroundColor','white',  ...
  'Position', [.525 .05 .2 .4],  'String','1', ...
  'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@check_Mark_Exist});

gui_Tr.marker_Reset_Markers = uicontrol('Parent', gui_Tr.ui_Box_4, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.755 .05 .225 .9],  'String', 'Rem Real', 'fontunits', 'normalized', 'fontsize', .25, 'Callback', {@Reset_Markers});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% display panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gui_Tr.ui_Box_5 = uipanel('Parent', gui_Tr.ui_Box_2, 'BackgroundColor',[0 0 0],...
  'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', '', ...
  'Position', [.025 .67 .95 .125], 'fontunits', 'normalized', 'fontsize', .1 );

% push buttons
gui_Tr.display_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .775 .80 .2],  'String', 'display', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@display_Callback});

gui_Tr.crop_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .525 .375 .2],  'String', 'crop', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@crop_Callback});

gui_Tr.crop_Local_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.525 .525 .375 .2],  'String', 'local crop', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@crop_Local_Callback});

gui_Tr.b_display_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .275 .80 .2],  'String', 'b display', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@b_Display_Callback});

gui_Tr.plot_Plus_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .025 .7/3 .2],  'String', 'Plot +', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@plot_Plus_Callback});

gui_Tr.plot_Minus_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1+.7/3+.05 .025 .7/3 .2],  'String', 'Plot -', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@plot_Minus_Callback});

gui_Tr.plot_Label_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_5, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1+2*.7/3+.1 .025 .7/3 .2],  'String', 'Label', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@plot_Label_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Track panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%
gui_Tr.ui_Box_6 = uipanel('Parent', gui_Tr.ui_Box_2, 'BackgroundColor',[0 0 0],...
  'units', 'normalized', 'ForegroundColor', [1 1 1], 'title', '', ...
  'Position', [.025 .575 .95 .085], 'fontunits', 'normalized', 'fontsize', .1 );

gui_Tr.track_Plus_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_6, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .025 .375 .2],  'String', 'Track +', 'fontunits', 'normalized',...
  'fontsize', .65, 'Callback', {@track_Plus_Callback});

gui_Tr.track_Minus_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_6, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.525 .025 .375 .2],  'String', 'Track -', 'fontunits', 'normalized', ...
  'fontsize', .65, 'Callback', {@track_Minus_Callback});

gui_Tr.save_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_6, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .775 .80 .2],  'String', 'Save', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@save_Callback});

gui_Tr.t_Params_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_6, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
  'Position', [.1 .525 .80 .2],  'String', 'Parameters', 'fontunits', 'normalized', 'fontsize', .65, 'Callback', {@params_Callback});

% gui_Tr.Setup_Global_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_6, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
%     'Position', [.05 .775 .425 .2],  'String', 'Setup Global', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@track_Callback});
%
% gui_Tr.Solve_Global_PushBotton = uicontrol('Parent', gui_Tr.ui_Box_6, 'Style', 'PushButton', 'units', 'normalized', 'BackgroundColor',[.75 .75 .75],  ...
%     'Position', [.525 .775 .425 .2],  'String', 'Solve_Global', 'fontunits', 'normalized', 'fontsize', .5, 'Callback', {@track_Callback});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Main Figure %%%%%%%%%%
% directory input figure
gui_Tr.figure = axes('Parent', gui_Tr.GUI, 'units', 'normalized',  ...
  'position', [.00 .05 .75 .87]);

% directory input imagesc
gui_Tr.figure_Im = imagesc(gui_States.Image);
hold on
gui_Tr.markers_Forward_Spine         = plot(nan, nan,'Color',[255 0 102]./255);
gui_Tr.markers_Count_Forward_Spine   = plot(nan, nan,'*','Color',[0 255 255]./255,'MarkerSize',5,'LineWidth',1);
gui_Tr.markers_Count_Forward_Limb    = plot(nan, nan,'r^','MarkerSize',15);
gui_Tr.markers_Backward_Spine        = plot(nan, nan,'b');
gui_Tr.markers_Count_Backward_Spine  = plot(nan, nan,'bo','MarkerSize',15);
gui_Tr.markers_Count_Backward_Limb   = plot(nan, nan,'b^','MarkerSize',15);
gui_Tr.markers_Text_Plus             = text(nan, nan, '1','visible', 'off');
gui_Tr.markers_Text_Minus            = text(nan, nan, '1','visible', 'off');

hold off
axis 'off'
axis image
axis xy
colormap gray

%%%%%%%%%% Selection %%%%%%%%%%

% zoom in input figure
gui_Tr.figure_Zoom = axes('Parent', gui_Tr.GUI, 'units', 'normalized', ...
  'position', [.0 .075 .35 .75]);
gui_Tr.figure_Im_Zoom = imagesc(repmat(zeros(20,20),[1  1 3]));
hold on
gui_Tr.plot_Center          = plot(nan, nan,'rx');
gui_Tr.plot_Circle          = plot(nan, nan,'r');
gui_Tr.plot_Line            = line([nan, nan], [nan, nan]);
set(gui_Tr.plot_Line, 'color', 'r')
hold off
axis 'off'
axis image
axis xy
setappdata(gui_Tr.figure_Im_Zoom, 'circ_Params', linspace(0, 2*pi, 20));

% response input figure
gui_Tr.figure_Response = axes('Parent', gui_Tr.GUI, 'units', 'normalized', ...
  'position', [.4 .5 .3 .325]);
gui_Tr.figure_Im_Response = imagesc(zeros(20,20));
axis 'off'
axis image
axis xy
gui_Tr.figure_Response_Title = title('');

% mesh input figure
gui_Tr.figure_Mag = axes('Parent', gui_Tr.GUI, 'units', 'normalized', ...
  'position', [.425 .1 .25 .325]);
gui_Tr.figure_Mesh_Mag = mesh(nan(20,20));
gui_Tr.colorBar = colorbar();

gui_Tr.figure_B_1 = axes('Parent', gui_Tr.ui_Box_2, 'units', 'normalized',  ...
  'position', [.00 .29 1 .25]);
gui_Tr.figure_B_1_Mag = imagesc(rand(20,20));
hold on
gui_Tr.plot_B_1          = plot(nan, nan,'r.');
gui_Tr.plot_B_1_C        = plot(nan, nan,'ro');
hold off
axis 'off'
axis image
axis xy
title ' '

gui_Tr.figure_B_2 = axes('Parent', gui_Tr.ui_Box_2, 'units', 'normalized',  ...
  'position', [.005 .00 .49 .255]);
gui_Tr.figure_B_2_Mag = imagesc(rand(20,20));
axis 'off'
axis image
axis xy
title ' '
colormap hot

gui_Tr.figure_B_3 = axes('Parent', gui_Tr.ui_Box_2, 'units', 'normalized',  ...
  'position', [.505 .00 .49 .255]);
gui_Tr.figure_B_3_Mag = imagesc(rand(20,20));
hold on
gui_Tr.plot_B_3_C        = plot(nan, nan,'ro');
hold off
axis 'off'
axis image
axis xy
title ' '

% apply visibility to plots
% % figure plot
set(gui_Tr.markers_Forward_Spine         , 'visible', 'off');
set(gui_Tr.markers_Count_Forward_Spine   , 'visible', 'off');
set(gui_Tr.markers_Count_Forward_Limb    , 'visible', 'off');
set(gui_Tr.markers_Backward_Spine        , 'visible', 'off');
set(gui_Tr.markers_Count_Backward_Spine  , 'visible', 'off');
set(gui_Tr.markers_Count_Backward_Limb   , 'visible', 'off');

% % zoomed in axis
set(gui_Tr.figure_Im_Zoom       , 'visible', 'off')
set(gui_Tr.plot_Center          , 'visible', 'off')
set(gui_Tr.plot_Circle          , 'visible', 'off')
set(gui_Tr.plot_Line            , 'visible', 'off')
set(gui_Tr.colorBar             , 'visible', 'off')

% % zoomed in axis
set(gui_Tr.figure_Im_Response   , 'visible', 'off')
set(gui_Tr.figure_Response_Title, 'visible', 'off')

% % zoomed in mesh response
set(gui_Tr.figure_Mesh_Mag      , 'visible', 'off')
set(gui_Tr.figure_Mag           , 'visible', 'off')

% apply hittest to axes handles
set(gui_Tr.figure_Zoom          , 'HitTest', 'off')
set(gui_Tr.figure_Response      , 'HitTest', 'off')
set(gui_Tr.figure_Mag           , 'HitTest', 'off')

% b display
set(gui_Tr.figure_B_1_Mag  , 'visible', 'off');
set(gui_Tr.figure_B_2_Mag  , 'visible', 'off');
set(gui_Tr.figure_B_3_Mag  , 'visible', 'off');

% reset the states
reset_Gui_States()
end

% % reset states
function reset_Gui_States()
global gui_States;
global syst;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% define states %%%%%%%%%%%%%%%%%%%%%%%
% set states
gui_States.play                 = 0;            % play toggle
gui_States.rewind               = 0;            % rewind toggle
gui_States.display              = 0;            % display toggle
gui_States.dimensions_Cropped   = [1 100 1 100];% cropped dimension
gui_States.plot_Plus            = 0;            % forward plot toggle
gui_States.plot_Minus           = 0;            % reverse plot toggle
gui_States.track                = 0;            % track toggle
gui_States.crop                 = 0;            % crop toggle
gui_States.b_Displ              = 0;            % blob response display
gui_States.params_Def           = 0;            % implicit toggle for param control panel
gui_States.plot_Label           = 0;            % label toggle
gui_States.Image = syst.default_Image;          % image default
end
%%%%%%%%%%%%%%%%%%%%%%%%% File Call back Funtions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_Exist( ~, ~)
global gui_Tr

if exist(get(gui_Tr.t_Box_Input_1,'string'), 'file' )==7
  set(gui_Tr.t_Box_Input_1, 'BackgroundColor', [0 1 0])
else
  set(gui_Tr.t_Box_Input_1, 'BackgroundColor', [1 0 0])
end

end
function load_Callback( ~, ~)
%%%%%%%%%%%%%%%%%%%%%%%% main function variables %%%%%%%%%%%%%%%%%%%%%%%%%%
global file
global gui_States
global gui_Tr
global syst
global Data
global track_Params
%%%%%%%%%%%%%%%%%%%%%%%% Extract File Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(get(gui_Tr.load_PushBotton, 'fontWeight'), 'normal')
  
  if exist(get(gui_Tr.t_Box_Input_1,'string'), 'file' )==7
    
    % directory
    syst.dir = get(gui_Tr.t_Box_Input_1,'string');
    ind_Slash = find(syst.dir == syst.sl, 1, 'last');
    % locate parameters
    name_File = [syst.dir syst.sl 'tracked_Params' syst.sl 'Params_Matrix.mat'];
    if exist(name_File, 'file') == 2
      load(name_File)
      
      % name
      file.name = syst.dir((ind_Slash+1):end);
      
      % update title bar
      set(gui_Tr.GUI, 'name', file.name)
      
      % update current axes
      axes(gui_Tr.figure)
      
      % update text in backward markers
      for m = 1:Data.count
        gui_Tr.markers_Text_Plus(m)  = text(...
          Data.Forward.pose(m, 1, Data.frame_Index == file.range(2)),...
          Data.Forward.pose(m, 2, Data.frame_Index == file.range(2))...
          , num2str(m), 'visible', 'off');
      end
      
      % update text in backward markers
      for m = 1:Data.count
        gui_Tr.markers_Text_Minus(m)  = text(...
          Data.Backward.pose(m, 1, Data.frame_Index == file.range(2)),...
          Data.Backward.pose(m, 2, Data.frame_Index == file.range(2))...
          , num2str(m),'visible', 'off');
      end
      
    else
      
      % name
      file.name = syst.dir((ind_Slash+1):end);
      
      % update title bar
      set(gui_Tr.GUI, 'name', file.name)
      
      % id file range
      c_dir = dir(syst.dir);
      count = 0;
      file.range = [0 0 0];
      for m = 1:size(c_dir,1)
        name = c_dir(m).name;
        if strcmp(name(1:(find(name == '_', 1, 'last')-1)), file.name) ...
            && ~(exist([syst.dir syst.sl name], 'file' )==7)
          ind_Under = find(name  == '_', 1, 'last');
          ind_Dot = find(name  == '.', 1, 'last');
          val = str2double(name ((ind_Under+1):(ind_Dot-1)));
          if count == 0
            file.range(1:3) = val;
            file.im_Type = name(find(name == '.', 1, 'last')+1:end);
          else
            file.range(1) = min(file.range(1), val);
            file.range(2) = file.range(1);
            file.range(3) = max(file.range(3), val);
          end
          count = count + 1;
        end
      end
      
      % Data
      % % Forward
      Data.Forward.pose    = [];
      Data.Forward.vel    = [];
      Data.Forward.accel    = [];
      % % Backward
      Data.Backward.pose    = [];
      Data.Backward.vel    = [];
      Data.Backward.accel    = [];
      % single vec items
      % % marker length
      Data.dep    = [];       % marker dependency
      Data.radius = [];       % marker radius
      Data.type   = [];       % marker type (0 = spine, 1 = limb)
      Data.Marker_Index = []; % marker index
      Data.Marker_ID = [];    % marker index class char
      % % frame length
      Data.frame_Index = file.range(1):file.range(3);         % frame index
      Data.def    = zeros(1,length(Data.frame_Index));        % frame definition
      Data.frame_Tracked = zeros(1,length(Data.frame_Index)); % tracked
      % % scalar
      Data.count  =  zeros(1,length(Data.frame_Index));        % marker count
      % 0: no track, 1: forward, 2: backward, 3: all
      % % User Defined Pts
      Data.Predef_Cond = [];  % init, final and intermediary defined
      Data.Filter      = [];  % placeholder for P Variances
      
    end
    
    % update image indexs
    set( gui_Tr.t_Box_Input_Init, 'string', num2str(file.range(1)))
    set( gui_Tr.t_Box_Input_AT  , 'string', num2str(file.range(2)))
    set( gui_Tr.t_Box_Input_End , 'string', num2str(file.range(3)))
    
    % load image
    load_Img(file.range(2));
    
    % check state
    set(gui_Tr.load_PushBotton, 'fontWeight', 'bold')
    
    % define file parameters
    file.dimensions                 = [file.dim_X  file.dim_Y ];
    
    % update states
    gui_States.dimensions_Cropped   = file.dimensions;
    
    % bspline parameters
    if exist([syst.dir syst.sl 'tracked_Params' syst.sl 'b_Params.mat'],'file')==2
      load([syst.dir syst.sl 'tracked_Params' syst.sl 'b_Params.mat'])
    else
      
      % traking parameters
      track_Params.w_Size                 = 30;
      track_Params.Thresh                 = 70;
      track_Params.mun_Lim                = 20;
      track_Params.b_Spline.pred_Limit    = .01;
      track_Params.b_Spline.reg_Term      = 1e-3;
      track_Params.b_Spline.num_Basis     = 10;
      track_Params.b_Spline.order         = 3;
      track_Params.b_Spline.res           = 11;
      track_Params.b_Spline.extra         = 0;
      track_Params.b_Spline.type          = 'a-periodic-approx';
      
      % kalman filtering parameters
      track_Params.kalman.Q               = [1 1 1];
      track_Params.kalman.R               = [1 1 1];
      track_Params.kalman.order           = 1;
      
      % update b_Spline info on Data file
      Data.b_Spline                       = track_Params.b_Spline;
    end
    
    % b-spline object
    gui_States.b_Spline_Forward_Obj     = b_Splines_Class(track_Params.b_Spline, 0);
    gui_States.b_Spline_Backward_Obj    = b_Splines_Class(track_Params.b_Spline, 0);
    gui_States.params_Def               = 1;
    
    if exist(name_File, 'file') == 2
      update_Plot_Body();
    end
  end
  
else
  
  reset_Gui_States()
  set(gui_Tr.load_PushBotton, 'fontWeight', 'normal')
  set(gui_Tr.figure_Im, 'XData', [1 100], ...
    'YData', [1 100], 'CData', gui_States.Image)
  axis(gui_Tr.figure, gui_States.dimensions_Cropped)
  set(gui_Tr.GUI, 'name', '')
  
  % delete files
  file = [];
  Data = [];
  track_Params = [];
  
  % delete handles
  delete(gui_Tr.markers_Text_Plus)
  delete(gui_Tr.markers_Text_Minus)
  
end
end
function save_Callback(~,~)
global file
global Data
global syst
global track_Params

if ~(exist([syst.dir syst.sl 'tracked_Params' ],'file')==7)
  mkdir(syst.dir, 'tracked_Params' )
end

% name file data
name_File = [syst.dir syst.sl 'tracked_Params' syst.sl 'Params_Matrix'];

% name file of parameters
name_File_Params = [syst.dir syst.sl 'tracked_Params' syst.sl 'b_Params'];

% save name Data file
save(name_File, 'Data', 'file')
save(name_File_Params, 'track_Params')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% input callback %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function input_Spine(~,~)
global Data
global file
global gui_Tr


ind = (Data.frame_Index == file.range(2));

% update count
Data.count(ind) =  Data.count(ind) + 1;

% dependency placeholder
if isempty(Data.dep)
  Data.dep = 0;
else
  index_Last_Spine = find(Data.type == 0, 1,'last' ) ;
  Data.dep(Data.count(ind)) =  index_Last_Spine;
end

% type placeholder (0: spine, 1:limb)
Data.type(Data.count(ind)) = 0;

% radius placeholder
Data.radius(Data.count(ind)) =  1;

% defined
Data.def(ind) =  1;

% marker index
Data.Marker_Index(Data.count(ind)) = Data.count(ind);

% marker index class char
Data.Marker_ID{Data.count(ind)} = num2str(Data.count(ind));

% instantiate the data set
if ~isfield(Data.Predef_Cond, ['frame_' num2str(file.range(2))])
  if Data.frame_Tracked(ind)>0
    if Data.frame_Tracked(ind) == 2
      Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose = ...
        Data.Backward.pose(:,:,ind);
    else
      Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose = ...
        Data.Forward.pose(:,:,ind);
    end
  else
    Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose   = [];
  end
  Data.Filter.(['frame_' num2str(file.range(2))]).P = 1;
end

% pose placeholder
Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose(Data.count(ind),:) = ...
  [nan nan];

% update current axes
axes(gui_Tr.figure)
hold on
gui_Tr.markers_Text_Plus(Data.count(ind))...
  = text(nan, nan, num2str(Data.count(ind)),'visible', 'off');
gui_Tr.markers_Text_Minus(Data.count(ind))...
  = text(nan, nan, num2str(Data.count(ind)),'visible', 'off');
hold off

% point currently being evaluated
file.eval_At = Data.count(ind);

% input markers
input_Marker();

end
function input_Limb(~,~)
global Data
global file
global gui_Tr
%
if Data.count(file.range(2)) > 1
  ind = (Data.frame_Index == file.range(2));
  
  % update count
  Data.count(ind) =  Data.count(ind) + 1;
  
  % type placeholder (0: spine, 1:limb)
  Data.type(Data.count(ind)) = 1;
  
  % radius placeholder
  Data.radius(Data.count(ind)) =  1;
  
  % defined
  Data.def(ind) =  1;
  
  % marker index
  Data.Marker_Index(Data.count(ind)) = Data.count(ind);
  
  % marker index class char
  Data.Marker_ID{Data.count(ind)} = num2str(Data.count(ind));
  
  % instantiate the data set
  if ~isfield(Data.Predef_Cond, ['frame_' num2str(file.range(2))])
    if Data.frame_Tracked(ind)>0
      if Data.frame_Tracked(ind) == 2
        Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose = ...
          Data.Backward.pose(:,:,ind);
      else
        Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose = ...
          Data.Forward.pose(:,:,ind);
      end
    else
      Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose   = [];
    end
    Data.Filter.(['frame_' num2str(file.range(2))]).P = 1;
  end
  
  % pose placeholder
  Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose(Data.count(ind),:) = ...
    [nan nan];
  
  % dependency placeholder
  [x,y] = ginput(1);
  dist = sqrt(sum(bsxfun(@minus, ...
    Data.Forward.pose(:,:,ind),...
    [x,y]),2));
  [~, Data.dep(end+1)] = min(dist);
  
  % update current axes
  axes(gui_Tr.figure)
  hold on
  gui_Tr.markers_Text_Plus(Data.count(ind))...
    = text(nan, nan, num2str(Data.count(ind)),'visible', 'off');
  gui_Tr.markers_Text_Minus(Data.count(ind))...
    = text(nan, nan, num2str(Data.count(ind)),'visible', 'off');
  hold off
  
  % point currently being evaluated
  file.eval_At = Data.count(ind);
  
  % input markers
  input_Marker();
  
end
end
function correct(~,~)
global file
global gui_Tr
global Data
if ~isempty(file)
  
  % define index
  ind = Data.frame_Index == file.range(2);
  
  % extract correction number
  number = str2double(get(gui_Tr.t_Box_Input_Correct, 'string'));
  
  % grab all current info
  if (Data.frame_Tracked(ind) == 1) || (Data.frame_Tracked(ind) == 3)
    Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose = ...
      Data.Forward.pose(:,:,ind);
  elseif (Data.frame_Tracked(ind) == 2) || (Data.frame_Tracked(ind) == 3)
    Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose = ...
      Data.Backward.pose(:,:,ind);
  end
  
  % point currently being evaluated
  file.eval_At = number;
  
  input_Marker();
end
end
function input_Marker()
global gui_Tr
global gui_States
global track_Params
global file
global Data

[x, y] = ginput(1);
file.vec = boundary_Check(x, y, gui_Tr.figure);
%%%%%%%%%%%%%%%%%%%%%%%%%% keypress %%%%%%%%%%%%%%%%%%%%%%%%
% define radius
set(gui_Tr.GUI,'WindowButtonDownFcn'  ,@MouseKeyPressFcn_1_State);
set(gui_Tr.GUI,'WindowButtonUpFcn'    ,@MouseKeyPressFcn_1_EndState);
set(gui_Tr.GUI,'KeyPressFcn'          ,@KeyPressFcn_1_State);
colormap default

%%%%%%%%%%%%%%%%%%%%%%%%%% keypress %%%%%%%%%%%%%%%%%%%%%%%%
% set necessary handles
% apply visibility to plots
% % figure
set(gui_Tr.figure_Im                      , 'visible', 'off');
set(gui_Tr.markers_Forward_Spine          , 'visible', 'off');
set(gui_Tr.markers_Count_Forward_Spine     , 'visible', 'off');
set(gui_Tr.markers_Count_Forward_Limb     , 'visible', 'off');
set(gui_Tr.markers_Backward_Spine         , 'visible', 'off');
set(gui_Tr.markers_Count_Backward_Spine   , 'visible', 'off');
set(gui_Tr.markers_Count_Backward_Limb   , 'visible', 'off');
for m = 1:max(size(gui_Tr.markers_Text_Plus))
  set(gui_Tr.markers_Text_Plus(m) , 'visible', 'off');
end
for m = 1:max(size(gui_Tr.markers_Text_Minus))
  set(gui_Tr.markers_Text_Minus(m), 'visible', 'off');
end

% % zoomed in axis
set(gui_Tr.figure_Im_Zoom       , 'visible', 'on')
set(gui_Tr.plot_Center          , 'visible', 'on')
set(gui_Tr.plot_Circle          , 'visible', 'on')
set(gui_Tr.plot_Line            , 'visible', 'on')
set(gui_Tr.colorBar             , 'visible', 'on')

% % zoomed in axis
set(gui_Tr.figure_Im_Response   , 'visible', 'on')
set(gui_Tr.figure_Response_Title, 'visible', 'on')

% % zoomed in mesh response
set(gui_Tr.figure_Mesh_Mag      , 'visible', 'on')
set(gui_Tr.figure_Mag           , 'visible', 'on')

% apply hittest to axes handles
set(gui_Tr.figure_Zoom       , 'HitTest', 'on')
set(gui_Tr.figure_Response   , 'HitTest', 'on')
set(gui_Tr.figure_Mag        , 'HitTest', 'on')
set(gui_Tr.figure            , 'HitTest', 'off')

% update image
update_Plot(nan(1,2), nan(2,2))
set(gui_Tr.figure_Im_Zoom, ...
  'XData', file.dim_X, ...
  'YData', file.dim_Y, ...
  'CData', repmat(uint8(gui_States.I), [1 1 3]))
axis(gui_Tr.figure_Zoom, [ ...
  max(1, file.vec(1)-track_Params.w_Size) ...
  min(file.dim_X(end) , file.vec(1)+track_Params.w_Size) ...
  max(1, file.vec(2)-track_Params.w_Size) ...
  min(file.dim_Y(end) ,file.vec(2)+track_Params.w_Size)]);
set( gui_Tr.plot_Center, 'xdata',  x, 'ydata', y);

% force current frame to be defined as tracked
Data.frame_Tracked(Data.frame_Index==file.range(2)) = 3;
end
function remove_Marker_Plus(~,~)
global file
global gui_Tr
global Data

if ~isempty(file)
  % extract correction number
  number = str2double(get(gui_Tr.t_Box_Input_Remove, 'string'));
  if  isfield(Data.Forward, 'pose')
    Data.Forward.pose(number,:,find(Data.frame_Index == file.range(2)):end) ...
      = nan;
  end
  if  isfield(Data.Backward, 'pose')
    Data.Backward.pose(number,:,find(Data.frame_Index == file.range(2)):end) ...
      = nan;
  end
  %     % point currently being evaluated
  %     Data.def(number) = 0;
  
  % update the plot
  update_Limits_At();
end
end
function remove_Marker_Minus(~,~)
global file
global gui_Tr
global Data

if ~isempty(file)
  % extract correction number
  number = str2double(get(gui_Tr.t_Box_Input_Remove, 'string'));
  if  isfield(Data.Forward, 'pose')
    Data.Forward.pose(number,:,1:find(Data.frame_Index == file.range(2))) ...
      = nan;
  end
  if  isfield(Data.Backward, 'pose')
    Data.Backward.pose(number,:,1:find(Data.frame_Index == file.range(2))) ...
      = nan;
  end
  %     % point currently being evaluated
  %     Data.def(number) = 0;
  
  % update the plot
  update_Limits_At();
end
end
function check_Mark_Exist(~,~)
global file
global gui_Tr
global Data

%index
ind = Data.frame_Index == file.range(2);

if ~isempty(file)
  number = str2double(get(gui_Tr.t_Box_Input_Correct, 'string'));
  if number > Data.count(ind)
    set(gui_Tr.t_Box_Input_Correct, 'string', num2str(Data.count(ind)))
  elseif number < 1
    set(gui_Tr.t_Box_Input_Correct, 'string', num2str(1))
  end
end
end
function Reset_Markers(~,~)
global Data
global file

ind = Data.frame_Index == file.range(2);
if Data.count(ind) > 0
  if Data.count(ind) == 1
    Data.count(ind) = 0;
  else
    Data.count = Data.count - 1;
  end
  Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose(end,:) = [];
  Data.dep(end) = [];
  Data.Marker_ID(end) = [];
  Data.Marker_Index(end) = [];
  Data.radius(end) = [];
  Data.type(end) = [];
  Data.Forward.pose(end,:,:) = [];
  Data.Backward.pose(end,:,:) = [];
  Data.Forward.vel(end,:,:) = [];
  Data.Backward.vel(end,:,:) = [];
  Data.Forward.accel(end,:,:) = [];
  Data.Backward.accel(end,:,:) = [];
  update_Limits_At();
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% play callback %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function play_Callback(~,~)
global file
global gui_Tr
global gui_States
if ~isempty(file)
  
  if gui_States.play
    gui_States.play = 0;
  else
    gui_States.play = 1;
    if gui_States.rewind
      gui_States.rewind = 0;
    end
  end
  
  while gui_States.play && ~(file.range(2)==file.range(3))
    file.range(2) = file.range(2) + 1;
    update_Limits_At()
    if ~gui_States.display
      gui_Tr.figure_Im;
      pause(1/30)
    end
  end
  gui_States.play = 0;
  
end

end
function rewind_Callback(~,~)
global file
global gui_States
global gui_Tr

if ~isempty(file)
  
  if gui_States.rewind
    gui_States.rewind = 0;
  else
    gui_States.rewind = 1;
    if gui_States.play
      gui_States.play = 0;
    end
  end
  
  while gui_States.rewind && ~(file.range(2)==file.range(1))
    file.range(2) = file.range(2) - 1;
    update_Limits_At()
    if ~gui_States.display
      gui_Tr.figure_Im;
      pause(1/30)
    end
  end
  gui_States.rewind = 0;
end

end
function reset_Callback(~,~)
global file

if ~isempty(file)
  file.range(2) = file.range(1);
  update_Limits_At()
end
end
function next_Callback(~,~)
global file
if ~isempty(file)
  file.range(2) = file.range(2)+1;
  update_Limits_At()
end
end
function prev_Callback(~,~)
global file
if ~isempty(file)
  file.range(2) = file.range(2)-1;
  update_Limits_At()
end
end
function plot_Plus_Callback(~,~)
global file
global gui_States

if ~isempty(file)
  if gui_States.plot_Plus
    gui_States.plot_Plus = 0;
  else
    gui_States.plot_Plus = 1;
  end
  update_Visibility();
end
end
function plot_Minus_Callback(~,~)
global file
global gui_States

if ~isempty(file)
  if gui_States.plot_Minus
    gui_States.plot_Minus = 0;
  else
    gui_States.plot_Minus = 1;
  end
  update_Visibility();
end
end
function plot_Label_Callback(~,~)
global file
global gui_States

if ~isempty(file)
  if gui_States.plot_Label
    gui_States.plot_Label = 0;
  else
    gui_States.plot_Label = 1;
  end
  update_Visibility();
end
end
function update_Visibility()
global gui_States
global gui_Tr

% forward tracking visibility
if gui_States.plot_Plus
  set(gui_Tr.markers_Forward_Spine         , 'visible', 'on');
  set(gui_Tr.markers_Count_Forward_Spine   , 'visible', 'on');
  set(gui_Tr.markers_Count_Forward_Limb    , 'visible', 'on');
  if gui_States.plot_Label
    for m = 1:max(size(gui_Tr.markers_Text_Plus))
      set(gui_Tr.markers_Text_Plus(m) , 'visible', 'on');
      uistack(gui_Tr.markers_Text_Plus(m), 'top');
    end
  else
    for m = 1:max(size(gui_Tr.markers_Text_Plus))
      set(gui_Tr.markers_Text_Plus(m) , 'visible', 'off');
    end
  end
else
  set(gui_Tr.markers_Forward_Spine         , 'visible', 'off');
  set(gui_Tr.markers_Count_Forward_Spine   , 'visible', 'off');
  set(gui_Tr.markers_Count_Forward_Limb    , 'visible', 'off');
  for m = 1:max(size(gui_Tr.markers_Text_Plus))
    set(gui_Tr.markers_Text_Plus(m) , 'visible', 'off');
  end
end

% backward tracking visibility
if gui_States.plot_Minus
  set(gui_Tr.markers_Backward_Spine         , 'visible', 'on');
  set(gui_Tr.markers_Count_Backward_Spine   , 'visible', 'on');
  set(gui_Tr.markers_Count_Backward_Limb    , 'visible', 'on');
  if gui_States.plot_Label
    for m = 1:max(size(gui_Tr.markers_Text_Minus))
      set(gui_Tr.markers_Text_Minus(m) , 'visible', 'on');
      uistack(gui_Tr.markers_Text_Minus(m), 'top');
    end
  else
    for m = 1:max(size(gui_Tr.markers_Text_Minus))
      set(gui_Tr.markers_Text_Minus(m) , 'visible', 'off');
    end
  end
else
  set(gui_Tr.markers_Backward_Spine         , 'visible', 'off');
  set(gui_Tr.markers_Count_Backward_Spine   , 'visible', 'off');
  set(gui_Tr.markers_Count_Backward_Limb    , 'visible', 'off');
  for m = 1:max(size(gui_Tr.markers_Text_Minus))
    set(gui_Tr.markers_Text_Minus(m) , 'visible', 'off');
  end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% track callback %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function track_Plus_Callback(~,~)
global file
global gui_Tr
global gui_States
global Data

if ~isempty(file)
  
  dt = 1;
  
  if gui_States.track
    gui_States.track = 0;
  else
    gui_States.track = 1;
  end
  
  if  Data.frame_Tracked(Data.frame_Index == (file.range(2))) == 2
    Data.Backward.pose(:,:,Data.frame_Index == (file.range(2))) = ...
      Data.Forward.pose(:,:, Data.frame_Index == (file.range(2))) ;
    Data.Backward.vel(:,:,Data.frame_Index == (file.range(2))) = ...
      zeros(size(Data.Forward.vel(:,:, Data.frame_Index == (file.range(2))))) ;
    Data.Backward.accel(:,:,Data.frame_Index == (file.range(2))) = ...
      zeros(size(Data.Forward.accel(:,:, Data.frame_Index == (file.range(2)))));
    
    Data.frame_Tracked(Data.frame_Index == (file.range(2))) = 3;
  end
  
  while gui_States.track && ~(file.range(2)==file.range(3))
    file.range(2) = file.range(2) + dt;
    
    % evaluate the current frame
    track_From_Current(dt);
    
    % update current frame on buffer
    update_Limits_At();
    
    if ~gui_States.display
      gui_Tr.figure_Im;
    end
  end
  gui_States.track = 0;
end
end
function track_Minus_Callback(~,~)
global file
global gui_Tr
global gui_States
global Data

if ~isempty(file)
  
  dt = -1;
  
  if gui_States.track
    gui_States.track = 0;
  else
    gui_States.track = 1;
  end
  
  if  Data.frame_Tracked(Data.frame_Index == (file.range(2))) == 1
    Data.Backward.pose(:,:,Data.frame_Index == (file.range(2))) = ...
      Data.Forward.pose(:,:, Data.frame_Index == (file.range(2))) ;
    Data.Backward.vel(:,:,Data.frame_Index == (file.range(2))) = ...
      zeros(size(Data.Forward.vel(:,:, Data.frame_Index == (file.range(2))))) ;
    Data.Backward.accel(:,:,Data.frame_Index == (file.range(2))) = ...
      zeros(size(Data.Forward.accel(:,:, Data.frame_Index == (file.range(2))) ));
    
    Data.frame_Tracked(Data.frame_Index == (file.range(2))) = 3;
  end
  
  while gui_States.track && ~(file.range(2)==file.range(1))
    
    file.range(2) = file.range(2) + dt;
    
    % evaluate the current frame
    track_From_Current(dt);
    
    % update current frame on buffer
    update_Limits_At();
    
    if ~gui_States.display
      gui_Tr.figure_Im;
    end
    
  end
  gui_States.track = 0;
end
end
function params_Callback(~,~)
global gui_States
global gui_Tr
pose =  get(gui_Tr.GUI, 'position');
if gui_States.params_Def
  dims = [pose(1)+pose(3) pose(2)];
  params_GUI([.12 .40], dims);
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% update limits %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_Limits_At()
global file
global gui_Tr
global gui_States

% limits applied
file.range(2) = min(max(file.range(2), file.range(1)), file.range(3));
set(gui_Tr.t_Box_Input_AT , 'string', num2str(file.range(2)));

% load updated image
load_Img(file.range(2));

if gui_States.display
  display_At();
end

end
function update_Limits(~,~)
global file
global gui_Tr
global gui_States

if ~isempty(file)
  % video values
  num_down = str2double(get(gui_Tr.t_Box_Input_Init, 'string'));
  num_mid  = str2double(get(gui_Tr.t_Box_Input_AT  , 'string'));
  num_up   = str2double(get(gui_Tr.t_Box_Input_End , 'string'));
  
  if isempty(num_down)
    file.range(1) = 0;
  else
    file.range(1) = num_down;
  end
  
  if isempty(num_mid)
    file.range(2) = 0;
  else
    file.range(2) = num_mid;
  end
  
  if isempty(num_up)
    file.range(3) = 0;
  else
    file.range(3) = num_up;
  end
  
  % limits applied
  file.range(3) = max(file.range(3), file.range(1));
  file.range(1) = min(file.range(3), file.range(1));
  file.range(2) = min(max(file.range(2), file.range(1)), file.range(3));
  
  set(gui_Tr.t_Box_Input_Init, 'string', num2str(file.range(1)));
  set(gui_Tr.t_Box_Input_AT  , 'string', num2str(file.range(2)));
  set(gui_Tr.t_Box_Input_End , 'string', num2str(file.range(3)));
  
  % load updated image
  load_Img(file.range(2));
  
  if gui_States.display
    display_At()
  end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% display callback %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function display_Callback(~,~)
global file
global gui_States
global gui_Tr
global syst

if ~isempty(file)
  if gui_States.display == 0
    set(gui_Tr.load_PushBotton, 'fontWeight', 'bold')
    set(gui_Tr.figure_Im, 'XData', file.dim_X, ...
      'YData', file.dim_Y, ...
      'CData', uint8(repmat(gui_States.I,[1 1 3])))
    axis(gui_Tr.figure, [gui_States.dimensions_Cropped])
    gui_States.display = 1;
  else
    gui_States.Image = syst.default_Image;
    set(gui_Tr.load_PushBotton, 'fontWeight', 'normal')
    set(gui_Tr.figure_Im, 'XData', [1 100], ...
      'YData', [1 100],...
      'CData', gui_States.Image)
    axis(gui_Tr.figure,[1 100 1 100])
    gui_States.display = 0;
    
    % all the labels set to off
    
    set(gui_Tr.markers_Forward_Spine         , 'visible', 'off');
    set(gui_Tr.markers_Count_Forward_Spine   , 'visible', 'off');
    set(gui_Tr.markers_Count_Forward_Limb    , 'visible', 'off');
    for m = 1:max(size(gui_Tr.markers_Text_Plus))
      set(gui_Tr.markers_Text_Plus(m) , 'visible', 'off');
    end
    set(gui_Tr.markers_Backward_Spine         , 'visible', 'off');
    set(gui_Tr.markers_Count_Backward_Spine   , 'visible', 'off');
    set(gui_Tr.markers_Count_Backward_Limb    , 'visible', 'off');
    for m = 1:max(size(gui_Tr.markers_Text_Minus))
      set(gui_Tr.markers_Text_Minus(m) , 'visible', 'off');
    end
    
  end
end
end
function crop_Callback(~,~)
global gui_States
global gui_Tr
global file

if sum(file.dimensions==gui_States.dimensions_Cropped ,2) == 4
  val = ceil(getrect());
  % update windowed region
  gui_States.dimensions_Cropped([3 1]) = max(val([2 1]), [1 1]);
  gui_States.dimensions_Cropped([4 2]) =...
    min( [file.dim_Y(2), file.dim_X(2)] ,  -[1 1]+val([2 1]) ...
    +val([4 3]));
else
  gui_States.dimensions_Cropped=file.dimensions;
end
% apply cropping
axis(gui_Tr.figure, [gui_States.dimensions_Cropped])
end
function crop_Local_Callback(~,~)
global file
global gui_States

if ~isempty(file)
  if gui_States.crop
    gui_States.crop = 0;
  else
    gui_States.crop = 1;
  end
end
end
function b_Display_Callback(~,~)
global file
global gui_States
global gui_Tr

if ~isempty(file)
  if gui_States.b_Displ == 0
    gui_States.b_Displ = 1;
    set(gui_Tr.figure_B_1_Mag  , 'visible', 'on');
    set(get(gui_Tr.figure_B_1, 'title') ,'string', 'Detections')
    set(gui_Tr.figure_B_2_Mag  , 'visible', 'on');
    set(get(gui_Tr.figure_B_2, 'title') ,'string','Response')
    set(gui_Tr.figure_B_3_Mag  , 'visible', 'on');
    set(get(gui_Tr.figure_B_3, 'title') ,'string', 'Theshold')
  else
    gui_States.b_Displ = 0;
    set(gui_Tr.figure_B_1_Mag  , 'visible', 'off');
    set(get(gui_Tr.figure_B_1, 'title') ,'string', ' ')
    set(gui_Tr.figure_B_2_Mag  , 'visible', 'off');
    set(get(gui_Tr.figure_B_2, 'title') ,'string', ' ')
    set(gui_Tr.figure_B_3_Mag  , 'visible', 'off');
    set(get(gui_Tr.figure_B_3, 'title') ,'string', ' ')
    set(gui_Tr.plot_B_1   , 'Xdata', nan, 'Ydata', nan);
    set(gui_Tr.plot_B_1_C , 'Xdata', nan, 'Ydata', nan);
  end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%% keypress Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function KeyPressFcn_0_State( ~, event)
% global gui_Tr
event.Key
if isempty(event.Modifier)
  switch event.Key
    case 'p'
      play_Callback()
    case 'l'
      display_Callback()
    case 'o'
      rewind_Callback()
    case 'r'
      next_Callback()
    case 'hyphen'
      prev_Callback()
    case '0'
      reset_Callback()
    case 'c'
      crop_Callback()
    case 't'
      input_Spine()
    case 'x'
      input_Limb()
    case 'e'
      correct()
    case 'period'
      track_Plus_Callback()
    case 'comma'
      track_Minus_Callback
    case 'semicolon'
      plot_Callback()
  end
elseif strcmp(event.Modifier, 'shift')
  switch event.Key
    case 't'
      %             rem_Spine_Callback()
      disp('subtract')
  end
  
end
end
function KeyPressFcn_1_State( ~, event)

global Data
global gui_Tr
global track_Params
global file

switch event.Key
  case 'y'
    vec = get(gui_Tr.figure_Mesh_Mag, 'ZData');
    [~,ind] = max(vec(:));
    [y,x] = ind2sub((2*track_Params.w_Size+1)*[1 1], ind);
    xy = file.vec - [track_Params.w_Size track_Params.w_Size] + [x, y];
    % grab line handle
    lin = [get(gui_Tr.plot_Line, 'XData') ; get(gui_Tr.plot_Line, 'YData') ] ;
    
    % update end point
    lin =  [ xy(1,1:2)'  xy(1,1:2)'+(lin(:,2)- lin(:,1))];
    update_Plot(xy, lin);
  case 't'
    %%% keypress %%%%%%%%%%%%%%%%%%%%%%%%
    % define radius
    set(gui_Tr.GUI,'KeyPressFcn'          ,@KeyPressFcn_0_State);
    colormap gray
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% keypress %%%%%%%%%%%%%%%%%%%%%%%%
    % set necessary handles
    % apply visibility to plots
    % % figure
    set(gui_Tr.figure_Im            , 'visible', 'on')
    update_Visibility();
    
    % % zoomed in axis
    set(gui_Tr.figure_Im_Zoom       , 'visible', 'off')
    set(gui_Tr.plot_Center          , 'visible', 'off')
    set(gui_Tr.plot_Circle          , 'visible', 'off')
    set(gui_Tr.plot_Line            , 'visible', 'off')
    set(gui_Tr.colorBar             , 'visible', 'off')
    
    % % zoomed in axis
    set(gui_Tr.figure_Im_Response   , 'visible', 'off')
    set(gui_Tr.figure_Response_Title, 'visible', 'off')
    
    % % zoomed in mesh response
    set(gui_Tr.figure_Mesh_Mag      , 'visible', 'off')
    set(gui_Tr.figure_Mag           , 'visible', 'off')
    
    % apply hittest to axes handles
    set(gui_Tr.figure_Zoom       , 'HitTest', 'off')
    set(gui_Tr.figure_Response   , 'HitTest', 'off')
    set(gui_Tr.figure_Mag        , 'HitTest', 'off')
    set(gui_Tr.figure            , 'HitTest', 'on')
    
    % apply answer to input
    ln = [get(gui_Tr.plot_Line, 'XData') ; ...
      get(gui_Tr.plot_Line, 'YData') ] ;
    
    % update state vectors
    Data.Predef_Cond.(['frame_' num2str(file.range(2))]).pose(file.eval_At, :) ...
      = [get( gui_Tr.plot_Center, 'xdata') get( gui_Tr.plot_Center, 'ydata')];
    %         Data.def(Data.frame_Index == file.range(2)) = 1;
    Data.radius(file.eval_At)   = max(1,norm(ln(:,1)-ln(:,2)));
    
    % update Data
    update_Dimension_Data()
    
    % update the plot
    update_Limits_At();
end
end
% mouse button callbacks
function MouseKeyPressFcn_1_State(fh,~)
global gui_Tr
switch get(gcf,'SelectionType')
  case 'normal'
    xy =  get(gui_Tr.figure_Zoom,'Currentpoint');
    xy = xy(1,1:2)';
    lin = [get(gui_Tr.plot_Line, 'XData') ; get(gui_Tr.plot_Line, 'YData') ] ;
    if sum(isnan(lin(:)))>1
      lin =  [ xy  xy];
    else
      lin =  [ xy  xy+(lin(:,2)- lin(:,1))];
    end
    set(fh,'WindowButtonMotionFcn',@Fcn_Center);
    update_Response(xy, lin);
  case 'alt'
    xy = [ get(gui_Tr.plot_Center,'XData') ; ...
      get(gui_Tr.plot_Center,'YData')];
    xy_0 =  get(gui_Tr.figure_Zoom,'Currentpoint');
    
    lin = [get(gui_Tr.plot_Line, 'XData') ; get(gui_Tr.plot_Line, 'YData') ] ;
    
    if sum(isnan(lin(:)))>1
      lin =  [xy  xy_0(1,1:2)'];
    else
      lin(:,2) =  xy_0(1,1:2)';
    end
    
    % update end point
    set(gui_Tr.plot_Line, 'XData', lin(1,:), 'YData', lin(2,:))
    set(fh, 'WindowButtonMotionFcn', @Fcn_Radius);
    update_Response(xy, lin);
end
end
function MouseKeyPressFcn_1_EndState(fh,~)

set(fh,'WindowButtonMotionFcn',[]);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% point selection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Fcn_Center(~,~)
global gui_Tr
% grab end point
xy =  get(gui_Tr.figure_Zoom,'Currentpoint');
xy =  boundary_Check(xy(1,1), xy(1,2), gui_Tr.figure_Zoom);

% grab line handle
lin = [get(gui_Tr.plot_Line, 'XData') ; get(gui_Tr.plot_Line, 'YData') ] ;

% update end point
lin =  [ xy(1,1:2)'  xy(1,1:2)'+(lin(:,2)- lin(:,1))];

% update line handle
update_Plot(xy, lin)
end
function Fcn_Radius(~,~)
global gui_Tr
xy = [ get(gui_Tr.plot_Center,'XData') ; ...
  get(gui_Tr.plot_Center,'YData')];
% grab end point
xy_0 =  get(gui_Tr.figure_Zoom,'Currentpoint');
xy_0 =  boundary_Check(xy_0(1,1), xy_0(1,2), gui_Tr.figure_Zoom);

% grab line handle
lin = [get(gui_Tr.plot_Line, 'XData') ; get(gui_Tr.plot_Line, 'YData') ] ;

% update end point
lin(:, end)=  xy_0';

% update line handle
update_Response(xy, lin)

end
function update_Plot(xy, lin)
global gui_Tr
% update all plot handle associated with blob radius selection
set( gui_Tr.plot_Center, 'xdata', xy(1), 'ydata', xy(2));
set(gui_Tr.plot_Circle , 'xdata', xy(1) + norm(lin(:,1)-lin(:,2))*cos(getappdata(gui_Tr.figure_Im_Zoom, 'circ_Params')),...
  'ydata',xy(2) + norm(lin(:,1)-lin(:,2))*sin(getappdata(gui_Tr.figure_Im_Zoom, 'circ_Params')));
set(gui_Tr.plot_Line , 'xdata',lin(1,:),'ydata',lin(2,:));

end
function update_Response(xy, ln)
global file
global gui_Tr
global gui_States
global track_Params

% update response.
sigma = max(1, 1/sqrt(2)*(norm(ln(:,1)-ln(:,2))));
JJ = norn_Im( gui_States.I( ...
  max(1,floor(file.vec(2)-track_Params.w_Size)):...
  min(file.dimensions(2),floor(file.vec(2)+track_Params.w_Size)),...
  max(1,floor(file.vec(1)-track_Params.w_Size)):...
  min(file.dimensions(4),floor(file.vec(1)+track_Params.w_Size))));
res =   conv_FFT(JJ, ...
  sigma*fspecial('log', size(JJ), sigma ));
set(gui_Tr.figure_Im_Response,'XData',[1 size(res,1)] ,'YData' ,[1 size(res,2)] , 'CData', res);
axis(gui_Tr.figure_Response,[1 size(res,1) 1 size(res,2)] )
set(gui_Tr.figure_Mesh_Mag, 'ZData', norn_Im(res));
set(gui_Tr.figure_Response_Title, 'string', ['Response: r = ' num2str(max(norm(ln(:,1)-ln(:,2)), 1 ))] )
update_Plot(xy, ln);
end
%%%%%%%%%%%%%%%%%%%%%%%%%% Tracker Funtions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tracking portion
function track_From_Current(dt)
global file
global Data
global gui_States
global track_Params
global Filt

% check exist
if ~Data.def(Data.frame_Index == file.range(2))
  if Data.frame_Tracked(Data.frame_Index == (file.range(2)-dt))>0
    
    % get index of current frame
    ind =(Data.frame_Index == (file.range(2)-dt));
    ind_At =(Data.frame_Index == (file.range(2)));
    ind_Spine = (Data.type == 0);
    ind_Limb  = (Data.type == 1);
    
    % update count
    Data.count(ind_At) = Data.count(ind);
    
    % load future image
    load_Img(file.range(2))
    
    % get prediction
    if dt == 1
      % identify excluded markers
      ind_Nan = ~isnan(Data.Forward.pose(:,1,ind_At));
      % apply prediction
      vec_Pred = flipud(gui_States.b_Spline_Forward_Obj.eval_Pred(...
        linspace(0,1, sum(ind_Spine.*ind_Nan')), ...
        track_Params.b_Spline.pred_Limit)...
        *gui_States.b_Spline_Forward_Obj.basis_Coeff');
      vec_Pred = [ vec_Pred; Data.Forward.pose(ind_Limb,:,ind_At)];
    else
      % identify excluded markers
      ind_Nan = ~isnan(Data.Backward.pose(:,1,ind_At));
      % apply prediction
      vec_Pred = gui_States.b_Spline_Backward_Obj.eval_Pred(...
        linspace(0, 1, sum(ind_Spine.*ind_Nan')), ...
        track_Params.b_Spline.pred_Limit)...
        *gui_States.b_Spline_Backward_Obj.basis_Coeff';
      vec_Pred = [ vec_Pred; Data.Backward.pose(ind_Limb,:,ind_At)];
    end
    
    % id step with local exclusion region
    pts_Obs = Id_Per_Parts_v2(dt, vec_Pred, gui_States.b_Displ);
    
    % id step with local exclusion region
    switch track_Params.kalman.order
      case 1
        Filt.A = 1;
        Filt.C = 1;
        Filt.Q = track_Params.kalman.Q(1);
        Filt.R = track_Params.kalman.R(1);
        if size(Data.Filter.(['frame_' num2str(file.range(2)-dt)]).P,1) == 1
          Filt.P_0 = Data.Filter.(['frame_' num2str(file.range(2)-dt)]).P;
        else
          Filt.P_0 = 1;
        end
      case 2
        Filt.A = eye(2);
        Filt.A(1,2) = 1;
        Filt.C = eye(2);
        Filt.Q = diag(track_Params.kalman.Q(1:2));
        Filt.R = diag(track_Params.kalman.R(1:2));
        if size(Data.Filter.(['frame_' num2str(file.range(2)-dt)]).P,1) == 2
          Filt.P_0 = Data.Filter.(['frame_' num2str(file.range(2)-dt)]).P;
        else
          Filt.P_0 = eye(2);
        end
      case 3
        Filt.A = eye(3);
        Filt.A([4 8]) = 1;
        Filt.A(7) = 1/2;
        Filt.C = eye(3);
        Filt.Q = diag(track_Params.kalman.Q(1:3));
        Filt.R = diag(track_Params.kalman.R(1:3));
        if size(Data.Filter.(['frame_' num2str(file.range(2)-dt)]).P,1) == 3
          Filt.P_0 = Data.Filter.(['frame_' num2str(file.range(2)-dt)]).P;
        else
          Filt.P_0 = eye(3);
        end
    end
    
    % predicted estimation covariance
    Filt.P = Filt.A * Filt.P_0 * Filt.A' + Filt.Q;
    
    % setup state vector
    switch dt
      case 1
        State = construct_State_Vector(Data.Forward, ind_Nan, ind);
        Data.Forward.pose(:,:,ind_At)   = Data.Forward.pose(:,:,ind);
        Data.Forward.vel(:,:,ind_At)    = Data.Forward.vel(:,:,ind);
        Data.Forward.accel(:,:,ind_At)  = Data.Forward.accel(:,:,ind);
      case -1
        State = construct_State_Vector(Data.Backward, ind_Nan, ind);
        Data.Backward.pose(:,:,ind_At)  = Data.Backward.pose(:,:,ind);
        Data.Backward.vel(:,:,ind_At)   = Data.Backward.vel(:,:,ind);
        Data.Backward.accel(:,:,ind_At) = Data.Backward.accel(:,:,ind);
    end
    
    % apply prediction to state
    State_Pred = apply_Prediction_Vec(State);
    
    % get Kalman Gain
    kal_Gain();
    
    % solve for correspondence
    vec_Obs = hungarian_Kal_Solve_Per(State, State_Pred, pts_Obs);
    
    % apply kalman filter
    vec_Est = apply_Kal_Vec(vec_Obs, State_Pred);
    
    % update Data
    Data.Filter.(['frame_' num2str(file.range(2))]).P = Filt.P;
    
    switch dt
      case 1
        Data.Forward = ...
          deconstruct_State_Vector(Data.Forward, vec_Est, vec_Obs, ind_Nan, ind_At);
        if Data.frame_Tracked(Data.frame_Index == (file.range(2))) == 2
          Data.frame_Tracked(Data.frame_Index == (file.range(2))) = 3;
        elseif  Data.frame_Tracked(Data.frame_Index == (file.range(2))) == 0
          Data.frame_Tracked(Data.frame_Index == (file.range(2))) = 1;
        end
        
      case -1
        Data.Backward = ...
          deconstruct_State_Vector(Data.Backward, vec_Est, vec_Obs, ind_Nan, ind_At);
        if Data.frame_Tracked(Data.frame_Index == (file.range(2))) == 1
          Data.frame_Tracked(Data.frame_Index == (file.range(2))) = 3;
        elseif  Data.frame_Tracked(Data.frame_Index == (file.range(2))) == 0
          Data.frame_Tracked(Data.frame_Index == (file.range(2))) = 2;
        end
    end
    
  end
end
end
function vec = apply_Prediction_Vec(vec)
global Filt
global track_Params

switch track_Params.kalman.order
  case 1
    vec    = Filt.A*vec(1,:);
  case 2
    vec    = Filt.A*vec(1:2,:);
  case 3
    vec    = Filt.A*vec(1:3,:);
end

end
function vec_Est = apply_Kal_Vec(vec_Obs, vec_Pred)
global Filt
global track_Params

% difference in observation and state
switch track_Params.kalman.order
  case 1
    y = Filt.C*([vec_Obs(:,1)' vec_Obs(:,4)'] - vec_Pred);
  case 2
    y = Filt.C*([[vec_Obs(:,1)' vec_Obs(:,4)'] ;...
      [vec_Obs(:,2)' vec_Obs(:,5)']]  - vec_Pred);
  case 3
    y = Filt.C*([[vec_Obs(:,1)' vec_Obs(:,4)'] ;...
      [vec_Obs(:,2)' vec_Obs(:,5)'] ;...
      [vec_Obs(:,3)' vec_Obs(:,6)']]  - vec_Pred);
end

% correct first moment
vec_Est = (vec_Pred + Filt.K*y);
% correct second moment
Filt.P = (eye(size(Filt.P)) - Filt.K*Filt.C)*Filt.P;
end
function state = deconstruct_State_Vector(state, vec_Est, vec_Obs, ind_Nan, ind_At)
global track_Params


num = length(vec_Est)/2;

switch track_Params.kalman.order
  case 1
    state.vel(ind_Nan,:,ind_At)   = vec_Obs(:,[2 5]);
    state.accel(ind_Nan,:,ind_At) = vec_Obs(:,[3 6]);
  case 2
    vec = [vec_Est(2,1:num)' vec_Est(2,num+1:end)'];
    state.vel(ind_Nan,:,ind_At)   =  vec;
    state.accel(ind_Nan,:,ind_At) = vec_Obs(:,[3 6]);
  case 3
    vec = [vec_Est(2,1:num)' vec_Est(2,num+1:end)'];
    state.vel(ind_Nan,:,ind_At)   =  vec;
    vec = [vec_Est(3,1:num)' vec_Est(3,num+1:end)'];
    state.accel(ind_Nan,:,ind_At) =  vec;
end

vec = [vec_Est(1,1:num)' vec_Est(1,num+1:end)'];
state.pose(ind_Nan,:,ind_At) = vec;

end
% setup vector to solve for
function vec = construct_State_Vector(state, ind_Nan, ind)
val = 2*size(state.pose(ind_Nan,:,ind),1);
vec = [reshape(state.pose(ind_Nan,:,ind), [val, 1])'; ...
  reshape(state.vel(ind_Nan,:,ind), [val, 1])'; ...
  reshape(state.accel(ind_Nan,:,ind),[val, 1])'];
end
function kal_Gain()
global Filt

S = Filt.C*Filt.P*Filt.C' + Filt.R;
Filt.K = Filt.P*Filt.C'*S^-1;                     % kalman gain
end
%%%%%%%%%%%%%%%%%%%%%%%%%%% helper Funtions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function load_Img(n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ld_Img %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to load image
%
% allows for the loading of jpeg and jpg images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global file
global syst
global gui_States

if exist([syst.dir syst.sl file.name '_' num2str(n) '.' file.im_Type ], 'file') == 2
  gui_States.I = imread([syst.dir syst.sl file.name '_' num2str(n) '.' file.im_Type]);
  file.dim_X = [1 size(gui_States.I,2)];
  file.dim_Y = [1 size(gui_States.I,1)];
else
  fprintf('file not there \n')
  return
end

if size(gui_States.I,3) == 1
  gui_States.I = flipud(double(gui_States.I));
else
  gui_States.I = flipud(double(rgb2gray(gui_States.I)));
end

end
% boundary check
function vec = boundary_Check(val_x, val_y, handle)
ax = axis(handle);
val_x = min(max(val_x, ax(1)), ax(2));
val_y = min(max(val_y, ax(3)), ax(4));
vec = [val_x, val_y];
end
% conv through fft
function resp = conv_FFT(I,kern)
resp = fftshift(ifft2(fft2(norn_Im(I)).* ...
  fft2(kern)));
end
% update dimension of data
function update_Dimension_Data()
global Data
global file

ind = (Data.frame_Index == file.range(2));

% placeholder
% % position placeholder
forward.pose  = zeros(Data.count(ind), 2, length(Data.frame_Index));
backward.pose = zeros(Data.count(ind), 2, length(Data.frame_Index));
% % velocity placeholder
forward.vel  = zeros(Data.count(ind), 2, length(Data.frame_Index));
backward.vel = zeros(Data.count(ind), 2, length(Data.frame_Index));
% % acceleration placeholder
forward.accel  = zeros(Data.count(ind), 2, length(Data.frame_Index));
backward.accel = zeros(Data.count(ind), 2, length(Data.frame_Index));

if ~isempty(Data.Forward.pose)
  
  % index forward and backward
  ind_Forward  = or((Data.frame_Tracked == 1),(Data.frame_Tracked == 3));
  ind_Backward = or((Data.frame_Tracked == 2),(Data.frame_Tracked == 3));
  
  % place
  % % position place
  forward.pose(1:size(Data.Forward.pose,1),:,ind_Forward) =...
    Data.Forward.pose(:,:,ind_Forward);
  backward.pose(1:size(Data.Backward.pose,1),:,ind_Backward) =...
    Data.Backward.pose(:,:,ind_Backward);
  
  % % velocity place
  forward.vel(1:size(Data.Forward.vel,1),:,ind_Forward) =...
    Data.Forward.vel(:,:,ind_Forward);
  backward.vel(1:size(Data.Backward.vel,1),:,ind_Backward) =...
    Data.Backward.vel(:,:,ind_Backward);
  
  % % acceleration place
  forward.accel(1:size(Data.Forward.accel,1),:,ind_Forward) =...
    Data.Forward.accel(:,:,ind_Forward);
  backward.accel(1:size(Data.Backward.accel,1),:,ind_Backward) =...
    Data.Backward.accel(:,:,ind_Backward);
end

% Data.Predef_Cond
names = fieldnames(Data.Predef_Cond);
for m = 1:max(size(names))
  val = str2double(names{m}(7:end));
  dimX = size(Data.Predef_Cond.(['frame_' num2str(val)]).pose,1);
  forward.pose(1:dimX,:,(Data.frame_Index == val)) = ...
    Data.Predef_Cond.(['frame_' num2str(val)]).pose;
  backward.pose(1:dimX,:,(Data.frame_Index == val)) = ...
    Data.Predef_Cond.(['frame_' num2str(val)]).pose;
  
  if m > 1
    forward.pose(dimX_Hold+1:end,:,1:find(Data.frame_Index == (val-1)))  = nan;
    backward.pose(dimX_Hold+1:end,:,1:find(Data.frame_Index == (val-1))) = nan;
  else
    if find(Data.frame_Index == val) > 1
      forward.pose(1:dimX,:,1:find(Data.frame_Index == (val-1)))  = nan;
      backward.pose(1:dimX,:,1:find(Data.frame_Index == (val-1))) = nan;
    end
  end
  
  %     if dimX < Data.count
  %         Data.Predef_Cond.(['frame_' num2str(val)]).pose(end +
  %         (Data.count-dimX),1) = nan;
  
  forward.pose(dimX+1:end,:,(Data.frame_Index == (val)))  = nan;
  backward.pose(dimX+1:end,:,(Data.frame_Index == (val))) = nan;
  %     end
  dimX_Hold = dimX;
  
end

% update placeholders
Data.Forward  = forward;
Data.Backward = backward;

clear forward backward
end
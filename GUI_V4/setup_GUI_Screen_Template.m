function d = setup_GUI_Screen_Template( s_Per, x_d, y_d)

if nargin<3
    y_d = 0;
end
if nargin<2
    x_d = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% s_Per: Screen Coverage percentage
% num: figure number
% Author: Miguel Serrano
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Screen Coverage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<1
    s_Per = .8;
end
if max(size(s_Per)) == 1
    s_Per = [s_Per s_Per];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Construct Figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<2
    num = 1;
end

% construct figure

% get screen resolution
s_Dim = get(0, 'MonitorPositions');
s_Dim = s_Dim(find((s_Dim(:,1)==1)|(s_Dim(:,1)==0)),:);
x_s_Dim = s_Dim(3)-1;
y_s_Dim = s_Dim(4)-1;

% apply dimensions
pose = [20+x_d y_d...
    floor(x_s_Dim*s_Per(1)) floor(y_s_Dim*s_Per(2))] ;

d = figure( 'windowstyle', 'normal', 'resize', 'on' , 'position', pose );
end
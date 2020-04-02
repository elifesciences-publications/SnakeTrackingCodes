function [pose, d] = setup_GUI_Screen(s_Per)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% s_Per: Screen Coverage percentage
% num: figure number
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
if ismac()
  s_Dim = s_Dim(find(s_Dim(:,1)==0),:);
else
  s_Dim = s_Dim(find(s_Dim(:,1)==1),:);
end
x_s_Dim = s_Dim(3)-1;
y_s_Dim = s_Dim(4)-1;

% apply dimensions
pose = [floor(x_s_Dim*(1-s_Per(1))/10+1+s_Dim(1)) floor(y_s_Dim*(1-s_Per(2))/2+1+s_Dim(2)) ...
    floor(x_s_Dim*s_Per(1)) floor(y_s_Dim*s_Per(2))] ;

d = figure( 'windowstyle', 'normal', 'resize', 'on' , 'position', pose );
end
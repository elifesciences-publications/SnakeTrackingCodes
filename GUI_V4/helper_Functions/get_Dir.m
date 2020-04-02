function [dr , sl] = get_Dir()

% returns the current directory with the correct slashing 
% mechanism

if isunix()
    sl = '/';
else
    sl = '\';
end

 a = cd;
 b = find(a==sl);

dr = [a(1:b(end-1)-1) sl 'data' sl];

end
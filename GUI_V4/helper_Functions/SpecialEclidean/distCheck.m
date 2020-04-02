v = [10,10,0; 10,-10,0; -10,-10,0; -10,10,0]*10;
[n1,n2] = size(v');
for n = 1:n2
vp(:,n) = rotation([pi/4 0 0])*v(n,:)' + [10;10;10];
end


mean(v)
mean(vp')
clear

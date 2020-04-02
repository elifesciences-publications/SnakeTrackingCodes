function r = hat(w)

if max(size(w)) == 3
r = [0 -w(3) w(2); w(3) 0 -w(1); -w(2) w(1) 0];
elseif max(size(w)) == 1
r = -[0 -w(1); w(1) 0];
    
end

end
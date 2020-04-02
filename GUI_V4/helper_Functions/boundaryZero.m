function b = boundaryZero(a, n)
if nargin < 2
    n = 1;
end

[n1,n2] = size(a);
b = zeros(n1,n2);
b((n+1:n1-n),(n+1:n2-n)) = a((n+1:n1-n),(n+1:n2-n));
end
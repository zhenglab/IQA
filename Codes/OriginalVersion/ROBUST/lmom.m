function [L] = lmom(X)

[rows cols] = size(X);
if cols == 1 X = X'; end
n = length(X);
X = sort(X);
b = zeros(1,3);
l = zeros(1,3);
b0 = mean(X);

for r = 1:3
    Num = prod(repmat(r+1:n,r,1)-repmat([1:r]',1,n-r),1);
    Den = prod(repmat(n,1,r) - [1:r]);
    b(r) = 1/n * sum( Num/Den .* X(r+1:n) );
end

L(1) = b0;
L(2) = 2*b(1) -b0;
L(3) = 6*b(2) - 6*b(1) + b0;
L(4) = 20*b(3)-30*b(2) + 12*b(1) - b0;

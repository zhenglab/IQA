function [gauDerX, gauDerY] = gauDerivative(sigma)

halfLength = ceil(3*sigma);
% gauDerX = zeros(halfLength*2+1, halfLength*2+1);
% gauDerY = gauDerX;
[x, y] = meshgrid(-halfLength:1:halfLength, -halfLength:1:halfLength);

gauDerX = x.* exp(-(x.^2 + y.^2)/2/sigma/sigma);
gauDerY = y.* exp(-(x.^2 + y.^2)/2/sigma/sigma);

% gauDerXX = exp(-(x.^2 + y.^2)/2/sigma/sigma).*(sigma^2 - x.^2);
% gauDerYY = exp(-(x.^2 + y.^2)/2/sigma/sigma).*(sigma^2 - y.^2);
% gauDerXY = exp(-(x.^2 + y.^2)/2/sigma/sigma).*x.*y;
% 
% gauDerXX = gauDerXX - mean2(gauDerXX);
% gauDerYY = gauDerYY - mean2(gauDerYY);
% gauDerXY = gauDerXY - mean2(gauDerXY);
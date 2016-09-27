tu1=imread('1.bmp');
tu2=imread('3.bmp');

tu1=im2double(tu1);
tu2=im2double(tu2);

r1=tu1(:,:,1);     %提取图像的R分量
g1=tu1(:,:,2);     %提取图像的g分量
b1=tu1(:,:,3);     %提取图像的b分量
r2=tu2(:,:,1);     %提取图像的R分量
g2=tu2(:,:,2);     %提取图像的g分量
b2=tu2(:,:,3);     %提取图像的b分量

d1=mean(mean((r1-r2).^2));                        %R分量的MSE
psnr1=10*log10(255*255/d1);                       %R分量的PSNR

d2=mean(mean((g1-g2).^2));                        %G分量的MSE
psnr2=10*log10(255*255/d2);                       %R分量的PSNR

d3=mean(mean((b1-b2).^2));                        %B分量的MSE
psnr3=10*log10(255*255/d3);                       %R分量的PSNR

psnr=(psnr1+psnr2+psnr3)/3                        %psnr为三个分量psnr的均值
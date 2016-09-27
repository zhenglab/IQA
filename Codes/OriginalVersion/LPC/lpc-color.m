close all
clear all 
clc
im = imread('E:\capture201601 - ¸±±¾\×é2\a(11).bmp');
imColor=double(im);
RChannel1 = imColor(:,:,1);
GChannel1 = imColor(:,:,2);
BChannel1 = imColor(:,:,3);

[X,Y]=size(RChannel1);
for i=1:X
    for j=1:Y
        m=RChannel1(i,j);
        n=GChannel1(i,j);
        c=BChannel1(i,j);
        B1=[0.3811,0.5783,0.0402;0.1967,0.7244,0.0782;0.0241,0.1288,0.8444]*[m;n;c];
        L1=B1(1);
        M1=B1(2);
        S1=B1(3);
        L1=log(L1);
        M1=log(M1);
        S1=log(S1);
        A1=[1/(3^0.5),0,0;0,1/(6^0.5),0;0,0,1/(2^0.5)]*[1,1,1;1,1,-2;1,-1,0]*[L1;M1;S1];
        intensity(i,j)=A1(1);
        alpha(i,j)=A1(2);
        betta(i,j)=A1(3);

    end   
end 
intensity =double(intensity);
alpha=double(alpha);
 betta=double(betta);
[si_intensity, lpc_map1] = lpc_si(intensity,[1 2 4], [1 -3 2], 2,1e-4,2,20);
[si_alpha, lpc_map2] = lpc_si(alpha,[1 2 4], [1 -3 2], 2,1e-4,4,20);
[si_betta, lpc_map3] = lpc_si(betta,[1 2 4], [1 -3 2], 2,1e-4,4,20);

w1=3.3;
w2=1.3;

w3=0.9;
im_quality=(w1*si_intensity^2+w2*si_alpha^2+w3*si_betta^2)^0.5   
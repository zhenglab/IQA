%=====================================================================
% File: JNBM_compute.m 
% Original code written by Rony Ferzli, IVU Lab (http://ivulab.asu.edu)
% Code modified by Lina Karam
% Last Revised: September 2009 by Lina Karam
%===================================================================== 
% Copyright Notice:
% Copyright (c) 2007-2009 Arizona Board of Regents. 
% All Rights Reserved.
% Contact: Lina Karam (karam@asu.edu) and Rony Ferzli (rony.ferzli@asu.edu)  
% Image, Video, and Usabilty (IVU) Lab, http://ivulab.asu.edu
% Arizona State University
% This copyright statement may not be removed from this file or from 
% modifications to this file.
% This copyright notice must also be included in any file or product 
% that is derived from this source file. 
% 
% Redistribution and use of this code in source and binary forms, 
% with or without modification, are permitted provided that the 
% following conditions are met:  
% - Redistribution's of source code must retain the above copyright 
% notice, this list of conditions and the following disclaimer. 
% - Redistribution's in binary form must reproduce the above copyright 
% notice, this list of conditions and the following disclaimer in the 
% documentation and/or other materials provided with the distribution. 
% - The Image, Video, and Usability Laboratory (IVU Lab, 
% http://ivulab.asu.edu) is acknowledged in any publication that 
% reports research results using this code, copies of this code, or 
% modifications of this code.  
% The code and our papers are to be cited in the bibliography as:
% R. Ferzli and L. J. Karam, "JNB Sharpness Metric Software", 
% http://ivulab.asu.edu 
%
% R. Ferzli and L. J. Karam, "A No-Reference Objective Image Sharpness 
% Metric Based on the Notion of Just Noticeable Blur (JNB)," IEEE 
% Transactions on Image Processing, vol. 18, no. 4, pp. 717-728, April 
% 2009.
%
% DISCLAIMER:
% This software is provided by the copyright holders and contributors 
% "as is" and any express or implied warranties, including, but not 
% limited to, the implied warranties of merchantability and fitness for 
% a particular purpose are disclaimed. In no event shall the Arizona 
% Board of Regents, Arizona State University, IVU Lab members, or 
% contributors be liable for any direct, indirect, incidental, special,
% exemplary, or consequential damages (including, but not limited to, 
% procurement of substitute goods or services; loss of use, data, or 
% profits; or business interruption) however caused and on any theory 
% of liability, whether in contract, strict liability, or tort 
% (including negligence or otherwise) arising in any way out of the use 
% of this software, even if advised of the possibility of such damage. 
% 
function [metric] = JNBM_compute(A)
%A = imfilter(A,1/9*ones(3,3));
beta = 3.6;
T = 0.002;
A = double(A);
[m,n] = size(A);
rb = 64;
rc = 64;
count = 1;

C=1:255;

widthjnb = [5*ones(1,60) 3*ones(1,30) 3*ones(1,180)];

for i=1:floor(m/rb)

    for j=1:floor(n/rc)
        row = rb*(i-1)+1:rb*i;
        col = rc*(j-1)+1:rc*j;
        A_temp = A(row,col);
        % check if block to be processed
        decision = get_edgeblocks_mod(A_temp,T);
        if (decision==1)
           local_width = edge_width(A_temp); 
           Ac_meas = blkproc(A_temp,[rb rc],@get_contrast_block);
           Ajnb = widthjnb(Ac_meas+1);
           temp(count) = sum(abs(local_width./Ajnb).^beta).^(1/beta);
           count = count + 1;
         end
    end
end

blockrow = floor(m/rb);
blockcol = floor(n/rc);
L = blockrow*blockcol;
metric = (L/(sum(temp.^beta).^(1/beta)));

% 
function [local] = edge_width(A)
% Compute edge width based on following paper:
% P. Marziliano, F. Dufaux, S. Winkler, and T. Ebrahimi, 
% “Perceptual blur and ringing metrics: Applications to JPEG2000,” 
% Signal Proc.: Image Comm., vol. 19, pp. 163–172, 2004.


A = double(A);
E = edge(A,'Sobel',[],'vertical');
%E = edge(A,'Sobel');
[Gx Gy] = gradient(A);
% Magnitude
graA = abs(Gx) + abs(Gy);
[M N] = size(A);
 for m=1:M
     for n=1:N
            if (Gx(m,n)~=0)
                angle_A(m,n) = atan2(Gy(m,n),Gx(m,n))*(180/pi); % in degrees
            end
            if (Gx(m,n)==0 && Gy(m,n)==0)
                angle_A(m,n) = 0;
            end
            if (Gx(m,n)==0 && Gy(m,n)==pi/2)
              angle_A(m,n) = 90;
            end
     end
 end
 
% quantize the angle 
angle_Arnd = 45*round(angle_A./45);
width_loc = [];
count = 0;
for m=2:M-1
    for n=2:N-1
        if (E(m,n)==1)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% If gradient = 0 %%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (angle_Arnd(m,n) ==180 || angle_A(m,n) ==-180)
                count = count + 1;
                    for k=0:100
                    posy1 = n-1 -k;
                    posy2 = n-2 -k;
                    if ( posy2<=0)
                        break;
                    end

                    if ((A(m,posy2) - A(m,posy1))<=0)
                        break;
                    end
                end
                width_count_side1 = k + 1 ;
                for k=0:100
                    negy1 = n+1 + k;
                    negy2 = n+2 + k;

                    if (negy2>N)
                        break;
                    end

                    if ((A(m,negy2) - A(m,negy1))>=0)
                        break;
                    end

                end
                width_count_side2 = k + 1 ;
                width_loc = [width_loc width_count_side1+width_count_side2];
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% If gradient = 0 %%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (angle_Arnd(m,n) ==0)
                count = count + 1;
                    for k=0:100
                    posy1 = n+1 +k;
                    posy2 = n+2 +k;
                    if ( posy2>N)
                        break;
                    end

                    if ((A(m,posy2) - A(m,posy1))<=0)
                        break;
                    end
                end
                width_count_side1 = k + 1 ;
                for k=0:100
                    negy1 = n-1 - k;
                    negy2 = n-2 - k;

                    if (negy2<=0)
                        break;
                    end

                    if ((A(m,negy2) - A(m,negy1))>=0)
                        break;
                    end

                end
                width_count_side2 = k + 1 ;
                width_loc = [width_loc width_count_side1+width_count_side2];
            end
        
          
        end
    end
end


local = width_loc;

%
function im_out = get_edgeblocks_mod(im_in,T)

im_in = double(im_in);

[im_in_edge,th] = edge(im_in,'canny');

[m,n] = size(im_in_edge);
L = m*n;
im_edge_pixels = sum(sum(im_in_edge));
im_out = im_edge_pixels > (L*T) ;

%
function contrast = get_contrast_block(A)

A = double(A);
[m,n] =size(A);
contrast = max(max(A)) - min(min(A));



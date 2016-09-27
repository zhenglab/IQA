%=====================================================================
% File: CPBD_compute.m 
% Original code written by Niranjan D. Narvekar
% IVU Lab (http://ivulab.asu.edu)
% Last Revised: October 2009 by Niranjan D. Narvekar
%===================================================================== 
% Copyright Notice:
% Copyright (c) 2009-2010 Arizona Board of Regents. 
% All Rights Reserved.
% Contact: Lina Karam (karam@asu.edu) and Niranjan D. Narvekar (nnarveka@asu.edu)  
% Image, Video, and Usabilty (IVU) Lab, ivulab.asu.edu
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
%
% The code and our papers are to be cited in the bibliography as:
%
% N.D. Narvekar and L. J. Karam, "CPBD Sharpness Metric Software", 
% http://ivulab.asu.edu/Quality/CPBD 
%
% N.D. Narvekar and L. J. Karam, "A No-Reference Perceptual Image Sharpness 
% Metric Based on a Cumulative Probability of Blur Detection," 
% International Workshop on Quality of Multimedia Experience (QoMEX 2009),
% pp. 87-91, July 2009.
%
% N. D. Narvekar and L. J. Karam, "An Improved No-Reference Sharpness Metric Based on the 
% Probability of Blur Detection," International Workshop on Video Processing and Quality Metrics 
% for Consumer Electronics (VPQM), http://www.vpqm.org, January 2010.
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function      : CPBD_compute
% description   : This function computes the CPBD metric which determines
%                 the amount of sharpness of the image. Larger the metric
%                 value, sharper the image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sharpness_metric] = CPBD_compute(input_image)

%%%%%%%%%%%% pre-processing %%%%%%%%%%%%
% convert to gray scale if color image
[x y z] = size(input_image);
if z > 1
    input_image = rgb2gray(input_image);
end
% convert the image to double for further processing
input_image = double(input_image);
% get the size of image
[m,n] = size(input_image);

%%%%%%%%%%%% parameters %%%%%%%%%%%%
% threshold to characterize blocks as edge/non-edge blocks
threshold = 0.002;
% fitting parameter
beta = 3.6;
% block size 
rb = 64;
rc = 64;
% maximum block indices 
max_blk_row_idx = floor(m/rb);
max_blk_col_idx = floor(n/rc);
% just noticeable widths based on the perceptual experiments
%widthjnb = [5*ones(1,57) 3*ones(1,200)];
widthjnb = [5*ones(1,51) 3*ones(1,205)];

%%%%%%%%%%%% initialization %%%%%%%%%%%%
% arrays and variables used during the calculations
total_num_edges = 0;
hist_pblur = zeros(1,101);
cum_hist = zeros(1,101);

%%%%%%%%%%%% edge detection %%%%%%%%%%%%
% edge detection using canny and sobel canny edge detection is done to 
% classify the blocks as edge or non-edge blocks and sobel edge 
% detection is done for the purpose of edge width measurement. 

input_image_canny_edge = edge(input_image,'canny');
input_image_sobel_edge = edge(input_image,'Sobel',[2],'vertical');

%%%%%%%%%%%% edge width calculation %%%%%%%%%%%%
[width] = marziliano_method(input_image_sobel_edge, input_image);

%%%%%%%%%%%% sharpness metric calculation %%%%%%%%%%%%
% loop over the blocks
for i=1:max_blk_row_idx
    for j=1:max_blk_col_idx
        
        % get the row and col indices for the block pixel positions
        rows = (rb*(i-1)+1):(rb*i);
        cols = (rc*(j-1)+1):(rc*j);
        % decide whether the block is an edge block or not
        decision = get_edge_blk_decision(input_image_canny_edge(rows,cols), threshold);
        
        % process the edge blocks 
        if (decision==1)
            
            % get the edge widths of the detected edges for the block
            local_width = width(rows,cols);
            local_width = local_width(local_width ~= 0);
            
            % find the contrast for the block
            blk_contrast = blkproc(double(input_image(rows,cols)),[rb rc],@get_contrast_block)+1;
            % get the block Wjnb based on block contrast
            blk_jnb = widthjnb(blk_contrast);
            % calculate the probability of blur detection at the edges
            % detected in the block
            prob_blur_detection = 1 - exp(-abs(local_width./blk_jnb).^beta);
            
            % update the statistics using the block information
            for k = 1:numel(local_width)
                % update the histogram
                temp_index = round(prob_blur_detection(k)* 100) + 1;
                hist_pblur(temp_index) = hist_pblur(temp_index) + 1;
                % update the total number of edges detected
                total_num_edges = total_num_edges + 1;
            end
        end
    end
end

% normalize the pdf
if(total_num_edges ~=0)
    hist_pblur = hist_pblur / total_num_edges;
else
    hist_pblur = zeros(size(hist_pblur));
end

% calculate the sharpness metric
sharpness_metric = sum(hist_pblur(1:64));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function      : marziliano_method
% description   : This function calculates the edge-widths of the detected
%                 edges and returns an matrix as big as the image with 0's
%                 at non-edge locations and edge-widths at the edge
%                 locations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [edge_width_map] = marziliano_method(E, A)

% edge_width_map consists of zero and non-zero values. A zero value 
% indicates that there is no edge at that position and a non-zero value 
% indicates that there is an edge at that position and the value itself 
% gives the edge width
edge_width_map = zeros(size(A));

% converting the image to type double
A = double(A);

% find the gradient for the image
[Gx Gy] = gradient(A);

% dimensions of the image
[M N] = size(A);

% initializing the matrix to empty which holds the angle information of the
% edges
angle_A = [];

% calculate the angle of the edges
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


if(numel(angle_A) ~= 0)
    
    % quantize the angle 
    angle_Arnd = 45*round(angle_A./45);

    count = 0;
    for m=2:M-1
        for n=2:N-1
            if (E(m,n)==1)
                
                %%%%%%%%%%%%%%%%%%%% If gradient angle = 180 or -180 %%%%%%%%%%%%%%%%%%%%%%
                if (angle_Arnd(m,n) ==180 || angle_Arnd(m,n) ==-180)
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
                  
                    edge_width_map(m,n) = width_count_side1+width_count_side2;

                end
                
                
                %%%%%%%%%%%%%%%%%%%% If gradient angle = 0 %%%%%%%%%%%%%%%%%%%%%%
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
                    edge_width_map(m,n) = width_count_side1+width_count_side2;
                end

            end
        end
    end
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function      : get_edge_blk_decision
% description   : Gives a decision whether the block is edge block or not.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [im_out] = get_edge_blk_decision(im_in,T)

[m,n] = size(im_in);
L = m*n;
im_edge_pixels = sum(sum(im_in));
im_out = im_edge_pixels > (L*T) ;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function      : get_contrast_block
% description   : Returns the contrast of the block.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function contrast = get_contrast_block(A)

A = double(A);
[m,n] =size(A);
% get constrast locally 
contrast = max(max(A)) - min(min(A));


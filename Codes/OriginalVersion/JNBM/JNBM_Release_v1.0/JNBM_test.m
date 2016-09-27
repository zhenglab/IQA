%=====================================================================
% File: JNBM_test.m 
% Original code written by Rony Ferzli, IVU Lab (http://ivulab.asu.edu)
% Code modified by Lina Karam
% Last Revised: September 2009 by Lina Karam
%===================================================================== 
% Copyright Notice:
% Copyright (c) 2007-2009 Arizona Board of Regents. 
% All Rights Reserved.
% Contact: Lina Karam (karam@asu.edu) and Rony Ferzli (rony.ferzli@asu.edu)  
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

clc;
clear all;

image_path = input('Enter image folder path (absolute or relative to current directory): ','s');

data_file = input('Enter excel data file name with extension and path (e.g., data.xlsx): ','s');

[num, txt] = xlsread(data_file);

image_number = txt(2:end,2);

metric_jnbm = zeros(1,numel(image_number));

for i = 1:numel(image_number)
    A = imread([image_path,char(image_number(i))]);
    A = imread(char(image_number(i)));
    A = rgb2gray(A);
    metric_jnbm(i) = JNBM_compute(A);
end

xlswrite('data.xlsx', metric_jnbm', 'S2:S51');

num = xlsread('data.xlsx');

mos_scores = num(:,16);
metric_jnbm = num(:,17);

[r1, rnonlinear1, rspear1, routlier1, rmse1, mae1] = evaluate_metric_performance(metric_jnbm, mos_scores, num(:,4:15));
disp('Pearson Linear Correlation Coefficient');
rnonlinear1
disp('Spearman Rank-Order Correlation Coefficient');
rspear1
disp('Root Mean Squared Error (RMSE)');
rmse1
disp('Mean Absolute Error (MAE)');
mae1
disp('Outlier Ratio');
routlier1






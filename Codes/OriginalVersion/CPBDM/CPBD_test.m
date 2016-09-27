%=====================================================================
% File: CPBD_test.m 
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
%   notice, this list of conditions and the following disclaimer. 
% - Redistribution's in binary form must reproduce the above copyright 
%   notice, this list of conditions and the following disclaimer in the 
%   documentation and/or other materials provided with the distribution. 
% - The Image, Video, and Usability Laboratory (IVU Lab, 
%   http://ivulab.asu.edu) is acknowledged in any publication that 
%   reports research results using this code, copies of this code, or 
%   modifications of this code.  
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

clc;
clear all;

image_path = input('Enter image folder path (absolute or relative to current directory): ','s');

is_MOS = input('Are the subjective scores Mean Opinion Scores (MOS) and not Difference MOS (DMOS)? (enter Y or N): ','s');

if(is_MOS == 'Y')
    i_is_mos = 1;
elseif(is_MOS == 'N')
    i_is_mos = 0;
else
    disp('Error: Please Enter Y or N. Try again.');
    return;
end

data_file = input('Enter excel data file name with extension and path (e.g., data.xls): ','s');

[num, txt] = xlsread(data_file);

image_number = txt(2:end,1);

metric_cpbd = zeros(1,numel(image_number));

for i = 1:numel(image_number)
    A = imread([image_path,char(image_number(i))]);
    A = rgb2gray(A);
    metric_cpbd(i) = CPBD_compute(A);
    disp([' image number ='])
    disp(i);
end

xlswrite(data_file, metric_cpbd', 'D2:D175');

num = xlsread(data_file);

std_dev = num(:,1);
mos_scores = num(:,2);
metric_cpbd = num(:,3);

[r, rnonlinear, rspear, routlier, rmse, mae] = evaluate_metric_performance(metric_cpbd, mos_scores, std_dev, i_is_mos);

disp('Pearson Linear Correlation Coefficient');
rnonlinear
disp('Spearman Rank-Order Correlation Coefficient');
rspear
disp('Root Mean Squared Error (RMSE)');
rmse
disp('Mean Absolute Error (MAE)');
mae
disp('Outlier Ratio');
routlier






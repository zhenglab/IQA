%=====================================================================
% File: evaluate_metric_performance.m
% Original code written by Rony Ferzli, IVU Lab (http://ivulab.asu.edu)
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


function [r,rnonlinear, rspear, routlier,rmse,mae] = evaluate_metric_performance(x, y, std_blur, is_MOS)

% if the scores are DMOS, then use (1-cpbd_score) to evaluate the
% correlation
if(is_MOS == 0)
    x = 1-x;
end

N = length(y);
meanx = mean(x);
meany = mean(y);
numtest = sum((x-meanx).*(y-meany));
dentest = sqrt(sum((x-meanx).^2))*sqrt(sum((y-meany).^2));
r = numtest/dentest;

% Non-linear Pearson
options = optimset('MaxIter', 2000, 'TolFun', 1e-6,'Display','off');
[beta,r,J] = nlinfit(x,y,@logistic_fun,[max(y) min(y) mean(x) 1],options);
MOSp = ((beta(1) - beta(2))./(1+exp(-(x-beta(3))/abs(beta(4)))) + beta(2));
x = MOSp;
meanx = mean(x);
meany = mean(y);
numtest = sum((x-meanx).*(y-meany));
dentest = sqrt(sum((x-meanx).^2))*sqrt(sum((y-meany).^2));
rnonlinear = numtest/dentest;

% Spearman
rspear = spear(x,y);

% Outlier
outlier = 0;
for n=1:N
if( abs(MOSp(n)-y(n)) > 2*std_blur(n))
outlier=outlier+1;
end
end
routlier = outlier/N;


MOS = y;
%Root Mean Square Error
rmse = sqrt(sum((MOSp - MOS).^2)/(N));
mae = sum(abs(MOSp-MOS))/(N);


%
function L = logistic_fun(beta,x)


L = ((beta(1) - beta(2))./(1+exp(-(x-beta(3))/abs(beta(4)))) + beta(2));


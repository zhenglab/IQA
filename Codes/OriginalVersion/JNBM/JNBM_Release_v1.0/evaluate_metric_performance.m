%=====================================================================
% File: evaluate_metric_performance.m
% Original code written by Rony Ferzli, IVU Lab (http://ivulab.asu.edu)
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


function [r,rnonlinear, rspear, routlier,rmse,mae] = evaluate_metric_performance(x, y, OS)
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
xrep = repmat(MOSp,1,12);
diffOS = OS;
[MM NN] = size(diffOS);
diffOS = diffOS - xrep ;
stddiff = std(diffOS');
outlier = 0;
for n=1:N
if( abs(MOSp(n)-y(n)) > 2*stddiff(n))
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


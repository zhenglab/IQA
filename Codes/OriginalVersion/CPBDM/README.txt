Readme File - CPBD Sharpness Metric Software
--------------------------------------------
Contact: 
Lina Karam (karam@asu.edu) and Niranjan D. Narvekar (nnarveka@asu.edu)
IVU Lab, http://ivulab.asu.edu/

Reference:
N.D. Narvekar and L. J. Karam, "A no-reference perceptual image sharpness 
metric based on a cumulative probability of blur detection," IEEE
International Workshop on Quality of Multimedia Experience (QoMEX 2009),
pp. 87-91, July 2009.

The provided CPBD Sharpness Metric Software is implemented in 
Matlab. See Copyright Notice, Usage Conditions, and Disclaimer at the end 
of this file. 

* Usage:
-------- 
CPBD_compute.m computes the CPBD based Sharpness Metric given an input grayscale image.
 
A = imread("filename");
A = rgb2gray(A);
metric_cpbd =  CPBD_compute(A);


* Test Demo:
------------
The file data.xls contains the raw subjective scores and standard 
deviations as obtained by subjective experiments conducted in the LIVE Lab at UT Austin.
The corresponding images were obtained from the UT Austin LIVE database 
H. R. Sheikh, Z. Wang, L. Cormack and A. C. Bovik, "LIVE Image Quality Assessment Database," 
http://live.ece.utexas.edu/research/quality.   

To run the test demo using the images listed in data.xls: 
1) Place the set of images listed in the file data.xls 
in the same folder as CPBD_compute.m. These images 
can also be placed in another selected folder if desired.
The listed images are taken from the LIVE database and are provided 
in the "LIVE_Images_GBlur" folder together with the UT Austin LIVE Copyright Notice.   
2) Run CPBD_test.m
3) When asked to 
"Enter image folder path (absolute or relative to current directory)", 
enter the folder where the images are placed including the path. 
If you placed the images in the same folder as CPBD_test.m, type ./ 
For the provided images folder, type ../LIVE_Images_GBlur/
4) When asked
"Are the subjective scores Mean Opinion Scores (MOS) and not Difference MOS (DMOS)? (enter Y or N)"
enter Y if they are MOS scores or enter N if they are DMOS scores. 
Note: The provided data.xls contains MOS scores. In order to run with DMOS scores, copy DMOS.xls as data.xls and enter N as answer to this question.
5) When asked to 
"Enter excel data file name with extension and path (e.g., data.xls)",
enter data.xls 
You can also enter another excel file with the same format as the 
provided sample data.xls file. 
If the data file is not placed in the same folder as CPBD_test.m, 
you need to enter the path of the folder containing the data file in addition to the data file name and extension.

The CPBD_test.m script:
1) populates the excel sheet "data.xls" with the metric values (before
logistic function)
2) The betas for the logistic functions are automatically computed
by CPBD_test.m when calling the "evaluate_metric_performance" function. 
This latter function will compute the betas, get the predicted MOS 
after fitting and computes the statistical performance measurements 
(Pearson, Spearman, MAE, RMSE, and Oulier Ratio).

Note: 
1) MOS.xls is a backup copy of the initial data.xls 
(list of images, MOS scores and standard deviations without the computed CPBD metric values).
2) DMOS.xls contains the DMOS scores and can be used to evaluate the metric for DMOS scores. 
In order to evaluate the metric using DMOS scores, rename DMOS.xls as data.xls and answer 
N to the question "Are the subjective scores Mean Opinion Scores (MOS) and not Difference MOS (DMOS)? (enter Y or N)".


* Copyright Notice, Conditions, Disclaimer
--------------------------------------------

 Copyright Notice:
 Copyright (c) 2009-2010 Arizona Board of Regents. 
 All Rights Reserved.
 Contact: Lina Karam (karam@asu.edu) and Niranjan D. Narvekar (nnarveka@asu.edu)  
 Image, Video, and Usabilty (IVU) Lab, http://ivulab.asu.edu
 Arizona State University
 This copyright statement may not be removed from any file containing it 
or from modifications to these files.
 This copyright notice must also be included in any file or product 
 that is derived from the source files. 
 
 Redistribution and use of this code in source and binary forms, 
 with or without modification, are permitted provided that the 
 following conditions are met:  
 - Redistribution's of source code must retain the above copyright 
   notice, this list of conditions and the following disclaimer. 
 - Redistribution's in binary form must reproduce the above copyright 
   notice, this list of conditions and the following disclaimer in the 
   documentation and/or other materials provided with the distribution. 
 - The Image, Video, and Usability Laboratory (IVU Lab, 
   http://ivulab.asu.edu) is acknowledged in any publication that 
   reports research results using this code, copies of this code, or 
   modifications of this code.  
 
The code and our papers are to be cited in the bibliography as:

N.D. Narvekar and L.J. Karam, "CPBD Sharpness Metric Software", 
http://ivulab.asu.edu/Quality/CPBD 

N.D. Narvekar and L.J. Karam, "A no-reference perceptual image sharpness 
metric based on a cumulative probability of blur detection," IEEE
International Workshop on Quality of Multimedia Experience (QoMEX 2009),
pp. 87-91, July 2009.

N. D. Narvekar and L. J. Karam, "An Improved No-Reference Sharpness Metric Based on the Probability of Blur Detection," International Workshop on Video Processing and Quality Metrics for Consumer Electronics (VPQM), http://www.vpqm.org, January 2010.


DISCLAIMER:
This software is provided by the copyright holders and contributors 
"as is" and any express or implied warranties, including, but not 
limited to, the implied warranties of merchantability and fitness for 
a particular purpose are disclaimed. In no event shall the Arizona 
Board of Regents, Arizona State University, IVU Lab members, authors, or 
contributors be liable for any direct, indirect, incidental, special,
exemplary, or consequential damages (including, but not limited to, 
procurement of substitute goods or services; loss of use, data, or 
profits; or business interruption) however caused and on any theory 
of liability, whether in contract, strict liability, or tort 
(including negligence or otherwise) arising in any way out of the use 
of this software, even if advised of the possibility of such damage. 
 



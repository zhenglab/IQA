Readme File - JNB Sharpness Metric Software
--------------------------------------------
Contact: 
Lina Karam (karam@asu.edu) and Rony Ferzli (rony.ferzli@asu.edu)
IVU Lab, http://ivulab.asu.edu/

Reference:
R. Ferzli and L. J. Karam, "A No-Reference Objective Image Sharpness 
Metric Based on the Notion of Just Noticeable Blur (JNB)," IEEE 
Transactions on Image Processing, vol. 18, no. 4, pp. 717-728, April 2009.

The provided JNB Sharpness Metric Software is implemented in 
Matlab. 
See Copyright Notice, Usage Conditions, and Disclaimer at the end 
of this file. 

* Usage:
-------- 
JNBM_compute.m computes the JNB based Sharpness Metric given an input grayscale image.
 
A = imread("filename");
A = rgb2gray(A);
metric_jnb =  JNBM_compute(A);


* Test Demo:
------------
The file data.xlsx contains the raw subjective scores (NOT DMOS but 
only MOS) as obtained by subjective experiments conducted in the 
IVU Lab (http://ivulab.asu.edu) on the listed images. 
The images were obtained from the UT Austin LIVE database 
H. R. Sheikh, Z. Wang, L. Cormack and A. C. Bovik, "LIVE Image Quality Assessment Database", http://live.ece.utexas.edu/research/quality.   

NOTE: The DMOS scores provided by the LIVE Database were NOT used here 
but subjective MOS scores were used to test the NO REFERENCE 
JNB Sharpness Metric. Since this is a no reference metric, the scores 
were not normalized with respect to the reference.

The excel file data.xlsx lists the individual scores from each 
subject as well as the MOS. Details about the conducted subjective 
experiments that were conducted to obtain these scores are given in: 
R. Ferzli and L. J. Karam, "A No-Reference Objective Image Sharpness 
Metric Based on the Notion of Just Noticeable Blur (JNB)," IEEE 
Transactions on Image Processing, vol. 18, no. 4, pp. 717-728, April 2009.

To run the test demo using the images listed in data.xlsx: 
1) Place the set of images listed in the file data.xls 
in the same folder as JNBM_compute.m. These images 
can also be placed in another selected folder if desired.
The listed images are taken from the LIVE database and are provided 
in the zip file Images.zip together with the UT Austin LIVE Copyright 
Notice.   
2) Run JNBM_test.m
3) When asked to 
"Enter image folder path (absolute or relative to current directory)", 
enter the folder where the images are placed including the path. 
If you placed the images in the same folder as JNB_test.m, type ./ 
4) When asked to 
"Enter excel data file name with extension and path (e.g., data.xlsx)",
enter data.xlsx 
You can also enter another excel file with the same format as the 
provided sample data.xlsx file. 
If the data file is not placed in the same folder as JNBM_test.m, 
you need to enter the path of the folder containing the data file in addition to the data file name and extension.

The JNBM_test.m script:
1) populates the excel sheet "data.xlsx" with the metric values (before
logistic function)
2) The betas for the logistic functions are automatically computed
by JNBM_test.m when calling the "evaluate_metric_performance" function. 
This latter function will compute the betas, get the predicted MOS 
after fitting and computes the statistical performance measurements 
(Pearson, Spearman, MAE, RMSE, and Oulier Ratio).

Note: MOS.xlsx is a backup copy of the initial data.xlsx (list of images and subjective scores without the the computed metric values).


* Copyright Notice, Conditions, Disclaimer
--------------------------------------------

 Copyright Notice:
 Copyright (c) 2007-2009 Arizona Board of Regents. 
 All Rights Reserved.
 Contact: Lina Karam (karam@asu.edu) and Rony Ferzli (rony.ferzli@asu.edu)  
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
 - Redistribution's in binary form must reproduce the above copyright % notice, this list of conditions and the following disclaimer in the 
 documentation and/or other materials provided with the distribution. 
 - The Image, Video, and Usability Laboratory (IVU Lab, 
 http://ivulab.asu.edu) is acknowledged in any publication that 
 reports research results using this code, copies of this code, or 
 modifications of this code.  
 The code and our papers are to be cited in the bibliography as:
 R. Ferzli and L. J. Karam, "JNB Sharpness Metric Software", 
 http://ivulab.asu.edu 

 R. Ferzli and L. J. Karam, "A No-Reference Objective Image Sharpness 
 Metric Based on the Notion of Just Noticeable Blur (JNB)," IEEE 
 Transactions on Image Processing, vol. 18, no. 4, pp. 717-728, April 
 2009.

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
 



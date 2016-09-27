Robust BRISQUE Software release.
=======================================================================
-----------COPYRIGHT NOTICE STARTS WITH THIS LINE------------
Copyright (c) 2011 The University of Texas at Austin
All rights reserved.


Permission is hereby granted, without written agreement and without license or royalty fees, to use, copy, 
modify, and distribute this code (the source files) and its documentation for
any purpose, provided that the copyright notice in its entirety appear in all copies of this code, and the 
original source of this code, Laboratory for Image and Video Engineering (LIVE, http://live.ece.utexas.edu)
and Center for Perceptual Systems (CPS, http://www.cps.utexas.edu) at the University of Texas at Austin (UT Austin, 
http://www.utexas.edu), is acknowledged in any publication that reports research using this code. The research
is to be cited in the bibliography as:

1) A. Mittal, A. K. Moorthy and A. C. Bovik, "Robust BRISQUE Software Release", 
URL: http://live.ece.utexas.edu/research/quality/robustbrisque.zip, 2012.

2) A. Mittal, A. K. Moorthy and A. C. Bovik, "Making image quality assessment robust", Forty-Sixth Annual Asilomar Conference on Signals,
Systems, and Computers, Monterey, California, November 04-07, 2012 

IN NO EVENT SHALL THE UNIVERSITY OF TEXAS AT AUSTIN BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, 
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OF THIS DATABASE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF TEXAS
AT AUSTIN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

THE UNIVERSITY OF TEXAS AT AUSTIN SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE DATABASE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS,
AND THE UNIVERSITY OF TEXAS AT AUSTIN HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

-----------COPYRIGHT NOTICE ENDS WITH THIS LINE------------%

Author  : Anish Mittal 
Version : 1.0

The authors are with the Laboratory for Image and Video Engineering
(LIVE), Department of Electrical and Computer Engineering, The
University of Texas at Austin, Austin, TX.

Kindly report any suggestions or corrections to mittal.anish@gmail.com

=======================================================================

This is a demonstration of the Robust BRISQUE index. The algorithm is described in:

A. Mittal, A. K. Moorthy and A. C. Bovik, "Making image quality assessment robust", Forty-Sixth Annual Asilomar Conference on Signals, 
Systems, and Computers, Monterey, California, November 04-07, 2012 

You can change this program as you like and use it anywhere, but please
refer to its original source (cite our paper and our web page at
http://live.ece.utexas.edu/research/quality/robustbrisque_release.zip.

=======================================================================
Running on Matlab 
  
Usage: Run main.m

It asks for the path of LIVE database as input and outputs spearman and pearson correlation performance for each distortion category and all images together
for 1000 train test combinations where the train and test combination as 80-20. It was made sure that the train and test content are disjoint.

==============================================================================================================================================
MATLAB files: (provided with release): 
  
calculatepearsoncorr.m
computefeatures.m 
lmom.m 
logistic_fun.m    
main.m    
trainandtest_live.m  

Dependencies (provided with release):

1) LIVE database aux files      
dmos.mat          
dmos_realigned.mat 
refnames_all.mat 

2) train_test_splits_1000.mat    for 1000 train-test combinations of LIVE IQA database.

Dependencies (not provided with release):

LIVE image database can be accessed here:
http://live.ece.utexas.edu/research/quality/subjective.htm
=======================================================================

This program uses LibSVM binaries.
Below is the requried copyright notice for the binaries distributed with this release.

====================================================================
LibSVM tools: svm-train, svm-predict, svm-scale (binaries)
--------------------------------------------------------------------
Copyright (c) 2000-2009 Chih-Chung Chang and Chih-Jen Lin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

3. Neither name of copyright holders nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
====================================================================
 
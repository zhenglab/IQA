function [lpc_si lpc_map] = lpc_si(im, scales, w, C, Beta_k, norient, B)
%========================================================================
%LPC-SI = Local Phase Coherence - Sharpness Index, Version 1.0
%Copyright(c) 2013 Rania Hassen
%All Rights Reserved.
%
%The authors are with Department of Electrical and Computer Engineering,
%University of Waterloo, Canada.
%
%----------------------------------------------------------------------
%Permission to use, copy, or modify this software and its documentation
%for educational and research purposes only and without fee is hereby
%granted, provided that this copyright notice and the original authors'
%names appear on all copies and supporting documentation. This program
%shall not be used, rewritten, or adapted as the basis of a commercial
%software or hardware product without first obtaining permission of the
%authors. The authors make no representations about the suitability of
%this software for any purpose. It is provided "as is" without express
%or implied warranty.
%----------------------------------------------------------------------
%
%This is an implementation of the algorithm for calculating the
%Local Phase Coherence - Sharpness Index (LPC-SI) for an input image.
%Please refer to the following papers:
%
%R. Hassen, Z. Wang, M. Salama, "Image Sharpness Assessment Based on Local Phase
% Coherence", IEEE Transactions on Image Processing, Volume: 22, Issue: 0, to appear 2013.
%
%R. Hassen, Z. Wang, and M. Salama, ¡°No-reference image sharpness
%assessment based on local phase coherence measurement ,¡± IEEE International
%Conference on Acoustics, Speech, & Signal Processing, Dallas, TX, Mar. 14-19, 2010.
%
%Kindly report any suggestions or corrections to zhouwang@ieee.org
%
%----------------------------------------------------------------------
%
%Input : (1) im: the input image
%        (2) scales: scales level of successive filters (see the above
%            reference for different scale factors).
%            Default is [1 3/2 2]
%        (3) w: scales weights used to evaluate LPC. The value of
%            weights are associated by the scales choosen. (see the above
%            reference for different scale factors and weights).
%            Default is [1 -3 2]
%        (4) C: constant in the LPC-SI formula (see the above
%            reference). Default is C = 2;
%        (5) Beta_k: parameter used to control the speed of decay of the
%            weighting function. default is: Beta_k = 1e-4;
%        (6) norient: number of filters orientation
%        (7) B: boundry parameter used to crop the input image
%
%Output: (1) lpc_si: no-reference sharpness objective score of the input
%            image. 1 means very sharp, and 0 means very blurred.
%        (2) lpc_map: LPC sharpness map
%
%Default Usage:
%   Given an input blurred image im, compute the preceived sharpness as
%   follow:
%
%   [si lpc_map] = lpc_si(im);
%
%Advanced Usage:
%   You can choose different scale values as follow:
%
%   [si lpc_map] = lpc_si(im,[1 2 4], [1 -3 2]);
%
%The authors would like to thanks Dr. Peter Kovesi for providing the
%intial implementation of logGabor filter bank.
%========================================================================
if (~exist('C'))
   C = 2;
end

if (~exist('Beta_k'))
   Beta_k = 1e-4;
end

if (~exist('scales'))
    scales   = [1 3/2 2];
end

if (~exist('w'))
    w = [1 -3 2];
end

if (~exist('norient'))
    norient  = 8;
end

nscale   = length(scales);
[row col]= size(im);

if (~exist('B'))
    B = round(min(row, col)/16);
end

im = double(im);
filter  = logGabor_2D(im,norient,nscale,scales,0.75);
imfft   = fft2(im);
s_lpc   = ones(row, col, norient);

for o = 1:norient
    for s = 1:nscale
        M(:,:,s) = ifft2(imfft .* filter{s,o});
        s_lpc(:,:,o) = s_lpc(:,:,o).*(M(:,:,s).^w(s));
    end
    e = abs(M(:,:,1));
    e_center = e(B+1:end-B, B+1:end-B);
    e_mean = mean(e_center(:));
    e_std = std(e_center(:));
    T = e_mean + 2*e_std;
    e = max(0, e-T);
    energy(:,:,o) = e;
end
s_lpc_map = cos(angle(s_lpc));
s_lpc_map(s_lpc_map<0) = 0;
lpc_map = (sum(s_lpc_map.*energy,3))./(sum(energy,3) + C);
lpc_map_center = lpc_map(B+1:end-B, B+1:end-B);

sorted_si = sort(lpc_map_center(:),'descend')';
N = length(sorted_si);
u = exp(-((0:(N-1))/(N-1))/Beta_k);
lpc_si = sum(sorted_si.*u)/sum(u);

return;
%Copyright (c) 1996-2010 Peter Kovesi Centre for Exploration Targeting The University of Western Australia peter.kovesi at uwa edu au

function [filter] = logGabor_2D(im,nornt,ns,scalefac,sigma)


nscale          = ns;          % Number of wavelet scales.
norient         = nornt;       % Number of filter orientations.
minWaveLength   = 4;           % Wavelength of smallest scale filter.
r               = scalefac;    % Scaling factor between successive filters.
sigmaOnf        = sigma;       % Ratio of the standard deviation of the
                               % Gaussian describing the log Gabor filter's
                               % transfer function in the frequency domain
                               % to the filter center frequency.
dThetaOnSigma   = 1.5;   % Ratio of angular interval between filter orientations
                         % and the standard deviation of the angular Gaussian
                         % function used to construct filters in the
                         % freq. plane.

filter = cell(nscale, norient);
thetaSigma = pi/norient/dThetaOnSigma;  % Calculate the standard deviation of the
                                        % angular Gaussian function used to
                                        % construct filters in the freq. plane.

[rows,cols] = size(im);

% Pre-compute some stuff to speed up filter construction
% Set up X and Y matrices with ranges normalised to +/- 0.5
% The following code adjusts things appropriately for odd and even values
% of rows and columns.
if mod(cols,2)
    xrange = [-(cols-1)/2:(cols-1)/2]/(cols-1);
else
    xrange = [-cols/2:(cols/2-1)]/cols;
end

if mod(rows,2)
    yrange = [-(rows-1)/2:(rows-1)/2]/(rows-1);
else
    yrange = [-rows/2:(rows/2-1)]/rows;
end

[x,y] = meshgrid(xrange, yrange);

radius = sqrt(x.^2 + y.^2);       % Matrix values contain *normalised* radius from centre.
theta = atan2(-y,x);              % Matrix values contain polar angle.
                                  % (note -ve y is used to give +ve
                                  % anti-clockwise angles)

radius = ifftshift(radius);       % Quadrant shift radius and theta so that filters
theta  = ifftshift(theta);        % are constructed with 0 frequency at the corners.
radius(1,1) = 1;                  % Get rid of the 0 radius value at the 0
                                  % frequency point (now at top-left corner)
                                  % so that taking the log of the radius will
                                  % not cause trouble.

sintheta = sin(theta);
costheta = cos(theta);
clear x; clear y; clear theta;    % save a little memory

% Filters are constructed in terms of two components.
% 1) The radial component, which controls the frequency band that the filter
%    responds to
% 2) The angular component, which controls the orientation that the filter
%    responds to.
% The two components are multiplied together to construct the overall filter.

% Construct the radial filter components...

% First construct a low-pass filter that is as large as possible, yet falls
% away to zero at the boundaries.  All log Gabor filters are multiplied by
% this to ensure no extra frequencies at the 'corners' of the FFT are
% incorporated as this seems to upset the normalisation process when
% calculating phase congrunecy.
lp = lowpassfilter([rows,cols],.45,15);   % Radius .45, 'sharpness' 15

logGabor = cell(1,nscale);

for s = 1:nscale
    if size(r,2)> 1
        wavelength = minWaveLength * r(s);
    else
        wavelength = minWaveLength * r^(s-1);
    end
    fo = 1.0/wavelength;                  % Centre frequency of filter.
    logGabor{s} = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));
    logGabor{s} = logGabor{s}.*lp;        % Apply low-pass filter
    logGabor{s}(1,1) = 0;                 % Set the value at the 0 frequency point of the filter
                                          % back to zero (undo the radius fudge).
end

% Then construct the angular filter components...

spread = cell(1,norient);

for o = 1:norient
  angl = (o-1)*pi/norient;           % Filter angle.

  % For each point in the filter matrix calculate the angular distance from
  % the specified filter orientation.  To overcome the angular wrap-around
  % problem sine difference and cosine difference values are first computed
  % and then the atan2 function is used to determine angular distance.

  ds = sintheta * cos(angl) - costheta * sin(angl);    % Difference in sine.
  dc = costheta * cos(angl) + sintheta * sin(angl);    % Difference in cosine.
  dtheta = abs(atan2(ds,dc));                          % Absolute angular distance.
  spread{o} = exp((-dtheta.^2) / (2 * thetaSigma^2));  % Calculate the
                                                       % angular filter component.
end
% The main loop...

for o = 1:norient                    % For each orientation.
%   angl = (o-1)*pi/norient;           % Filter angle.
  for s = 1:nscale,                  % For each scale.
    filter{s,o} = logGabor{s} .* spread{o};   % Multiply radial and angular
  end
end
%--------------------------------------------------------------------------
function f = lowpassfilter(sze, cutoff, n)

    if cutoff < 0 | cutoff > 0.5
	error('cutoff frequency must be between 0 and 0.5');
    end

    if rem(n,1) ~= 0 | n < 1
	error('n must be an integer >= 1');
    end

    if length(sze) == 1
	rows = sze; cols = sze;
    else
	rows = sze(1); cols = sze(2);
    end

    % Set up X and Y matrices with ranges normalised to +/- 0.5
    % The following code adjusts things appropriately for odd and even values
    % of rows and columns.
    if mod(cols,2)
	xrange = [-(cols-1)/2:(cols-1)/2]/(cols-1);
    else
	xrange = [-cols/2:(cols/2-1)]/cols;
    end

    if mod(rows,2)
	yrange = [-(rows-1)/2:(rows-1)/2]/(rows-1);
    else
	yrange = [-rows/2:(rows/2-1)]/rows;
    end

    [x,y] = meshgrid(xrange, yrange);
    radius = sqrt(x.^2 + y.^2);        % A matrix with every pixel = radius relative to centre.
    f = ifftshift( 1.0 ./ (1.0 + (radius ./ cutoff).^(2*n)) );   % The filter
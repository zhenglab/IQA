function  quality = computequality(im,mu_prisparam,cov_prisparam,principleVectors,meanOfSampleData)
   
blocksizerow    = 84;
blocksizecol    = 84;
blockrowoverlap = 0;
blockcoloverlap = 0;
sigmaForGauDerivative = 1.66;
KforLog = 0.00001;
normalizedWidth = 524;
minWaveLength = 2.4;
sigmaOnf = 0.55;
mult = 1.31;
dThetaOnSigma = 1.10;
scaleFactorForLoG = 0.87;
scaleFactorForGaussianDer = 0.28;
sigmaForDownsample = 0.9;

infConst = 10000;
nanConst = 2000;

window = fspecial('gaussian',5,5/6);
window = window/sum(sum(window));

im = imresize(im, [normalizedWidth normalizedWidth]);
% ---------------------------------------------------------------
%Number of features, 234 features at each scale
featnum = 234;
%----------------------------------------------------------------
%Compute features
imColor = double(im);

O1 = 0.3*imColor(:,:,1) + 0.04*imColor(:,:,2) - 0.35*imColor(:,:,3);
O2 = 0.34*imColor(:,:,1) - 0.6*imColor(:,:,2) + 0.17*imColor(:,:,3);
O3 = 0.06*imColor(:,:,1) + 0.63*imColor(:,:,2) + 0.27*imColor(:,:,3);
    
RChannel = imColor(:,:,1);
GChannel = imColor(:,:,2);
BChannel = imColor(:,:,3);
  
[row, col] = size(O3);
block_rownum = floor(row/blocksizerow);
block_colnum = floor(col/blocksizecol);
O1 = O1(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol); 
O2 = O2(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol);
O3 = O3(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol);
RChannel = RChannel(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol); 
GChannel = GChannel(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol);
BChannel = BChannel(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol);

feat = [];

for itr_scale = 1:2
    mu  = imfilter(O3,window,'replicate');
    mu_sq  = mu.*mu;
    sigma = sqrt(abs(imfilter(O3.*O3,window,'replicate') - mu_sq));
    structdis = (O3-mu)./(sigma+1);
    
    [dx, dy] = gauDerivative(sigmaForGauDerivative/(itr_scale^scaleFactorForGaussianDer));
    compRes = conv2(O1, dx + 1i*dy, 'same');
    IxO1 = real(compRes);
    IyO1 = imag(compRes);
    GMO1 = sqrt(IxO1.^2 + IyO1.^2) + eps;
        
    compRes = conv2(O2, dx + 1i*dy, 'same');
    IxO2 = real(compRes);
    IyO2 = imag(compRes);
    GMO2 = sqrt(IxO2.^2 + IyO2.^2) + eps;

    compRes = conv2(O3, dx + 1i*dy, 'same');
    IxO3 = real(compRes);
    IyO3 = imag(compRes);
    GMO3 = sqrt(IxO3.^2 + IyO3.^2) + eps;
    
       
        logR = log(RChannel + KforLog);
        logG = log(GChannel + KforLog);
        logB = log(BChannel + KforLog);
        logRMS = logR - mean2(logR);
        logGMS = logG - mean2(logG);
        logBMS = logB - mean2(logB);
        
        Intensity = (logRMS + logGMS + logBMS) / sqrt(3);
        BY = (logRMS + logGMS - 2 * logBMS) / sqrt(6);
        RG = (logRMS - logGMS) / sqrt(2);
       
            
    compositeMat = zeros(size(structdis,1),size(structdis,2),109);
    compositeMat(:,:,1) = structdis;
    compositeMat(:,:,2) = GMO1;
    compositeMat(:,:,3) = GMO2;
    compositeMat(:,:,4) = GMO3;
    compositeMat(:,:,5) = Intensity;
    compositeMat(:,:,6) = BY;
    compositeMat(:,:,7) = RG;
    compositeMat(:,:,8) = IxO1;
    compositeMat(:,:,9) = IyO1;
    compositeMat(:,:,10) = IxO2;
    compositeMat(:,:,11) = IyO2;
    compositeMat(:,:,12) = IxO3;
    compositeMat(:,:,13) = IyO3;
        
        [rows,cols] = size(O3);
        LGFilters = logGabors(rows,cols,minWaveLength/(itr_scale^scaleFactorForLoG),sigmaOnf,mult,dThetaOnSigma);
        fftIm = fft2(O3);
        logResponse = zeros(rows,cols,24); 
        partialDer = zeros(rows,cols,48);
        GM = zeros(rows,cols,24); 
        for scaleIndex = 1:3
            for oriIndex = 1:4
                    response = ifft2(LGFilters{scaleIndex,oriIndex}.*fftIm);
                    realRes = real(response);
                    imagRes = imag(response);
                    
                    compRes = conv2(realRes, dx + 1i*dy, 'same');
                    partialXReal = real(compRes);
                    partialYReal = imag(compRes);
                    realGM = sqrt(partialXReal.^2 + partialYReal.^2) + eps;
                    compRes = conv2(imagRes, dx + 1i*dy, 'same');
                    partialXImag = real(compRes);
                    partialYImag = imag(compRes);
                    imagGM = sqrt(partialXImag.^2 + partialYImag.^2) + eps;
                    logResponse(:,:,(scaleIndex-1)*8 + (oriIndex-1) * 2 + 1) = realRes;
                    logResponse(:,:,(scaleIndex-1)*8 + (oriIndex-1) * 2 + 2) = imagRes;

                    partialDer(:,:,(scaleIndex-1)*16 + (oriIndex-1) * 4 + 1) = partialXReal;
                    partialDer(:,:,(scaleIndex-1)*16 + (oriIndex-1) * 4 + 2) = partialYReal;
                    partialDer(:,:,(scaleIndex-1)*16 + (oriIndex-1) * 4 + 3) = partialXImag;
                    partialDer(:,:,(scaleIndex-1)*16 + (oriIndex-1) * 4 + 4) = partialYImag;

                    GM(:,:,(scaleIndex-1)*8 + (oriIndex-1) * 2 + 1) = realGM;
                    GM(:,:,(scaleIndex-1)*8 + (oriIndex-1) * 2 + 2) = imagGM;
            end
        end
    compositeMat(:,:,14:37) = logResponse;
    compositeMat(:,:,38:85) = partialDer;
    compositeMat(:,:,86:109) = GM;
        
    feat_scale = blockproc(compositeMat,[blocksizerow/itr_scale blocksizecol/itr_scale],@computefeature,...
                               'BorderSize', [blockrowoverlap/itr_scale blockcoloverlap/itr_scale],...
                               'PadMethod','symmetric','UseParallel',1,'TrimBorder',0);
    feat_scale = reshape(feat_scale,[featnum size(feat_scale,1)*size(feat_scale,2)/featnum]);
    feat_scale = feat_scale';
   
     feat = [feat feat_scale];
        gauForDS = fspecial('gaussian',ceil(6*sigmaForDownsample),sigmaForDownsample);
        filterResult = imfilter(O1,gauForDS,'replicate');
        O1 = filterResult(1:2:end,1:2:end);
        filterResult = imfilter(O2,gauForDS,'replicate');
        O2 = filterResult(1:2:end,1:2:end);
        filterResult = imfilter(O3,gauForDS,'replicate');
        O3 = filterResult(1:2:end,1:2:end);
        
        filterResult = imfilter(RChannel,gauForDS,'replicate');
        RChannel = filterResult(1:2:end,1:2:end);
        filterResult = imfilter(GChannel,gauForDS,'replicate');
        GChannel = filterResult(1:2:end,1:2:end);
        filterResult = imfilter(BChannel,gauForDS,'replicate');
        BChannel = filterResult(1:2:end,1:2:end);
end

% Fit a MVG model to distorted patch features
infIndicator = isinf(feat);
feat(infIndicator) = infConst;

data = feat';
meanMatrix = repmat(meanOfSampleData,1,size(data,2));
coefficientsViaPCA = principleVectors'*(data - meanMatrix);

distparam = coefficientsViaPCA';
mu_distparam     = nanmean(distparam);
cov_distparam    = nancov(distparam);

nanIndicator = isnan(mu_distparam);
mu_distparam(nanIndicator) = nanConst;
nanIndicator = isnan(cov_distparam);
cov_distparam(nanIndicator) = nanConst;

invcov_param = pinv((cov_prisparam+cov_distparam)/2);
dist = [];
for indexFeature = 1:size(distparam,1)
    currentFea = distparam(indexFeature,:);
    %currentFea may contain nan fields and they are replaced by the
    %corresponding fields in mu_distparam
    nanIndicator = isnan(currentFea);
    currentFea(nanIndicator) = mu_distparam(nanIndicator);
    
    thisDist = sqrt((currentFea - mu_prisparam)*invcov_param*(currentFea - mu_prisparam)');
    dist = [dist;thisDist];
end
quality = mean(dist);

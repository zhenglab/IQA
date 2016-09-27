function feat = computefeature(structdis)
data = structdis.data;
feat = [];

MSCN = data(:,:,1);
[alpha, betal, betar] = estimateaggdparam(MSCN(:)); 
feat = [feat;alpha;(betal+betar)/2];

shifts = [0 1;1 0;1 1;1 -1];

%another 16 parameters
for itr_shift =1:4
    shifted_MSCN = circshift(MSCN,shifts(itr_shift,:));
    pair = MSCN(:).*shifted_MSCN(:);
    [alpha, betal, betar]  = estimateaggdparam(pair);
    meanparam = (betar-betal)*(gamma(2/alpha)/gamma(1/alpha));                       
    feat = [feat;alpha;meanparam;betal;betar];
end

%next, we extract the Weibull parameters
for index = 2:4
    currentRes = data(:,:,index);
    phat1 = wblfit(currentRes(:));
    feat = [feat;phat1'];
end

for index = 5:7
    currentRes = data(:,:,index);
    mu = mean2(currentRes(:));
    sigmaSquare = var(currentRes(:));
    feat = [feat;mu;sigmaSquare];
end

for index = 8:85
    currentRes = data(:,:,index);
    [alpha, betal, betar] = estimateaggdparam(currentRes(:)); 
    feat = [feat;alpha;(betal+betar)/2];
end

for index = 86:109
    currentRes = data(:,:,index);
    phat1 = wblfit(currentRes(:));
    feat = [feat;phat1'];
end

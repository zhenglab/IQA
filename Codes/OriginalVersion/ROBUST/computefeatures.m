function computefeatures(databasepath)
% Class 1 - JP2k
% Class 2 - JPEG
% Class 3 - WN
% Class 4 - Blur
% Class 5 - FF
class(1:227)   = 1;
class(228:460) = 2;
class(461:634) = 3;
class(635:808) = 4;
class(809:982) = 5;


class_label      = {'jp2k','jpeg','wn','gblur','fastfading'};
imnumber         = [0 227 233 174 174];
imnumber         = cumsum(imnumber);
param            =  [];

scalenum = 2;


for itr = 1:length(class)
    itr
tic
imdist = double(rgb2gray(imread(sprintf('%s\\%s\\img%d.bmp',...
          databasepath, class_label{class(itr)},...
         itr-imnumber(class(itr))))));     
     

window = fspecial('gaussian',7,7/6);
window = window/sum(sum(window));

feat = [];

for itr_scale = 1:scalenum

mu            = filter2(window, imdist, 'same');
mu_sq         = mu.*mu;
sigma         = sqrt(abs(filter2(window, imdist.*imdist, 'same') - mu_sq));
structdis     = (imdist-mu)./(sigma+1);
L             = lmom(structdis(:));

feat          = [feat L(2) L(4)];
shifts        = [ 0 1;1 0 ; 1 1; -1 1];
 
for itr_shift =1:4
 
shifted_structdis        = circshift(structdis,shifts(itr_shift,:));
pair                     = structdis(:).*shifted_structdis(:);
L                        = lmom(pair(:));
feat                     = [feat L(1) L(2) L(3) L(4)];

end


imdist      = imresize(imdist,0.5);

end


param= [param; feat];
toc
end

save('temp\robustfeatures_live.mat','param');


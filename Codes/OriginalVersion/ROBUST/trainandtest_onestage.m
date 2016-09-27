function [RHO RHO_jp2k RHO_jpeg RHO_wn RHO_gblur RHO_ff ...
    Pearson_RHO Pearson_RHO_jp2k Pearson_RHO_jpeg ...
    Pearson_RHO_wn Pearson_RHO_gblur Pearson_RHO_ff] = ...
    trainandtest_onestage

load('refnames_all.mat')
load('dmos.mat')
load('dmos_realigned.mat')
load('train_test_splits_1000.mat')
dmos      = dmos_new';
refnames  = unique(refnames_all);

class(1:227)   = 1;
class(228:460) = 2;
class(461:634) = 3;
class(635:808) = 4;
class(809:982) = 5;



load('temp\robustfeatures_live.mat')
%param =rep_vec;
%dmos(orgs==1)=0;
%load features_robust
%param = param(:,1:2);
for itr_trial = 1:1000
    
    
    ind_train = logical(ind_train1000(:,itr_trial));
    ind_test  = logical(ind_test1000(:,itr_trial));
    
    cd('temp')
    fid = fopen('train_ind.txt','w');
    for itr_im = 1:size(param,1)
        if(orgs(itr_im) || ind_test(itr_im))
            %if(ind_test(itr_im))
            continue
        else
            fprintf(fid,'%d ',dmos(itr_im));
            for itr_param = 1:size(param,2)
                fprintf(fid,'%d:%f ',itr_param,param(itr_im,itr_param));
            end
            fprintf(fid,'\n');
        end
    end
    fclose(fid);
    
    if(exist('train_scale','file'))
    delete train_scale
    end
    system('..\svm-scale -l -1 -u 1 -s range train_ind.txt > train_scale');
    system('..\svm-train -b 1 -s 3 -g 0.05 -c 1024 -q train_scale model');
    
    
    %Test
    
    scores = [];
    fid = fopen('test_ind.txt','w');
    humanscores = [];
    testclasses = [];
    
    for itr_im = 1:size(param,1)
        if(orgs(itr_im) || ind_train(itr_im))
            continue
        else
            humanscores = [humanscores; dmos(itr_im)];
            testclasses = [testclasses; class(itr_im)];
            fprintf(fid,'%d ',dmos(itr_im));
            for itr_param = 1:size(param,2)
                fprintf(fid,'%d:%f ',itr_param,param(itr_im,itr_param));
            end
            fprintf(fid,'\n');
        end
    end
    
    fclose(fid);
    delete test_ind_scaled
    system('..\svm-scale  -r range test_ind.txt >> test_ind_scaled');
    system('..\svm-predict  -b 1  test_ind_scaled model output.txt>dump');
    load output.txt;
    quality = output;
    
    cd ..
    
    
    RHO(itr_trial) = corr(quality,humanscores,'type','spearman');
    Pearson_RHO(itr_trial) = calculatepearsoncorr(quality,humanscores);
    
    idx                 = (testclasses==1);
    RHO_jp2k(itr_trial) = corr(quality(idx),humanscores(idx),'type','spearman');
    Pearson_RHO_jp2k(itr_trial) = calculatepearsoncorr(quality(idx),humanscores(idx));
    idx                 = (testclasses==2);
    RHO_jpeg(itr_trial) = corr(quality(idx),humanscores(idx),'type','spearman');
    Pearson_RHO_jpeg(itr_trial) = calculatepearsoncorr(quality(idx),humanscores(idx));
    idx                 = (testclasses==3);
    RHO_wn(itr_trial)   = corr(quality(idx),humanscores(idx),'type','spearman');
    Pearson_RHO_wn(itr_trial) = calculatepearsoncorr(quality(idx),humanscores(idx));
    idx                 = (testclasses==4);
    RHO_gblur(itr_trial)= corr(quality(idx),humanscores(idx),'type','spearman');
    Pearson_RHO_gblur(itr_trial) = calculatepearsoncorr(quality(idx),humanscores(idx));
    idx                 = (testclasses==5);
    RHO_ff(itr_trial)   = corr(quality(idx),humanscores(idx),'type','spearman');
    Pearson_RHO_ff(itr_trial) = calculatepearsoncorr(quality(idx),humanscores(idx));
    
    
end



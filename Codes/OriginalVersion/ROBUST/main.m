if(~isdir('temp'))
    mkdir('temp')
end
  
strResponse = input('Enter the database path:', 's');
computefeatures(strResponse)

[RHO RHO_jp2k RHO_jpeg RHO_wn RHO_gblur RHO_ff ...
          Pearson_RHO Pearson_RHO_jp2k Pearson_RHO_jpeg ...
          Pearson_RHO_wn Pearson_RHO_gblur Pearson_RHO_ff] = ...
          trainandtest_onestage;
      
      
rmdir('temp')

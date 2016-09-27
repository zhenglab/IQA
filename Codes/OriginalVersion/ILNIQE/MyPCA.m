%this is my implementation of principle component analysis 
%sampleData contains the sample data in each column
function [principleVectors, meanOfSampleData,projectionOfTrainingData] = MyPCA(sampleData, reservedRatio)

    principleVectors = [];
    meanOfSampleData = mean(sampleData,2);
    meanMatrix = repmat(meanOfSampleData,1,size(sampleData,2)); %construct a matrix, each row is identical to the vector meanOfColumns
    centerlizedData = sampleData - meanMatrix;
    
    covarianceMatrix = centerlizedData' * centerlizedData;
    subSpaceDim = min(size(sampleData));
    reservedPCs = floor(subSpaceDim * reservedRatio);
    [tmpEigVectors, d] = eigs(covarianceMatrix,subSpaceDim);
    
    eigVectors = centerlizedData * tmpEigVectors(:,1:reservedPCs);
    
    for pcIndex = 1:reservedPCs
        tmpVector = eigVectors(:, pcIndex);
        tmpVector = tmpVector / norm(tmpVector);
        principleVectors = [principleVectors tmpVector];
    end
    
    projectionOfTrainingData = principleVectors' * centerlizedData;
    %normalize the projection coefficients
%      for index = 1:size(projectionOfTrainingData,2)
%         tmpVector = projectionOfTrainingData(:, index);
%         tmpVector = tmpVector / norm(tmpVector);
%         projectionOfTrainingData(:, index) = tmpVector;
%     end


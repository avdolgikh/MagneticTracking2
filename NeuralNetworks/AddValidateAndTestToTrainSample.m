function [ nnetInputs, nnetTargets, trainInd, valInd, testInd ] = AddValidateAndTestToTrainSample( trainInputs, trainTargets, testInputs, testTargets )

%{
Training data: Repeatedly used to estimate the weights (includes biases) of candidate designs.

Validation data: Repeatedly used to estimate the nontraining performance error of candidate designs
                 !!!! Also used to stop training once the nontraining validation error estimate stops decreasing.

Test data: Used once and only once on the best design to obtain an unbiased estimate for the predicted
           error of unseen nontraining data.
%}

%shufleInd = randperm(size(trainInputs, 2));
%trainInputs = trainInputs(:, shufleInd);
%trainTargets = trainTargets(:, shufleInd);

%shufleInd = randperm(size(testInputs, 2));
%testInputs = testInputs(:, shufleInd);
%testTargets = testTargets(:, shufleInd);

trainSize = size(trainInputs, 2);
%validation_and_test_size = round(trainSize * 0.45);
%validation_size = round( validation_and_test_size / 2 );
validation_size = round( size(testInputs, 2) / 2 );

%[validation_and_test_inputs, idx] = datasample(testInputs', validation_and_test_size, 'Replace', false);
%transposed_testTargets = testTargets';
%validation_and_test_targets = transposed_testTargets(idx, :);

%nnetInputs = [trainInputs'; validation_and_test_inputs]';
%nnetTargets = [trainTargets'; validation_and_test_targets]';
nnetInputs = [trainInputs'; testInputs']';
nnetTargets = [trainTargets'; testTargets']';

sampleSize = size(nnetInputs, 2);

trainInd = 1 : trainSize;
valInd = (trainSize + 1) : (trainSize + 1 + validation_size);
testInd = (trainSize + 1 + validation_size + 1) : sampleSize;

end


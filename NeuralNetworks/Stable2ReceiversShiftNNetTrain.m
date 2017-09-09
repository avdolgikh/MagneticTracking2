function [ nnet, training_error, generalization_error ] = Stable2ReceiversShiftNNetTrain( trainInputs, trainTargets, testInputs, testTargets, nnet_size )

% Create NNet with particular sizes of layers:
nnet = fitnet(nnet_size);

nnetInputs = trainInputs;
nnetTargets = trainTargets;

% Set up Division of Data for Training, Validation, Testing
nnet.divideParam.trainRatio = 70/100;
nnet.divideParam.valRatio = 15/100;
nnet.divideParam.testRatio = 15/100;

%nnet.trainFcn = 'traincgb'; % quick?! increase number of epoch? 2.1 Mb of RAM!
nnet.trainParam.epochs = 4000; % eurustick for 'traincgb'?

% https://www.mathworks.com/help/nnet/ref/trainlm.html
% 'trainlm' is default one.
% But it does require more memory than other algorithm!

% nnet.trainFcn = 'trainlm';
nnet.trainFcn = 'trainbr'; % - Bayes?
% nnet.trainFcn = 'trainbfg';
% nnet.trainFcn = 'traincgb';
% nnet.trainFcn = 'traingd';
% nnet.trainFcn = 'trainr';

% Maximum validation failures (6 - default for trainlm and trainbfg)
nnet.trainParam.max_fail = 150;
% Training stops when: Validation performance has increased more than max_fail times since the last time it decreased (when using validation)

nnet.trainParam.goal = 1e-8; % ? what is the value of correspondent generalization_error? linear/anglar error?; default - 0
nnet.trainParam.min_grad = 1e-15;
%nnet.trainParam.minstep = 1e-20;

% tolerance = delta / scale_tol:
nnet.trainParam.delta = 1e-6; % default - 0.01; Initial step size in interval location step
%nnet.trainParam.scal_tol = 2000; % default - 20; Divide into delta to determine tolerance for linear search.
%nnet.trainParam.alpha = 1e-7;
%nnet.trainParam.beta = 1e-7;
%nnet.trainParam.gama = 1e-7;
%nnet.trainParam.low_lim = 1e-7; 

% TODO: try to compile and start on server with follow params:
%nnet.trainParam.showWindow = false;
%nnet.trainParam.showCommandLine = true;

% https://www.mathworks.com/help/nnet/ref/train.html
% Train the NNet
[nnet, ~] = train(nnet, nnetInputs, nnetTargets);
 
% Train error:
outputs = nnet(trainInputs); % NNet is working
training_error = perform(nnet, trainTargets, outputs); % Mean squared normalized error performance function.

% Generalization error:
outputs = nnet(testInputs); % NNet is working
generalization_error = perform(nnet, testTargets, outputs); % Mean squared normalized error performance function.

end





function [ nnet, training_error, generalization_error ] = Stable2ReceiversShiftNNetTrain( trainInputs, trainTargets, validInputs, validTargets, nnet_size )

% Create NNet with particular sizes of layers:
nnet = fitnet(nnet_size);

[ nnetInputs, nnetTargets, trainInd, valInd, testInd ] = AddValidateAndTestToTrainSample( trainInputs, trainTargets, ...
                                                                                          validInputs, validTargets );
nnet.divideFcn = 'divideind';
nnet.divideParam.trainInd = trainInd;
nnet.divideParam.valInd = valInd;
nnet.divideParam.testInd = testInd;

%{
% Set up Division of Data for Training, Validation, Testing
nnet.divideParam.trainRatio = 70/100;
nnet.divideParam.valRatio = 15/100;
nnet.divideParam.testRatio = 15/100;
%}

nnet.trainFcn = 'trainscg';
%nnet.trainFcn = 'traincgb'; % quick?! increase number of epoch? 2.1 Mb of RAM!
nnet.trainParam.epochs = 30000; % eurustick for 'traincgb'?
nnet.trainParam.show = 5;

% https://www.mathworks.com/help/nnet/ref/trainlm.html
% 'trainlm' is default one.
% But it does require more memory than other algorithm!

% nnet.trainFcn = 'trainlm';
%nnet.trainFcn = 'trainbr'; % - Bayes? % http://matlab.exponenta.ru/neuralnetwork/book2/18/trainbr.php
                                      % http://matlab.izmiran.ru/help/toolbox/nnet/backpr17.html
% nnet.trainFcn = 'trainbfg';
% nnet.trainFcn = 'traincgb';
% nnet.trainFcn = 'traingd';
% nnet.trainFcn = 'trainr';

% https://www.mathworks.com/help/nnet/ug/improve-neural-network-generalization-and-avoid-overfitting.html?requestedDomain=www.mathworks.com
nnet.performParam.regularization = 0.9;

% Maximum validation failures (6 - default for trainlm and trainbfg)
nnet.trainParam.max_fail = 7000;
% Training stops when: Validation performance has increased more than max_fail times since the last time it decreased (when using validation)

%nnet.trainParam.goal = 1e-8; % ? what is the value of correspondent generalization_error? linear/angular error?; default - 0
%nnet.trainParam.min_grad = 1e-15;
%nnet.trainParam.minstep = 1e-20;

% tolerance = delta / scale_tol:
%nnet.trainParam.delta = 1e-6; % default - 0.01; Initial step size in interval location step
%nnet.trainParam.scal_tol = 2000; % default - 20; Divide into delta to determine tolerance for linear search.
%nnet.trainParam.alpha = 1e-7;
%nnet.trainParam.beta = 1e-7;
%nnet.trainParam.gama = 1e-7;
%nnet.trainParam.low_lim = 1e-7; 


% elliotsig | elliot2sig | logsig | tansig | ReLU(custom!)
for i = 1 : nnet.numLayers
  if strcmp(nnet.layers{i}.transferFcn,'tansig')
    nnet.layers{i}.transferFcn = 'elliotsig';
  end
end


% TODO: try to compile and start on server with follow params:
%nnet.trainParam.showWindow = true;
%nnet.trainParam.showCommandLine = true;

%{
sample_size = size(nnetInputs, 2);
nnetInputsComposite = Composite;
nnetTargetsComposite = Composite;
numWorkers = numel(nnetInputsComposite);
ind = [0 ceil((1:numWorkers)*(sample_size/numWorkers))];
for i = 1 : numWorkers
    indi = (ind(i)+1):ind(i+1);
    nnetInputsComposite{i} = nnetInputs(:,indi);
    nnetTargetsComposite{i} = nnetTargets(:,indi);
end

checkpoint_file_name = '.\Data\NNets\nnet_checkpoint.mat';
checkpoint_file = load( checkpoint_file_name );
nnet = checkpoint_file.checkpoint.net;

nnet = configure(nnet, nnetInputs, nnetTargets);

[nnet, ~] = train( nnet, nnetInputsComposite, nnetTargetsComposite, 'useParallel','yes','showResources','yes', ...
                    'CheckpointFile', checkpoint_file_name, ...
                    'CheckpointDelay', 60*30); %, ...
                    %'reduction',2);
%}

%https://www.mathworks.com/help/nnet/ug/neural-networks-with-parallel-and-gpu-computing.html
nnetGpuInputs = nndata2gpu(nnetInputs);
nnetGpuTargets = nndata2gpu(nnetTargets);
nnet = configure(nnet, nnetInputs, nnetTargets);  % Configure with MATLAB arrays
[nnet, ~] = train(nnet, nnetGpuInputs, nnetGpuTargets,'useGPU','yes','showResources','yes');

%outputGpu = nnet(nnetGpuInputs);               % Execute on GPU
%output = gpu2nndata(outputGpu);          % Transfer array to local workspace


% https://www.mathworks.com/help/nnet/ref/train.html
% Train the NNet
%[nnet, ~] = train(nnet, nnetInputs, nnetTargets);
%[nnet, ~] = train(nnet, nnetInputs, nnetTargets,'useParallel','yes','useGPU','yes','showResources','yes');


% Train error:
outputs = nnet(trainInputs); % NNet is working
training_error = perform(nnet, trainTargets, outputs); % Mean squared normalized error performance function.

% Generalization error:
outputs = nnet(validInputs); % NNet is working
generalization_error = perform(nnet, validTargets, outputs); % Mean squared normalized error performance function.

end





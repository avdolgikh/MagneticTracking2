clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;


%% Analysis

% An existing neural network researching:

nnet_file_name = strcat( '.\Data\NNets\nnet_9receiv_33300_26-108-15' );      
noisedSampleFile = '.\Data\Samples\emitter_sample_9receiv_1107_0.03_3_shift_receivers.dat';
% rms_errors:                   [0.000667803557886967,0.000671348863333289,0.000751973890311945,0.0946448031778511,0.618022624017081]
% rms_errors (shift receivers): [0.000938450456312098,0.00123112073911083,0.00106844441078006,0.0978604279445306,4.58410457713272]


% load the net:
nnetData = load(nnet_file_name);
nnet = nnetData.nnet;
view(nnet);

% free parameters total number:
numWeightElements = nnet.numWeightElements;

% getting noised sample:
noisedSample = load(noisedSampleFile);

[sample_size, sample_vector_length, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(noisedSample, emitter_coordinate_number);

noisedMutualInductances = noisedSample(:, mutual_inductance_ind);
targetCoordinates = noisedSample(:, coordinates_ind);

nnetCoordinates = SolveEmitterByNNet( noisedMutualInductances, nnet );

generalization_error = perform(nnet, targetCoordinates', nnetCoordinates'); % Mean squared normalized error performance function. 

% common regression:
figure;
plotregression(targetCoordinates, nnetCoordinates);

% x regression:
figure;
plotregression(targetCoordinates(:, 1), nnetCoordinates(:, 1));

% y regression:
figure;
plotregression(targetCoordinates(:, 2), nnetCoordinates(:, 2));

% z regression:
figure;
plotregression(targetCoordinates(:, 3), nnetCoordinates(:, 3));

% tilt regression:
figure;
plotregression(targetCoordinates(:, 4), nnetCoordinates(:, 4));

% azimuth regression:
figure;
plotregression(targetCoordinates(:, 5), nnetCoordinates(:, 5));


errors = gsubtract(nnetCoordinates, targetCoordinates);  % matrix of errors for each value of the sample

solve_result = BuildSolveResult( abs(errors(:, 1:3)), abs(errors(:, 4:5)), [] );

errors(:, 4:5) = errors(:, 4:5) /pi*180;  % convert tilt and azimuth to degrees
rms_errors = rms(errors);

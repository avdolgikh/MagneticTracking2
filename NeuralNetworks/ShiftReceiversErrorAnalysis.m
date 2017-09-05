clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;
nnet_file_name = strcat( '.\Data\NNets\nnet_12receiv_33300_32-69-19' );      
sampleFile = '.\Data\Samples\emitter_noised_40SNR_12receiv_297_0.04_3_0.001_shift_receivers.dat';

%% Analysis

% load the net:
nnetData = load(nnet_file_name);
nnet = nnetData.nnet;

% getting noised sample:
sample = load(sampleFile);

[~, ~, ~, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(sample, emitter_coordinate_number);

mutualInductances = sample(:, mutual_inductance_ind);
targetCoordinates = sample(:, coordinates_ind);

nnetCoordinates = SolveEmitterByNNet( mutualInductances, nnet );

errors = gsubtract(nnetCoordinates, targetCoordinates);  % matrix of errors for each value of the sample
errors(:, 4:5) = errors(:, 4:5) /pi*180;  % convert tilt and azimuth to degrees

linear_errors = errors(:, 1:3);
linear_errors = linear_errors(:);
linear_errors_rms = rms(linear_errors);
linear_errors = abs(linear_errors);

% build distribution for linear coordinates errors, and draw
[~, ~, ~] = BuildDistribution(linear_errors);


angular_errors = errors(:, 4:5);
angular_errors = angular_errors(:);
angular_errors_rms = rms(angular_errors);
angular_errors = abs(angular_errors);

% build distribution for angular coordinates errors, and draw
[~, ~, ~] = BuildDistribution(angular_errors);

%% save data

% TODO!



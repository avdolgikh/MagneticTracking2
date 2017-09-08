clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;
nnet_file_name = strcat( '.\Data\NNets\nnet_12receiv_33300_32-69-19' );      
sampleFile = '.\Data\Samples\emitter_noised_40SNR_12receiv_297_0.04_3_0.01_shift_receivers.dat';
shift_RMS = 0.01;

%% Analysis

% load the net:
nnetData = load(nnet_file_name);
nnet = nnetData.nnet;

% getting noised sample:
sample = load(sampleFile);

[~, ~, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
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
%[~, ~, ~] = BuildDistribution(linear_errors);


angular_errors = errors(:, 4:5);
angular_errors = angular_errors(:);
angular_errors_rms = rms(angular_errors);
angular_errors = abs(angular_errors);

% build distribution for angular coordinates errors, and draw
%[~, ~, ~] = BuildDistribution(angular_errors);

%% save data

% linear:
linear_errors_rms_file = strcat('.\Data\Solving\linear_errors_rms_', num2str(receivers_number), 'receiv_shift_receivers.dat');
if exist(linear_errors_rms_file, 'file')
    linear_errors_rms_table = load(linear_errors_rms_file);
else
    linear_errors_rms_table = zeros(0, 2);
end
linear_errors_rms_table( size(linear_errors_rms_table, 1) + 1, :) = [shift_RMS, linear_errors_rms];
dlmwrite(linear_errors_rms_file, linear_errors_rms_table);


% angular:
angular_errors_rms_file = strcat('.\Data\Solving\angular_errors_rms_', num2str(receivers_number), 'receiv_shift_receivers.dat');
if exist(angular_errors_rms_file, 'file')
    angular_errors_rms_table = load(angular_errors_rms_file);
else
    angular_errors_rms_table = zeros(0, 2);
end
angular_errors_rms_table( size(angular_errors_rms_table, 1) + 1, :) = [shift_RMS, angular_errors_rms];
dlmwrite(angular_errors_rms_file, angular_errors_rms_table);






clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;
nnet_file_name = strcat( '.\Data\NNets\nnet_12receiv_33300_32-69-19' );      
sampleFile = '.\Data\Samples\emitter_sample_12receiv_297_0.04_3_shift_receivers.dat';
partition_size = 297;
shift_step = 0.004;

%% Analysis

% load the net:
nnetData = load(nnet_file_name);
nnet = nnetData.nnet;

% getting noised sample:
sample = load(sampleFile);

[sample_size, ~, ~, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(sample, emitter_coordinate_number);

mutualInductances = sample(:, mutual_inductance_ind);
targetCoordinates = sample(:, coordinates_ind);

nnetCoordinates = SolveEmitterByNNet( mutualInductances, nnet );

errors = gsubtract(nnetCoordinates, targetCoordinates);  % matrix of errors for each value of the sample

errors(:, 4:5) = errors(:, 4:5) /pi*180;  % convert tilt and azimuth to degrees

linear_errors = [];
angular_errors = [];
receiver_shift_vector = [];
shift = 0;
for i = 1 : sample_size/partition_size
    
    shift = shift + shift_step;
    receiver_shift_vector = [receiver_shift_vector shift];
    start_index = (partition_size * (i - 1) + 1);
    end_index = start_index + partition_size - 1;
    errors_partition = errors( start_index : end_index, :);
    rms_errors = rms(errors_partition);
    
    linear_errors = [linear_errors mean(rms_errors(1:3))];
    angular_errors = [angular_errors mean(rms_errors(4:5))];
end

figure('Name', 'Linear error', 'NumberTitle', 'off');
plot( receiver_shift_vector, linear_errors, 'LineWidth', 2);
hold on;
grid( 'on' );
title( 'Linear error' );
xlabel( 'shift' );
ylabel( 'linear error' );


figure('Name', 'Angular error', 'NumberTitle', 'off');
hold on;
plot( receiver_shift_vector, angular_errors, 'r', 'LineWidth', 2);
grid( 'on' );
title( 'Angular error' );
xlabel( 'shift' );
ylabel( 'angular error' );

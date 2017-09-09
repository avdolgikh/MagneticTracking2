clear all;
clc;

%% Parameters:
emitter_coordinates_number = 5;

%% Data preparing

% load a sample
data = [];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.001_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.002_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.003_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.004_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.005_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.006_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.007_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.008_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.009_shift_receivers.dat')];
data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_297_0.04_3_0.01_shift_receivers.dat')];

shufleInd = randperm( size(data, 1) );
data = data(shufleInd, :);

mid_index = round( size(data, 1) / 2 );
train_data = data(1 : mid_index, :);
test_data = data(mid_index + 1 : end, :);

[~, ~, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(data, emitter_coordinates_number);

trainInputs = train_data(:, mutual_inductance_ind)';
trainTargets = train_data(:, coordinates_ind)';

testInputs = test_data(:, mutual_inductance_ind)';
testTargets = test_data(:, coordinates_ind)';

%% Training

[ nnet, training_error, generalization_error ] = Stable2ReceiversShiftNNetTrain( trainInputs, trainTargets, testInputs, testTargets, [26, 108, 15] );

nnet_size_string = '26-108-15';
lin_radius = '_lin_08';
angular = '_ang_3-9';
receivers_shift = 'receiv_01';
nnet_file_name = strcat( '.\Data\NNets\nnet_', nnet_size_string, ...
                                                lin_radius, ...
                                                angular, '_', ...
                                                num2str(receivers_number), receivers_shift, ...
                                                '.mat' ); 
save(nnet_file_name, 'nnet');

    




    


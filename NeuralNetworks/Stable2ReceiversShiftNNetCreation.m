clear all;
clc;

%% Parameters:
emitter_coordinates_number = 5;

%% Data preparing

% load a sample
train_data = load('.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.03_0.09_ang_2.8_2-10.4_normalized.dat');
validation_data = load('.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.04_0.08_ang_4_2-10_validation_normalized.dat');

[~, ~, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(train_data, emitter_coordinates_number);

trainInputs = train_data(:, mutual_inductance_ind)';
trainTargets = train_data(:, coordinates_ind)';

validInputs = validation_data(:, mutual_inductance_ind)';
validTargets = validation_data(:, coordinates_ind)';

clear train_data validation_data coordinates_ind mutual_inductance_ind;


%% Training

%nnet_sizes = GetNNetSizes( [3756 3757], 1, receivers_number, emitter_coordinates_number );
%f = CalculateNNetFreeParamsNumber( receivers_number, emitter_coordinates_number, [107 84 51] ); %=> 15058

[ nnet, training_error, generalization_error ] = Stable2ReceiversShiftNNetTrain( trainInputs, trainTargets, validInputs, validTargets, [100 200 100] );

nnet_size_string = '100-200-100_reg0.9';
lin_radius = '_lin_0.03_0.09';
angular = '_ang_2.8_2-10.4_';
receivers_shift = '_receiv_0.01shift';
nnet_file_name = strcat( '.\Data\NNets\nnet_', nnet_size_string, ...
                                                lin_radius, ...
                                                angular, ...
                                                num2str(receivers_number), receivers_shift, ...
                                                '.mat' ); 
save(nnet_file_name, 'nnet');

    




    


clear all;
clc;

%% Parameters:
emitter_coordinates_number = 5;
nnet_number_to_search = 1;
nnet_free_params_size_range = [100034 100089];


%% Data preparing

fprintf('Load files.\n');

% load a train sample
emitter_train_data = load('.\Data\Samples\emitter_sample_12receiv_1214784_0.025_3_big.dat');

[sample_size, ~, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(emitter_train_data, emitter_coordinates_number);

trainInputs = emitter_train_data(:, mutual_inductance_ind)';
trainTargets = emitter_train_data(:, coordinates_ind)';
clear emitter_train_data;

% load a test sample
emitter_test_data = load('.\Data\Samples\emitter_test_12receiv_1214784_0.025_3_big.dat');
testInputs = emitter_test_data(:, mutual_inductance_ind)';
testTargets = emitter_test_data(:, coordinates_ind)';
clear emitter_test_data;

% load a noised sample
emitter_noised_data = load('.\Data\Samples\emitter_noised_20SNR_12receiv_1214784_big.dat');
noisedInputs = emitter_noised_data(:, mutual_inductance_ind)';
noisedTargets = emitter_noised_data(:, coordinates_ind)';
clear emitter_noised_data coordinates_ind mutual_inductance_ind;

%% Get NNets to train:

fprintf('Get NNet size by GA.\n');

nnet_sizes = GetNNetSizes( nnet_free_params_size_range, nnet_number_to_search, receivers_number, emitter_coordinates_number );
clear nnet_free_params_size_range nnet_number_to_search nnet_output_number;


%% Training

min_generalization_error = 100;      

%InitParallelRun();

%nnets = {};

for index = 1 : size(nnet_sizes, 1)
%parfor index = 1 : size(nnet_sizes, 1)

    nnet_size_string = strjoin( strtrim(cellstr( num2str( nnet_sizes(index, :)' ) )'), '-' );
    fprintf('NNetTrain. Index: %d, size: %s.\n', index, nnet_size_string);
    
	[ nnet, training_error, generalization_error ] = NNetTrain( trainInputs, trainTargets, ...
                                                            testInputs, testTargets, ...
                                                            noisedInputs, noisedTargets, nnet_sizes(index, :) );
    %nnets{index} = nnet;
    
    fprintf('SaveNNetErrors.\n');
    nnet_errors_file_name = strcat( '.\Data\NNets\nnet_errors_', num2str(receivers_number), ...
                                    'receiv_', num2str(sample_size), ...
                                    '_traincgb_4000epoch_big.dat');
	SaveNNetErrors( nnet, nnet_errors_file_name, training_error, generalization_error )
    
    
	if (generalization_error < min_generalization_error)
        min_generalization_error = generalization_error;
        nnet_file_name = strcat( '.\Data\NNets\nnet_', num2str(receivers_number), ...
                                 'receiv_', num2str(sample_size), '_', ...
                                 nnet_size_string, '_big_new.mat' ); 
        save(nnet_file_name, 'nnet');
    end
    
    
    clear nnet training_error nnet_errors_file_name nnet_file_name nnet_size_string;
end

%{
for index = 1 : size(nnets, 2)
    nnet_size_string = strjoin( strtrim(cellstr( num2str( nnet_sizes(index, :)' ) )'), '-' );
    nnet = nnets{index};
    nnet_file_name = strcat( '.\Data\NNets\nnet_', num2str(receivers_number), ...
                                 'receiv_', num2str(sample_size), '_', ...
                                 nnet_size_string, '_new.mat' ); 
    save(nnet_file_name, 'nnet');
end
%}
	

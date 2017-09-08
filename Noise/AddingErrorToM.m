% Basing on test sample, builds noised sample with specific SNR.

clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;
SNR_dB = 40; %dB


%% Data loading and recognizing

SNR_Error_map = load('.\Data\Noise\SNR_into_Normalized_Error_RMS_sawtooth_0.08.dat');
SNR_Error_dictionary = containers.Map(SNR_Error_map(:, 1), SNR_Error_map(:, 2));

error_ratio_rms = SNR_Error_dictionary(SNR_dB);

% load a test sample
emitter_original_data = load('.\Data\Samples\emitter_sample_12receiv_297_0.04_3_0.01_shift_receivers.dat');

[sample_size, sample_vector_length, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(emitter_original_data, emitter_coordinate_number);

error_ratio = random('Normal', 0, error_ratio_rms, [sample_size receivers_number]);

%% Calculation:

emitter_noised_data = emitter_original_data;
emitter_noised_data(:, mutual_inductance_ind) = emitter_original_data(:, mutual_inductance_ind) .* (1 + error_ratio);

%% Data saving
% Save Emitter noised grid into a file.

dlmwrite(strcat('.\Data\Samples\emitter_noised_', num2str(SNR_dB), 'SNR_', ...
                num2str(receivers_number), 'receiv_', num2str(sample_size), '_0.04_3_0.01_shift_receivers.dat'), ...
                emitter_noised_data);




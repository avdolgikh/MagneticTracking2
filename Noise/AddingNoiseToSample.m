% Basing on test sample, builds noised sample for specific RMS of noise.

clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;

% Emitter current, frequency, etc.
emitter_signal_frequency = 20e3; % Hz
emitter_signal_amplitude = 0.5; % A
emitter_signal_form_factor = 2*pi; % sin - 2*pi, sawtooth/triangle - 8, square - 4

noise_mean = 0; % mean value of noise, "Expected value"
noise_rms = 0.0001; % Volts, root mean square of noise, 0.1 mV

%% Data loading
emitter_original_data = load('.\Data\Samples\emitter_test_9receiv_33300_0.02_2_movement.dat');


%% Calculation:
EMF_ratio = emitter_signal_form_factor * emitter_signal_frequency ...
                    * emitter_signal_amplitude;

[sample_size, sample_vector_length, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                        GetSampleInfo(emitter_original_data, emitter_coordinate_number);

noise = random('Normal', noise_mean, noise_rms, [sample_size receivers_number]);
noise_rms_calculated = rms(noise);

%M_noise = noise / EMF_ratio;

emitter_noised_data = emitter_original_data;
emitter_noised_data(:, mutual_inductance_ind) = emitter_original_data(:, mutual_inductance_ind) + noise / EMF_ratio;

E_rms = EMF_ratio * rms(emitter_original_data(:, mutual_inductance_ind), 1);
SNR_dB = Calculate_SNR_dB( E_rms, noise_rms );

%nrms = DefineNoiseRms( E_rms, 30 );

%% Graphics
% TODO: Separate plot for each receiver: with discrete counts of noised signal (color 1) and discrete counts of original signal (color 2)?
%{
figure('Name', 'Noising', 'NumberTitle', 'off');
hold on;
plot(time, original_signal, 'b', 'LineWidth', 2);
plot(time, noised_signal, 'ro');
legend('Original Signal','Noised Signal');
grid( 'on' );
title( 'Noising' );
xlabel( 'Time, s' );
ylabel( 'Signal value' );
%}

%% Data saving
% Save Emitter noised grid into a file.
%{
dlmwrite(strcat('.\Data\Samples\emitter_noised_', num2str(noise_rms), 'RMS_', ...
                num2str(receivers_number), 'receiv_', num2str(sample_size), '.dat'), emitter_noised);

%}


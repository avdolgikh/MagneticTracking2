clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;
SNR_dB = 10;

% Emitter/receiver characteristics
emitter_signal_frequency = 20e3; % Hz
emitter_signal_amplitude = 0.5; % A
emitter_signal_form_factor = 2*pi; % sin - 2*pi, sawtooth/triangle - 8, square - 4
receiver_amplification_factor = 250;

%% Data loading
data = load('.\Data\Samples\emitter_test_9receiv_33300_0.02_2_movement.dat');


%% Calculation:
EMF_ratio = emitter_signal_form_factor * emitter_signal_frequency ...
                    * emitter_signal_amplitude * receiver_amplification_factor;

[~, ~, ~, ~, mutual_inductance_ind] = GetSampleInfo(data, emitter_coordinate_number);

M = data(:, mutual_inductance_ind);
M_min = min(abs(M(:)));
M_mean = mean(M(:));
M_rms = rms(M(:));
M_max = max(abs(M(:)));

E = EMF_ratio * M;
E_rms = rms(E(:));

noise_rms = DefineNoiseRms( E_rms, SNR_dB );


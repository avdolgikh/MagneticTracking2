% Basing on noised sample, evaluate and validate absolute value of possible EMF in receivers.
% If such EMF value could actually be measured by real modern detectors?

clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;

% Emitter/receiver characteristics
emitter_signal_frequency = 20e3; % Hz
emitter_signal_amplitude = 0.5; % A
emitter_signal_form_factor = 2*pi; % sin - 2*pi, sawtooth/triangle - 8, square - 4
receiver_amplification_factor = 250;

%% Data loading
data = load('.\Data\Samples\emitter_noised_20SNR_9receiv_33300_movement.dat');


%% Calculation:
EMF_ratio = emitter_signal_form_factor * emitter_signal_frequency ...
                    * emitter_signal_amplitude * receiver_amplification_factor;

[~, ~, ~, ~, mutual_inductance_ind] = GetSampleInfo(data, emitter_coordinate_number);

E = EMF_ratio * data(:, mutual_inductance_ind);

E_min = min(abs(E(:)));
E_mean = mean(E(:));
E_rms = rms(E(:));
E_max = max(abs(E(:)));

E_centered = E - E_mean;

E_abs_mean = mean(abs(E(:)));


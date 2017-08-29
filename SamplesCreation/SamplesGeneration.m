% Generates:
    % - receivers set
    % - emitter positions/orientations and mutual inductance with receivers:
        % - standard
        % - volatile
        % - noised

clear all;
clc;
        
%% Parameters:

% Receivers coordinates:
receivers_sphera_radius = 0.625; % m
receivers_number = 12;

% Emitter position/orientation:
emitter_sphera_max_radius = 0.2; % m, 0.35m
emitter_linear_step = 0.025; % m
emitter_angular_step = pi/180 * 3; % 3 degrees
emitter_angular_coordinate_min = pi/180 * 1; % 5 degrees
emitter_angular_coordinate_max = pi/180 * 70; % 15 degrees

%{
% Emitter current, frequency, etc.
emitter_signal_frequency = 1025; % Hz
emitter_signal_amplitude = 0.7188/2; % A
emitter_signal_amplitude_rate = 2*pi; % sin - 2*pi, sawtooth/triangle - 8, square - 4

% Receivers:
receiver_amplification_factor = 250; % gain, +-20%
%}

% Coils geometry:
emitter_turns_number = 157;   % turns number of emitter coil
receiver_turns_number = 158;   % turns number of receiver coil
emitter_radius = 0.0306 / 2;    % radius of emitter coil, m
receiver_radius = 0.073 / 2;     % radius of receiver coil, m
emitter_length = 0.094;   % length of emitter coil, m
receiver_length = 0.0035;  % length of receiver coil, m

%mutual_inductance_calculating_discretization = [20, 0, 1, 0]; % [S, N, m, n]

% Mutual inductance precalculation:
S = 20; N = 0; m = 1; n = 0;
NpxNs = emitter_turns_number * receiver_turns_number;
divider = (2*S + 1)*(2*N + 1)*(2*m + 1)*(2*n + 1);
Rp_h_coef = 0;
Rs_q_coef = 0;
xy_p_coef = receiver_length / (2*m + 1);
z_g_coef = emitter_length / (2*S + 1);
z_p_coef = receiver_length / (2*m + 1);

InitParallelRun();

%% Sample creation:

% Receivers
receivers = BuildReceiversCoordinates(receivers_sphera_radius, receivers_number);
%receivers = load('.\Data\Samples\receivers_12_33300.dat');
fprintf('Receivers have been created.\n');

% Emitter position/orientation variations
emitter_coordinates = BuildEmitterCoordinates( emitter_sphera_max_radius, emitter_linear_step, ...
                                            emitter_angular_step, emitter_angular_coordinate_min, ...
                                            emitter_angular_coordinate_max );
emitter_volatile_coordinates = BuildVolatileEmitterCoordinates( emitter_coordinates, emitter_linear_step, ...
                                                            emitter_angular_step );
%{
emitter_positions = [1, 2, -1, 0.2, -0.9; -2, 4, 5, 1.1, 0.3];
emitter_volatile_positions = [1.2, 2.1, -1.2, 0.24, -0.91; -2.3, 4.2, 5.1, 1.13, 0.35];
%}
fprintf('Emitter position/orientation sets have been created.\n');

% Start stopwatch timer
tic;

%{
[emitter_standard, ~] = AddMutualInductance( emitter_positions, receivers, emitter_turns_number, ...
                                            receiver_turns_number, emitter_radius, receiver_radius, ...
                                            emitter_length, receiver_length, mutual_inductance_calculating_discretization, 30);
%}
[emitter_standard, ~] = AddMutualInductance( emitter_coordinates, receivers, emitter_radius, receiver_radius, ...
                                             NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, ...
                                             z_p_coef, S, N, m, n );
fprintf('Standart set with mutual inductance has been created.\n');

%{
[emitter_volatile, emitter_noised] = AddMutualInductance(emitter_volatile_positions, receivers, ...
                                            emitter_turns_number, receiver_turns_number, emitter_radius, ...
                                            receiver_radius, emitter_length, receiver_length, ...
                                            mutual_inductance_calculating_discretization, receiver_SNR_dB);
%}
[emitter_volatile, ~] = AddMutualInductance(emitter_volatile_coordinates, receivers, ...
                                            emitter_radius, receiver_radius, ...
                                            NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, ...
                                            z_g_coef, z_p_coef, S, N, m, n);

fprintf('Volatile set with mutual inductance have been created.\n');

% Read elapsed time from stopwatch
time_spent = toc;

fprintf('Elapsed time = %d s.\n', time_spent);

average_time_1_M_calc = time_spent / (size(emitter_standard, 1) + size(emitter_volatile, 1)) / length(receivers);
fprintf('Average time for 1 M calculation = %d s.\n', average_time_1_M_calc);

%% Data saving

fprintf('Data saving.\n');

sample_size = size(emitter_standard, 1);

% Save Receivers coordinates into a file.
dlmwrite(strcat('.\Data\Samples\receivers_', num2str(receivers_number), '_', ...
                num2str(sample_size), '_big.dat'), receivers); 

% Save Emitter standard grid into a file.
dlmwrite(strcat('.\Data\Samples\emitter_sample_', num2str(receivers_number), 'receiv_', ...
                num2str(sample_size), '_', ...
                num2str(emitter_linear_step), '_', ...
                num2str(emitter_angular_step /pi*180), ...
                '_big.dat'), emitter_standard);
            
% Save Emitter volatile grid into a file.
dlmwrite(strcat('.\Data\Samples\emitter_test_', num2str(receivers_number), 'receiv_', ...
                num2str(sample_size), '_', ...
                num2str(emitter_linear_step), '_', ...
                num2str(emitter_angular_step /pi*180), ...
                '_big.dat'), emitter_volatile);

%{
% Save Emitter noised grid into a file.
dlmwrite(strcat('.\Data\Samples\emitter_noised_', num2str(receiver_SNR_dB), 'SNR_', ...
                num2str(receivers_number), 'receiv_', num2str(sample_size), '_', ...
                num2str(emitter_linear_step), '_', ...
                num2str(emitter_angular_step /pi*180), ...
                '.dat'), emitter_noised);
%}




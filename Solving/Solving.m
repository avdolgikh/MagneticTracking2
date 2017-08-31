% Solving of emitter position/orientation by mutual inductance
% in receivers.

clear all;
clc;

%% Parameters:
emitter_coordinate_number = 5;
data_size_to_solve = 1100;
parallel_factor = 22;

%% Data loading

emitter_data = load('.\Data\Samples\emitter_noised_0SNR_12receiv_33300_movement.dat');
receivers = load('.\Data\Samples\receivers_12_33300.dat');

%{
nnet_file_name = strcat( '.\Data\NNets\nnet_12receiv_33300_32-69-19.mat' );
nnet_data = load(nnet_file_name);
nnet = nnet_data.nnet;
%}

solve_result = SolveDataListByFsolve( emitter_data, parallel_factor, data_size_to_solve, ...
                                      emitter_coordinate_number, receivers );
%solve_result = SolveDataListByNNet( emitter_data, data_size_to_solve, emitter_coordinate_number, nnet );

dlmwrite('.\Data\Solving\emitter_fsolve_0SNR_12receiv_33300_movement.dat', solve_result);


%{

%{
% Emitter position/orientation:
emitter_sphera_max_radius = 0.15; % m, 0.35m
emitter_angular_coordinate_min = pi/180 * -5; % -5 degrees
emitter_angular_coordinate_max = pi/180 * 5; % 5 degrees
%}

% Mutual inductance precalculation:
emitter_turns_number = 157;   % turns number of emitter coil
receiver_turns_number = 158;  % turns number of receiver coil
emitter_radius = 0.0306 / 2;  % radius of emitter coil, m
receiver_radius = 0.073 / 2;  % radius of receiver coil, m
emitter_length = 0.094;       % length of emitter coil, m
receiver_length = 0.0035;     % length of receiver coil, m
S = 40; N = 0; m = 1; n = 0;
NpxNs = emitter_turns_number * receiver_turns_number;
divider = (2*S + 1)*(2*N + 1)*(2*m + 1)*(2*n + 1);
Rp_h_coef = 0;
Rs_q_coef = 0;
xy_p_coef = receiver_length / (2*m + 1);
z_g_coef = emitter_length / (2*S + 1);
z_p_coef = receiver_length / (2*m + 1);

    %{
    emitter_coordinates = SolveEmitterByGA( emitter_data(row_index, mutual_inductance_ind), receivers, ...
                            emitter_sphera_max_radius, emitter_angular_coordinate_min, emitter_angular_coordinate_max, ...
                            emitter_radius, receiver_radius, NpxNs, ...
                            divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n );
    %}
%}


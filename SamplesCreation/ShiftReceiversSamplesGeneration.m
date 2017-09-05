clear all;
clc;
        
%% Parameters:

% Emitter position/orientation:
emitter_sphera_max_radius = 0.08; % m
emitter_linear_step = 0.04; % m
emitter_angular_step = pi/180 * 3;
emitter_angular_coordinate_min = pi/180 * 3;
emitter_angular_coordinate_max = pi/180 * 9;

% Receivers:
shift_RMS = 0.001; % m

% Coils geometry:
emitter_turns_number = 157;   % turns number of emitter coil
receiver_turns_number = 158;   % turns number of receiver coil
emitter_radius = 0.0306 / 2;    % radius of emitter coil, m
receiver_radius = 0.073 / 2;     % radius of receiver coil, m
emitter_length = 0.094;   % length of emitter coil, m
receiver_length = 0.0035;  % length of receiver coil, m

% Mutual inductance precalculation:
S = 20; N = 0; m = 1; n = 0;
NpxNs = emitter_turns_number * receiver_turns_number;
divider = (2*S + 1)*(2*N + 1)*(2*m + 1)*(2*n + 1);
Rp_h_coef = 0;
Rs_q_coef = 0;
xy_p_coef = receiver_length / (2*m + 1);
z_g_coef = emitter_length / (2*S + 1);
z_p_coef = receiver_length / (2*m + 1);


%% Sample creation:

% Receivers
%receivers = load('.\Data\Samples\receivers_9_33300.dat');
receivers = load('.\Data\Samples\receivers_12_33300.dat');

receivers_number = size(receivers, 1);
fprintf('Receivers have been loaded.\n');

% Emitter position/orientation variations
emitter_coordinates = BuildEmitterCoordinates( emitter_sphera_max_radius, emitter_linear_step, ...
                                            emitter_angular_step, emitter_angular_coordinate_min, ...
                                            emitter_angular_coordinate_max );

fprintf('Emitter position/orientation set has been created.\n');

sample_size = size(emitter_coordinates, 1);

emitter = [];

% define normal distributed shifting of linear coordinates of the receivers:
shift = random('Normal', 0, shift_RMS, [receivers_number sample_size*3]); % 3 is number on linear coordinates (x, y, z)

for i = 1 : sample_size
    
    shifted_receivers = receivers;
    
    start_index = (i - 1) * 3 + 1;
    end_index = start_index + 2;
    shifted_receivers(:, 1:3) = shifted_receivers(:, 1:3) + shift(:, start_index : end_index);
    
    [emitter_partition, ~] = AddMutualInductance( emitter_coordinates(i, :), shifted_receivers, emitter_radius, receiver_radius, ...
                                                 NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, ...
                                                 z_p_coef, S, N, m, n );        
    emitter = [emitter; emitter_partition];
end
    
fprintf('Set with mutual inductance has been created.\n');

%% Data saving

fprintf('Data saving.\n');

% Save Emitter movement grid into a file.
dlmwrite(strcat('.\Data\Samples\emitter_sample_', num2str(receivers_number), 'receiv_', ...
                num2str(sample_size), '_', ...
                num2str(emitter_linear_step), '_', ...
                num2str(emitter_angular_step /pi*180), '_', ...
                num2str(shift_RMS), ...
                '_shift_receivers.dat'), emitter);
            

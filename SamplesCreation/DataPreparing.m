clear all;
clc;

data = [];
data = [data; load('.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.03_0.09_ang_2.8_2-10.4.dat')];
%data = [data; load('.\Data\Samples\emitter_noised_40SNR_9receiv_0.01shift__lin_0.03_0.09_ang_2.8_2-10.4.dat')];

shufleInd = randperm( size(data, 1) );
data = data(shufleInd, :);

%data = data(1:1000, :);

% Normalization => [-1 1]
%lin_min_data = min( min ( data(:, 1:3)));
%lin_max_data = max( max ( data(:, 1:3)));
%data(:, 1:3) = Normalization( data(:, 1:3), lin_min_data, lin_max_data, [-1 1] );
data(:, 1:3) = Normalization( data(:, 1:3), -0.09, 0.09, [-1 1] );

%ang_min_data = min( min ( data(:, 4:5)));
%ang_max_data = max( max ( data(:, 4:5)));
%data(:, 4:5) = Normalization( data(:, 4:5), ang_min_data, ang_max_data, [-1 1] );
data(:, 4:5) = Normalization( data(:, 4:5), 0.034907, 0.18151, [-1 1] );

%M_min_data = min( min ( data(:, 6:14)));
%M_max_data = max( max ( data(:, 6:14)));
%data(:, 6:14) = Normalization( data(:, 6:14), M_min_data, M_max_data, [-1 1] );
data(:, 6:17) = Normalization( data(:, 6:17), -9.7134e-08, 6.1524e-08, [-1 1] );

%{
data_denormalization_info = [lin_min_data; lin_max_data;
                                ang_min_data; ang_max_data;
                                M_min_data; M_max_data];

data_denormalization_info_file = '.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.03_0.09_ang_2.8_2-10.4_denormalization_info.dat';
dlmwrite(data_denormalization_info_file, data_denormalization_info);
%}

%data_file = '.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.03_0.09_ang_2.8_2-10.4_normalized.dat';
data_file = '.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.03_0.09_ang_2.8_2-10.4_normalized.dat';
dlmwrite(data_file, data);



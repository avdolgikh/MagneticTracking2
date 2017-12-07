    clear all;
    clc;

    %% Parameters:
    emitter_coordinate_number = 5;
    nnet_file_name = strcat( '.\Data\NNets\best_nnet_100-800-200_reg0.9_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    nnet_file2_name = strcat( '.\Data\NNets\nnet_150-800-100_reg0.95_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    %nnet_file3_name = strcat( '.\Data\NNets\nnet_150-800-150_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    %nnet_file4_name = strcat( '.\Data\NNets\nnet_150-800-150_reg0.85_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    %nnet_file5_name = strcat( '.\Data\NNets\nnet_200-800-150_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    %nnet_file6_name = strcat( '.\Data\NNets\nnet_200-800-200_reg0.95_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    %nnet_file7_name = strcat( '.\Data\NNets\nnet_250-800-250_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    %nnet_file8_name = strcat( '.\Data\NNets\nnet_250-800-250_reg0.8_lin_0.03_0.09_ang_2.8_2-10.4_12_receiv_0.01shift.mat' );
    
    sampleFile = '.\Data\Samples\emitter_sample_12receiv_0.01shift__lin_0.04_0.08_ang_4_2-10_WHOLE_testing.dat';
    shift_RMS = 0.01;

    %% Analysis

    [ ~, ~, ~, ~, nnetCoordinates, targetCoordinates ] = NNetAnalysis( nnet_file_name, sampleFile, emitter_coordinate_number );
    [ ~, ~, ~, ~, nnetCoordinates2, ~ ] = NNetAnalysis( nnet_file2_name, sampleFile, emitter_coordinate_number );
    %[ ~, ~, ~, ~, nnetCoordinates3, ~ ] = NNetAnalysis( nnet_file3_name, sampleFile, emitter_coordinate_number );
    %[ ~, ~, ~, ~, nnetCoordinates4, ~ ] = NNetAnalysis( nnet_file4_name, sampleFile, emitter_coordinate_number );
    %[ ~, ~, ~, ~, nnetCoordinates5, ~ ] = NNetAnalysis( nnet_file5_name, sampleFile, emitter_coordinate_number );
    %[ ~, ~, ~, ~, nnetCoordinates6, ~ ] = NNetAnalysis( nnet_file6_name, sampleFile, emitter_coordinate_number );
    %[ ~, ~, ~, ~, nnetCoordinates7, ~ ] = NNetAnalysis( nnet_file7_name, sampleFile, emitter_coordinate_number );
    %[ ~, ~, ~, ~, nnetCoordinates8, ~ ] = NNetAnalysis( nnet_file8_name, sampleFile, emitter_coordinate_number );
    
    nnetCoordinates = (nnetCoordinates + nnetCoordinates2) ./ 2;
    
    errors = gsubtract(nnetCoordinates, targetCoordinates);  % matrix of errors for each value of the sample
    errors(:, 4:5) = errors(:, 4:5) /pi*180;  % convert tilt and azimuth to degrees

    linear_errors = errors(:, 1:3);
    linear_errors = linear_errors(:);
    linear_errors_rms = rms(linear_errors);
    linear_errors = abs(linear_errors);

    % build distribution for linear coordinates errors, and draw
    [~, ~, ~] = BuildDistribution(linear_errors);

    angular_errors = errors(:, 4:5);
    angular_errors = angular_errors(:);
    angular_errors_rms = rms(angular_errors);
    angular_errors = abs(angular_errors);

    % build distribution for angular coordinates errors, and draw
    [~, ~, ~] = BuildDistribution(angular_errors);

    
    %{
    
    %% save data

    % linear:
    linear_errors_rms_file = strcat('.\Data\Solving\linear_errors_rms_', num2str(receivers_number), ...
                                    'receiv_shift_receivers_adaptive_150-800-100.dat');
    if exist(linear_errors_rms_file, 'file')
        linear_errors_rms_table = load(linear_errors_rms_file);
    else
        linear_errors_rms_table = zeros(0, 2);
    end
    linear_errors_rms_table( size(linear_errors_rms_table, 1) + 1, :) = [shift_RMS, linear_errors_rms];
    linear_errors_rms_table = sortrows(linear_errors_rms_table, 1);
    dlmwrite(linear_errors_rms_file, linear_errors_rms_table);


    % angular:
    angular_errors_rms_file = strcat('.\Data\Solving\angular_errors_rms_', num2str(receivers_number), ...
                                    'receiv_shift_receivers_adaptive_150-800-100.dat');
    if exist(angular_errors_rms_file, 'file')
        angular_errors_rms_table = load(angular_errors_rms_file);
    else
        angular_errors_rms_table = zeros(0, 2);
    end
    angular_errors_rms_table( size(angular_errors_rms_table, 1) + 1, :) = [shift_RMS, angular_errors_rms];
    angular_errors_rms_table = sortrows(angular_errors_rms_table, 1);
    dlmwrite(angular_errors_rms_file, angular_errors_rms_table);
%}





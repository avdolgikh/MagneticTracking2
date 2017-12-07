function [ numWeightElements, receivers_number, linear_errors_rms, angular_errors_rms, nnetCoordinates, targetCoordinates ] = NNetAnalysis( nnet_file_name, sampleFile, emitter_coordinate_number )

    % load the net:
    nnetData = load(nnet_file_name);
    nnet = nnetData.nnet;
    numWeightElements = nnet.numWeightElements;
    %view(nnet);

    % load a sample
    sample = load(sampleFile);
    
    [~, ~, receivers_number, coordinates_ind, mutual_inductance_ind] = ...
                                            GetSampleInfo(sample, emitter_coordinate_number);

    mutualInductances = sample(:, mutual_inductance_ind);
    targetCoordinates = sample(:, coordinates_ind);

    % normalization of M:
    mutualInductances = Normalization( mutualInductances, -9.7134e-08, 6.1524e-08, [-1 1] );
    
    nnetCoordinates = SolveEmitterByNNet( mutualInductances, nnet );

    % denormalization of NNet output:
    nnetCoordinates(:, 1:3) = Denormalization( nnetCoordinates(:, 1:3), -0.09, 0.09, [-1 1] );
    nnetCoordinates(:, 4:5) = Denormalization( nnetCoordinates(:, 4:5), 0.034907, 0.18151, [-1 1] );

    
    
    errors = gsubtract(nnetCoordinates, targetCoordinates);  % matrix of errors for each value of the sample
    errors(:, 4:5) = errors(:, 4:5) /pi*180;  % convert tilt and azimuth to degrees

    linear_errors = errors(:, 1:3);
    linear_errors = linear_errors(:);
    linear_errors_rms = rms(linear_errors);
    linear_errors = abs(linear_errors);

    % build distribution for linear coordinates errors, and draw
    %[~, ~, ~] = BuildDistribution(linear_errors);

    angular_errors = errors(:, 4:5);
    angular_errors = angular_errors(:);
    angular_errors_rms = rms(angular_errors);
    angular_errors = abs(angular_errors);

    % build distribution for angular coordinates errors, and draw
    %[~, ~, ~] = BuildDistribution(angular_errors);

end


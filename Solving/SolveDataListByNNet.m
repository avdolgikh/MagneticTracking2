function [ solve_result ] = SolveDataListByNNet( emitter_data, data_size_to_solve, emitter_coordinate_number, nnet )

    [sample_size, ~, ~, coordinates_ind, mutual_inductance_ind] = ...
                    GetSampleInfo(emitter_data, emitter_coordinate_number);
    
    if (data_size_to_solve > sample_size)
        data_size_to_solve = sample_size;
    end
    
    % decreasing of data size:
    shufle_rowInd = randperm( sample_size );
    emitter_data = emitter_data( shufle_rowInd( 1 : data_size_to_solve), :);
    
    time_spent = zeros(data_size_to_solve, 1);
    calculated_coordinates = zeros(data_size_to_solve, emitter_coordinate_number);
    
    for row_index = 1 : data_size_to_solve

        fprintf('Row with index %d is being proceeded.\n', row_index);

        % Start stopwatch timer
        tic;

        calculated_coordinates(row_index, :) = SolveEmitterByNNet( emitter_data(row_index, mutual_inductance_ind), nnet);

        % Read elapsed time from stopwatch
        time_spent(row_index, :) = toc;
        
    end

    errors = gsubtract(calculated_coordinates, emitter_data(1:data_size_to_solve, coordinates_ind) );  % matrix of errors for each value of the sample
    
    solve_result = BuildSolveResult( abs(errors(:, 1:3)), abs(errors(:, 4:5)), time_spent );

end


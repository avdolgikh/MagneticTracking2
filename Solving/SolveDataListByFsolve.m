function [ solve_result ] = SolveDataListByFsolve( emitter_data, parallel_factor, data_size_to_solve, emitter_coordinate_number, receivers )

    [sample_size, ~, ~, coordinates_ind, mutual_inductance_ind] = ...
                    GetSampleInfo(emitter_data, emitter_coordinate_number);
    
    solve_matrix = [];
    data_portions = {};
    
    if (data_size_to_solve > sample_size)
        data_size_to_solve = sample_size;
    end
    
    distance_between_portions = floor( sample_size / parallel_factor );
    rows_in_portion = floor( data_size_to_solve / parallel_factor );
    
    for portion_index = 1 : parallel_factor
        portion_start_index = (portion_index - 1) * distance_between_portions + 1;
        portion_end_index = portion_start_index + rows_in_portion - 1;
        data_portions {portion_index} = emitter_data(portion_start_index : portion_end_index, :);
    end
    

    % TODO: transfer as parameters:
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


    InitParallelRun();

    parfor portion_index = 1 : parallel_factor
    %for portion_index = 1 : parallel_factor
    
        data_portion = data_portions { portion_index };
        emitter_coordinates_0 = data_portion(1, 1 : emitter_coordinate_number);
    
        time_spent = zeros(rows_in_portion - 1, 1);
        calculated_coordinates = zeros(rows_in_portion - 1, emitter_coordinate_number);
        
        for row_index = 2 : rows_in_portion

            fprintf('Portion_index: %d, row_index: %d.\n', portion_index, row_index);

            % Start stopwatch timer
            tic;

            calculated_coordinates_row = SolveEmitterByFsolve( data_portion(row_index, mutual_inductance_ind), receivers, ...
                                    emitter_coordinates_0, emitter_radius, receiver_radius, NpxNs, ...
                                    divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n );
            
            calculated_coordinates(row_index - 1, :) = calculated_coordinates_row;
            
            emitter_coordinates_0 = calculated_coordinates_row;

            % Read elapsed time from stopwatch
            time_spent(row_index - 1, :) = toc;

        end
        
        errors = gsubtract(calculated_coordinates, data_portion(2:rows_in_portion, coordinates_ind) );  % matrix of errors for each value of the sample
    
        solve_matrix(portion_index, :)  = BuildSolveResult( abs(errors(:, 1:3)), abs(errors(:, 4:5)), time_spent );
        
    end

    solve_result = [max(solve_matrix(:, 1))
        max(solve_matrix(:, 2))
        mean(solve_matrix(:, 3))
        mean(solve_matrix(:, 4))
        min(solve_matrix(:, 5))
        max(solve_matrix(:, 6))
        mean(solve_matrix(:, 7))
        min(solve_matrix(:, 8))
        max(solve_matrix(:, 9))
        mean(solve_matrix(:, 10))
        min(solve_matrix(:, 11))];
end


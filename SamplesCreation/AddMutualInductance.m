function [ emitter_info, noised_emitter_info ] = AddMutualInductance( emitter_positions, receivers, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n) %, SNR_dB )
%function [ emitter_info, noised_emitter_info ] = AddMutualInductance( emitter_positions, receivers, emitter_turns_number, receiver_turns_number, emitter_radius, receiver_radius, emitter_length, receiver_length, calculating_discretization, SNR_dB )

    emitter_info = [];
    noised_emitter_info = [];
    
    parfor row_index = 1 : size(emitter_positions, 1)
    %for row_index = 1 : size(emitter_positions, 1)
         
        mutual_inductances = [];
        %noised_mutual_inductances = [];
        
        for r_row_index = 1 : size(receivers, 1)
            %{
            mutual_inductance = CalculateMutualInductance( emitter_positions(row_index,:), ...
                                                          receivers(r_row_index,:), ...
                                                          [emitter_radius, emitter_radius, receiver_radius, receiver_radius], ...
                                                          calculating_discretization, ...
                                                          [emitter_turns_number, receiver_turns_number], ...
                                                          [emitter_length, receiver_length] );            
            %}
            mutual_inductance = CalculateMutualInductance( emitter_positions(row_index,:), ...
                                                          receivers(r_row_index,:), ...
                                                          Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, ...
                                                          z_g_coef, z_p_coef, S, N, m, n );
                                          
            mutual_inductances = [mutual_inductances, mutual_inductance];
            
            %{
            noised_mutual_inductances = [noised_mutual_inductances, ...
                                             AddNoise( mutual_inductance, SNR_dB )];
            %}
        end
        
        fprintf('Row with index %d has been processed.\n', row_index);
        
        emitter_info(row_index, :) = [emitter_positions(row_index,:), mutual_inductances];
        %noised_emitter_info(row_index, :) = [emitter_positions(row_index,:), noised_mutual_inductances];
    end

end


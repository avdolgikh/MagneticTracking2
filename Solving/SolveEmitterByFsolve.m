function [ emitter_coordinates ] = SolveEmitterByFsolve( mutual_inductances, receivers, emitter_coordinates_0, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n )

    equation_system = @(emitter_coordinates) Equations4SolvingCoordinatesByMutualInductances( emitter_coordinates, ...
                                receivers, mutual_inductances, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, ...
                                xy_p_coef, z_g_coef, z_p_coef, S, N, m, n );
    
    options = optimset('Display','iter-detailed', 'Algorithm','levenberg-marquardt');
    % 'levenberg-marquardt' allows to use equation number more than unknowns number.
    
    [emitter_coordinates, exitflag, fval] = fsolve(equation_system, emitter_coordinates_0, options);

    fprintf('FSolve. Done.\n');
    
end


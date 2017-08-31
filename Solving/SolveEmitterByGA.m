function [ emitter_coordinates ] = SolveEmitterByGA( mutual_inductances, receivers, emitter_sphera_max_radius, emitter_angular_coordinate_min, emitter_angular_coordinate_max, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n )
    % Number of coordinates = 5. TODO: pass as a parameter?

    lb = [-emitter_sphera_max_radius, -emitter_sphera_max_radius, -emitter_sphera_max_radius, ...
                        emitter_angular_coordinate_min, emitter_angular_coordinate_min];
    ub = [emitter_sphera_max_radius, emitter_sphera_max_radius, emitter_sphera_max_radius, ...
                        emitter_angular_coordinate_max, emitter_angular_coordinate_max];


    equation_system = @(emitter_coordinates) Equation4GASolvingCoordinatesByMutualInductances( emitter_coordinates, ...
                                receivers, mutual_inductances, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, ...
                                xy_p_coef, z_g_coef, z_p_coef, S, N, m, n );
    
    [emitter_coordinates, fval, exitflag] = ga( equation_system, 5, [], [], [], [], lb, ub, @eqCon);
    
end

function [c, ceq] = eqCon(emitter_coordinates)
    ceq = [];
    c = [];
end

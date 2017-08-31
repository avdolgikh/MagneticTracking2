function [ F ] = Equation4GASolvingCoordinatesByMutualInductances( coordinates, receivers, mutual_inductances, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n )

    F = 0;
    
    for index = 1 : size(receivers, 1)
        
        F = F + abs(CalculateMutualInductance( coordinates, receivers(index,:), ...
                                Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, ...
                                z_p_coef, S, N, m, n ) - mutual_inductances(index));
    end

end

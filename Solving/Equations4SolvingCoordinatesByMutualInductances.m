function [ F ] = Equations4SolvingCoordinatesByMutualInductances( coordinates, receivers, mutual_inductances, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n )

    F = [];
    
    for index = 1 : size(receivers, 1)
        
        F(index, :) = CalculateMutualInductance( coordinates, receivers(index,:), ...
                                Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, ...
                                z_p_coef, S, N, m, n ) - mutual_inductances(index);
    end

end





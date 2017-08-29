function [ M ] = Babic_MultiturnsCoils_withPrecalculation( Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xc, yc, zc, xy_p_coef, z_g_coef, z_p_coef, a, b, c, S, N, m, n )

    % Variable for positioning:
    xy_p_coef_a = xy_p_coef * a;
    xy_p_coef_b = xy_p_coef * b;
    z_p_coef_c = z_p_coef * c;
 
    %% Calculation:

    M = 0.0;
    for g = -S : S
       for h = -N : N
           for p = -m : m
               for q = -n : n
                   
                   Rp_h = Rp + Rp_h_coef * h; % TODO: array could be precalculated, invariant for positioning 
                   Rs_q = Rs + Rs_q_coef * q; % TODO: array could be precalculated, invariant for positioning
                   
                   x_p = xc + xy_p_coef_a * p;
                   y_p = yc + xy_p_coef_b * p;
                   z_g_p = zc + z_g_coef * g + z_p_coef_c * p;
                   
                   M = M + Babic_24( Rp_h, Rs_q, [x_p y_p z_g_p], [a b c]);
                   
               end
           end
       end 
    end
    
    M = NpxNs * M / divider; 


end


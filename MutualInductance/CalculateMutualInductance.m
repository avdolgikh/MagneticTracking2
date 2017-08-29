function [ M ] = CalculateMutualInductance( coord_p, coord_s, Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, xy_p_coef, z_g_coef, z_p_coef, S, N, m, n )
%function [ M ] = CalculateMutualInductance( coord_p, coord_s, radii, discretization, turns_numbers, lengths )
% Mutual inductance of 2 coils with any positions/orientations
% coord_p: [xp, yp, zp, tilt_p, azimuth_p] - coordinates of the primary coil
% coord_s: [xs, ys, zs, tilt_s, azimuth_s] - coordinates of the secondary coil
% radii: [R1, R2, R3, R4] - R1 - inner radius of primary coil
%                           R2 - outer radius of primary coil
%                           R3 - inner radius of secondary coil
%                           R4 - outer radius of secondary coil
% discretization: [S, N, m, n] - S - vertical dividing of primary coil (to 2S+1)
%                                N - horizontal dividing of primary coil (to 2N+1)
%                                m - vertical dividing of secondary coil (to 2m+1)
%                                n - horizontal dividing of secondary coil (to 2n+1)
% turns_numbers: [Np, Ns] - Np - the total number of turns for the primary coil
%                           Ns - the total number of turns for the secondary coil 
% lengths: [length_p, length_s] - length_p - length of the primary coil
%                                 length_s - length of the secondary coil

%{
    % TODO: separate function:
    % Validate (and tune) that Rp >= Rs:
    Rp = (radii(1) + radii(2)) * 0.5;
    Rs = (radii(3) + radii(4)) * 0.5;
    
    if (Rs > Rp)
        temp_R3 = radii(3);
        temp_R4 = radii(4);
        radii(3) = radii(1);
        radii(4) = radii(2);
        radii(1) = temp_R3;
        radii(2) = temp_R4;

        temp_coord_s = coord_s;
        coord_s = coord_p;
        coord_p = temp_coord_s;

        discretization = [discretization(3) discretization(4) discretization(1) discretization(2)];
    
        turns_numbers = [turns_numbers(2) turns_numbers(1)];

        lengths = [lengths(2) lengths(1)];
    end
%}


    [coil_s_center, coil_s_normal] = TransformPrimaryCoil2ZeroCoordinates( coord_p, coord_s ); 


    % Resolve according to the paper:
        % Slobodan Babic "Mutual Inductance Calculation between
            % Misalignment Coils for Wireless Power Transfer of Energy":
    %M = Babic_MultiturnsCoils( radii, coil_s_center, coil_s_normal, discretization, turns_numbers, lengths);
    
    M = Babic_MultiturnsCoils_withPrecalculation( Rp, Rs, NpxNs, divider, Rp_h_coef, Rs_q_coef, ...
                                coil_s_center(1), coil_s_center(2), coil_s_center(3), ...
                                xy_p_coef, z_g_coef, z_p_coef, ...
                                coil_s_normal(1), coil_s_normal(2), coil_s_normal(3), ...
                                S, N, m, n );
    
    %Draw2Coils( coord_p, coord_s, radii, lengths );

end


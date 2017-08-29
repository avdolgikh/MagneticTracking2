function [coil_s_center, coil_s_normal] = TransformPrimaryCoil2ZeroCoordinates( coord_p, coord_s )
% Transform (move and rotate) coordinates (linear and angular ones) of secondary coil
% to achieve the following: primary coil's coordinates are equal to (0, 0, 0, 0, 0).
% Return:
% coil_s_center - new coordinates of secondary coil center: [xc, yc, zc]
% coil_s_normal - new normal to plane of secondary coil: [a, b, c]

    % Recover coordinates:
    xp = coord_p(1);
    yp = coord_p(2);
    zp = coord_p(3);
    tilt_p = coord_p(4);
    azimuth_p = coord_p(5);

    xs = coord_s(1);
    ys = coord_s(2);
    zs = coord_s(3);
    tilt_s = coord_s(4);
    azimuth_s = coord_s(5);

    %{
    % Old WRONG!!! strategy:
    coil_s_center = [xs - xp, ys - yp, zs - zp];
    tilt = tilt_s - tilt_p;
    azimuth = azimuth_s - azimuth_p;
    a = sin(azimuth) * sin(tilt);
    b = -cos(azimuth) * sin(tilt);
    c = cos(tilt);
    coil_s_normal = [a, b, c];
    %}
    
    % New strategy:
    % normal to plane of secondary coil:
    coil_s_normal = [0; 0; 1];
    coil_s_normal = rotx(tilt_s /pi*180) * coil_s_normal;
    coil_s_normal = rotz(azimuth_s /pi*180) * coil_s_normal;

    % put primary coil into (0; 0; 0):
    coil_s_center = [xs - xp; ys - yp; zs - zp];

    % rotate around z on -azimuth_p:
    coil_s_center = rotz(-azimuth_p /pi*180) * coil_s_center;
    coil_s_normal = rotz(-azimuth_p /pi*180) * coil_s_normal;

    % rotate around x on -tilt_p:
    coil_s_center = rotx(-tilt_p /pi*180) * coil_s_center;
    coil_s_normal = rotx(-tilt_p /pi*180) * coil_s_normal;

    coil_s_center = coil_s_center';
    coil_s_normal = coil_s_normal';
    
end


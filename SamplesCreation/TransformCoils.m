
clear all;
clc;

%% Parameters:
xp = 0.02;
yp = 0.02;
zp = 0.01;
tilt_p = pi/3;
azimuth_p = pi/5;

xs = 0.03;
ys = -0.03;
zs = 0.03;
tilt_s = pi/5*2;
azimuth_s = pi/3*2;

radii = [0.01, 0.01, 0.015, 0.015];
legths = [0 0];


%% Task: move and rotate coils to achieve the following: 
            % primary coil is in (0, 0, 0, 0, 0)

% normal to plane of secondary coil:
coil_s_normal = [0; 0; 1];
coil_s_normal = rotx(tilt_s /pi*180) * coil_s_normal;
coil_s_normal = rotz(azimuth_s /pi*180) * coil_s_normal;

% put primary coil to (0; 0; 0):
coil_s_center = [xs - xp; ys - yp; zs - zp];

% rotate around z on -azimuth_p:
coil_s_center = rotz(-azimuth_p /pi*180) * coil_s_center;
coil_s_normal = rotz(-azimuth_p /pi*180) * coil_s_normal;

% rotate around x on -tilt_p:
coil_s_center = rotx(-tilt_p /pi*180) * coil_s_center;
coil_s_normal = rotx(-tilt_p /pi*180) * coil_s_normal;
            
tilt_s_ = acos(coil_s_normal(3));
azimuth_s_ = acos(-coil_s_normal(2) / sin(tilt_s_));

%{
% Old WRONG strategy:
coil_s_center = [xs - xp; ys - yp; zs - zp];
tilt_s_ = tilt_s - tilt_p;
azimuth_s_ = azimuth_s - azimuth_p;
%}

%% =================

% Before:
Draw2Coils( [xp, yp, zp, tilt_p, azimuth_p], ...
            [xs, ys, zs, tilt_s, azimuth_s], ...
            radii, legths );

% After:
Draw2Coils( [0, 0, 0, 0, 0], ...
            [coil_s_center(1), coil_s_center(2), coil_s_center(3), tilt_s_, azimuth_s_], ...
            radii, legths );

            
            
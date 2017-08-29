function [ volatile_coordinates ] = BuildVolatileEmitterCoordinates( emitter_coordinates, emitter_linear_step, emitter_angular_step )

    %{
    emitter_positions = [1 2; 3 4];
    emitter_linear_step = 0.2;
    emitter_angular_step = 0.3;
    %}

    %volatile_coordinates = emitter_coordinates + rand(size(emitter_coordinates)) * min(emitter_linear_step, emitter_angular_step);
    
    volatile_coordinates(:, 1:3) = emitter_coordinates(:, 1:3) + rand(size(emitter_coordinates, 1), 3) * emitter_linear_step;
    
    volatile_coordinates(:, 4:5) = emitter_coordinates(:, 4:5) + rand(size(emitter_coordinates, 1), 2) * emitter_angular_step;
    
    
    %{
    figure('Name', 'XYZ', 'NumberTitle', 'off');
    plot3(volatile_coordinates(:, 1), volatile_coordinates(:, 2), volatile_coordinates(:, 3), '.');
    set(gca,'DataAspectRatioMode','Manual');
    grid on;
    hold on;
    
    figure('Name', 'Angles YZ - Tilt', 'NumberTitle', 'off');
    title( 'Angles YZ - Tilt' );
    tilt = volatile_coordinates(:, 4);
    rho = ones(size(tilt, 1),1);
    polar(tilt, rho, 'or');
    
    figure('Name', 'Angles XY - Azimuth', 'NumberTitle', 'off');
    title( 'Angles XY - Azimuth' );
    azimuth = volatile_coordinates(:, 5);
    rho = ones(size(azimuth, 1),1);
    polar(azimuth, rho, 'or');
    %}
    
end


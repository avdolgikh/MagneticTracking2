function [ coordinates ] = BuildEmitterCoordinates( radius, linear_step, angular_step, angular_coordinate_min, angular_coordinate_max )

    
    % Simple (and fast) strategy:    
    positions = BuildPositions_bySquareGrid( radius, linear_step );
    %positions = BuildPositions_bySpheraBuiltinFun( radius, linear_step );
    orientations = (angular_coordinate_min : angular_step : angular_coordinate_max);
    orientations = combvec(orientations, orientations)';
    coordinates = combvec(positions', orientations')';   
    
    

    %{
    % The following strategy means that neighboring rows in the resulting matrix
    % always contain neighboring coordinates.
    % So, row-by-row, matrix describes linked movement of a point.
    coordinates = BuildEmitterCoordinates2EmulateMovement(radius, linear_step, ...
                                    angular_step, angular_coordinate_min, angular_coordinate_max);
    %}
                                
    
    coordinates = coordinates( coordinates(:, 1).^2 + coordinates(:, 2).^2 + coordinates(:, 3).^2 <= radius^2, :);
    coordinates = coordinates( coordinates(:, 4) ~= 0, :); % if tilt = 0, azimuth value makes no sence. 
                            

    %{
    figure('Name', 'XYZ', 'NumberTitle', 'off');
    plot3(coordinates(:, 1), coordinates(:, 2), coordinates(:, 3), '.');
    set(gca,'DataAspectRatioMode','Manual');
    grid on;
    hold on;
    
    figure('Name', 'Angles YZ - Tilt', 'NumberTitle', 'off');
    title( 'Angles YZ - Tilt' );
    tilt = coordinates(:, 4);
    rho = ones(size(tilt, 1),1);
    polar(tilt, rho, 'or');
    
    figure('Name', 'Angles XY - Azimuth', 'NumberTitle', 'off');
    title( 'Angles XY - Azimuth' );
    azimuth = coordinates(:, 5);
    rho = ones(size(azimuth, 1),1);
    polar(azimuth, rho, 'or');
    %}
end


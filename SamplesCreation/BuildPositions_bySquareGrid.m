function [ positions ] = BuildPositions_bySquareGrid( radius, linear_step )

    x = -radius : linear_step : radius;
    y = -radius : linear_step : radius;
    z = -radius : linear_step : radius;
    positions = combvec(x, y, z)';
    %positions = positions( positions(:, 1).^2 + positions(:, 2).^2 + positions(:, 3).^2 <= radius^2, :);
    
end


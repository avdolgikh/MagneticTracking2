function [ coordinates ] = BuildEmitterCoordinates2EmulateMovement( radius, linear_step, angular_step, angular_coordinate_min, angular_coordinate_max )
% The following strategy means that neighboring rows in the resulting matrix
% always contain neighboring coordinates.
% So, row-by-row, matrix describes linked movement of a point.
    
    %{
    clear all;
    clc;
    
    radius = 0.1;
    linear_step = 0.1;
    angular_coordinate_min = 1;
    angular_coordinate_max = 2;
    angular_step = 1;
    %}

    coordinates = [];    

    linear_grid = -radius : linear_step : radius;
    angular_grid = angular_coordinate_min : angular_step : angular_coordinate_max;

    X = linear_grid;
    for index_x = 1 : length(X)
        if (mod(index_x, 2) ~= 0)
            Y = linear_grid;
        else
            Y = fliplr(linear_grid);
        end
        for index_y = 1 : length(Y)
            if (mod(index_y, 2) ~= 0)
                Z = linear_grid;
            else
                Z = fliplr(linear_grid);
            end
            for index_z = 1 : length(Z)
                if (mod(index_z, 2) ~= 0)
                    T = angular_grid;
                else
                    T = fliplr(angular_grid);
                end
                for index_t = 1 : length(T)
                    if (mod(index_t, 2) ~= 0)
                        A = angular_grid;
                    else
                        A = fliplr(angular_grid);
                    end
                    for index_a = 1 : length(A)
                        row = [X(index_x), Y(index_y), Z(index_z), T(index_t), A(index_a)];
                        coordinates = [coordinates; row];
                    end
                end
            end
        end
    end
    
end


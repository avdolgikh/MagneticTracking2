function [ positions ] = BuildPositions_bySpheraBuiltinFun( radius, linear_step )
%BUILDXYZ_BYSPHERABUILTINFUN Summary of this function goes here
%   Detailed explanation goes here

    positions = [];

    for internal_radius = linear_step : linear_step : radius
    
        points_in_meridian = ceil( pi * internal_radius / linear_step );
        [x, y, z] = sphere( points_in_meridian );
        linear_coordinates = unique([x(:) * internal_radius, y(:) * internal_radius, z(:) * internal_radius], 'rows');

        positions = [positions; linear_coordinates];
        
    end
end


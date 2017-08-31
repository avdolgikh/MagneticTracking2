function [ linear_error, angular_error ] = ComputeErrors( sample_data_item, calculated_data_item )

    % Recover original coordinates:
    x = sample_data_item(1);
    y = sample_data_item(2);
    z = sample_data_item(3);
    tilt = sample_data_item(4);
    azimuth = sample_data_item(5);

    % Linear error:
    x_error = abs(x - calculated_data_item(1));
    y_error = abs(y - calculated_data_item(2));
    z_error = abs(z - calculated_data_item(3));

    linear_error = [x_error, y_error, z_error];

    % Angular error:
    tilt_error = abs(tilt - calculated_data_item(4));
    azimuth_error = abs(azimuth - calculated_data_item(5));

    angular_error = [tilt_error, azimuth_error];
    
end


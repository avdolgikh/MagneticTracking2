function [ solve_result ] = BuildSolveResult( linear_errors, angular_errors, time_spent )

    % Linear error: {m}
    linear_error_max = max(linear_errors(:));
    linear_error_max_3D = linear_error_max * sqrt(3);
    linear_error_mean = mean(linear_errors(:));
    linear_error_mean_3D = linear_error_mean * sqrt(3);
    linear_error_min = min(linear_errors(:));

    % Angular error: {degree}
    angular_error_max = max(angular_errors(:)) / pi * 180;
    angular_error_mean = mean(angular_errors(:)) / pi * 180;
    angular_error_min = min(angular_errors(:)) / pi * 180;

    % Time measuring:
    time_spent_max = max(time_spent);
    time_spent_mean = mean(time_spent);
    time_spent_min = min(time_spent);

    solve_result = [linear_error_max, linear_error_max_3D, ...
        linear_error_mean, linear_error_mean_3D, linear_error_min, ...
        angular_error_max, angular_error_mean, angular_error_min, ...
        time_spent_max, time_spent_mean, time_spent_min];


end


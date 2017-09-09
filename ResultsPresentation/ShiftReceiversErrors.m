clear all;
clc;

figure('Name', '1x9 NNet. Linear errors rms');
linear_errors_rms = load('.\Data\Solving\linear_errors_rms_9receiv_shift_receivers_adaptive.dat');
plot(linear_errors_rms(:, 1), linear_errors_rms(:, 2));
grid on;
xlabel('Receivers linear error rms, m');
ylabel('Tracking (emitter) linear error rms, m');

figure('Name', '1x9 NNet. Angular errors rms');
angular_errors_rms = load('.\Data\Solving\angular_errors_rms_9receiv_shift_receivers_adaptive.dat');
plot(angular_errors_rms(:, 1), angular_errors_rms(:, 2));
grid on;
xlabel('Receivers linear error rms, m');
ylabel('Tracking (emitter) angular error rms, degree');

figure('Name', '1x12 NNet. Linear errors rms');
linear_errors_rms = load('.\Data\Solving\linear_errors_rms_12receiv_shift_receivers.dat');
plot(linear_errors_rms(:, 1), linear_errors_rms(:, 2));
grid on;
xlabel('Receivers linear error rms, m');
ylabel('Tracking (emitter) linear error rms, m');

figure('Name', '1x12 NNet. Angular errors rms');
angular_errors_rms = load('.\Data\Solving\angular_errors_rms_12receiv_shift_receivers.dat');
plot(angular_errors_rms(:, 1), angular_errors_rms(:, 2));
grid on;
xlabel('Receivers linear error rms, m');
ylabel('Tracking (emitter) angular error rms, degree');



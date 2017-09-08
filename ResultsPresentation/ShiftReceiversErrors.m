clear all;
clc;

linear_errors_rms = load('.\Data\Solving\linear_errors_rms_9receiv_shift_receivers.dat');
plot(linear_errors_rms(:, 1), linear_errors_rms(:, 2));

angular_errors_rms = load('.\Data\Solving\angular_errors_rms_9receiv_shift_receivers.dat');
plot(angular_errors_rms(:, 1), angular_errors_rms(:, 2));

linear_errors_rms = load('.\Data\Solving\linear_errors_rms_12receiv_shift_receivers.dat');
plot(linear_errors_rms(:, 1), linear_errors_rms(:, 2));

angular_errors_rms = load('.\Data\Solving\angular_errors_rms_12receiv_shift_receivers.dat');
plot(angular_errors_rms(:, 1), angular_errors_rms(:, 2));
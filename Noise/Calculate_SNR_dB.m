function [SNR_dB] = Calculate_SNR_dB( signal_rms, noise_rms )
    %CALCULATE_SNR_DB Calculates Signal-to-noise ratio in decibels.
    % signal_rms is root mean square (RMS) amplitude of original signal.
    % noise_rms is root mean square (RMS) amplitude of noise signal.
    
    % https://en.wikipedia.org/wiki/Signal-to-noise_ratio
    SNR = ( signal_rms ./ noise_rms ).^2; % Signal-to-noise ratio
    SNR_dB = 10 * log10(SNR); % dB, Signal-to-noise ratio

end


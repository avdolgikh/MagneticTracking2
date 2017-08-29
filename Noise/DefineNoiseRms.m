function [noise_rms] = DefineNoiseRms( signal_rms, SNR_dB )        

    noise_rms = signal_rms / sqrt(10 ^ (SNR_dB / 10));

end

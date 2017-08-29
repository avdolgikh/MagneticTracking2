function [ noised_signal_value ] = AddNoise( signal_value, SNR_dB )
    
    noise_rms = DefineNoiseRms( signal_value, SNR_dB );
    
    noise = randn * noise_rms; % Distribution - Normal
                               % mu = 0;
                               % standart diviation = noise_rms;
        
    noised_signal_value = signal_value + noise; % additive noise!

end

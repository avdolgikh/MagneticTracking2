function noised_signal = AddAwgnNoise( original_signal, SNR_dB, noise_initial_seed )
    % Adds AWGN noise vector to the signal 'original_signal' to generate a
    %resulting signal vector noised_signal of specified SNR in dB
    
    % http://www.gaussianwaves.com/2015/06/how-to-generate-awgn-noise-in-matlaboctave-without-using-in-built-awgn-function/
    
    % noised_signal = awgn( original_signal, SNR_dB, 'measured', noise_initial_seed );
    
    
    signal_power = SignalPower( original_signal ); % Calculate actual symbol energy
    SNR = 10 ^ (SNR_dB / 10); % SNR to linear scale
    N0 = signal_power / SNR; % Find the noise spectral density
    rng(noise_initial_seed); % set the random generator seed
    signal_length = length(original_signal);
    
    if (isreal(original_signal)),
        noiseSigma = sqrt(N0); % Standard deviation for AWGN Noise when original_signal is real
        noise = noiseSigma * randn(1, signal_length); % computed noise
    else
        noiseSigma = sqrt(N0/2); % Standard deviation for AWGN Noise when original_signal is complex
        noise = noiseSigma * (randn(1, signal_length) + 1i * randn(1, signal_length)); % computed noise
    end    
    
    if (~isrow(original_signal))
        noise = transpose(noise);
    end
        
    noised_signal = original_signal + noise;
end





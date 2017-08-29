function power = SignalPower( signal )
%SIGNALPOWER is function for defining the power of input signal (vector)
%   

% http://www.gaussianwaves.com/2015/06/how-to-generate-awgn-noise-in-matlaboctave-without-using-in-built-awgn-function/

signal_length = length(signal);

power = sum( abs(signal).^2 ) / signal_length; % calculate actual symbol energy

end


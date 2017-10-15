function [ normalized_data ] = Normalization( data, min_data, max_data, interval )
% data - vector of data to be normalized
% interval - new interval of data, e.g. [-1 1]

%min_data = min(data(:));
%max_data = max(data(:));

normalized_data = (data - min_data) ./ ( max_data - min_data ); % => [0 1]
normalized_data = normalized_data .* ( interval(2) - interval(1) ) + interval(1);

end


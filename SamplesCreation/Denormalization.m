function [ data ] = Denormalization( normalized_data, min_data, max_data, interval )

    data = (normalized_data - interval(1)) ./ ( interval(2) - interval(1) ); % => [0 1]
    data = data .* ( max_data - min_data ) + min_data; 

end


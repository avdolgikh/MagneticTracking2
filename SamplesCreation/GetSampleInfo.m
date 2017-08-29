function [sample_size, sample_vector_length, receivers_number, coordinates_ind, mutual_inductance_ind] = GetSampleInfo(sample, coordinate_number)
%GETSAMPLEINFO Summary of this function goes here
%   Detailed explanation goes here

    sample_size = size(sample, 1);
    sample_vector_length = size(sample, 2);
    receivers_number = sample_vector_length - coordinate_number;
    coordinates_ind = 1 : coordinate_number;
    mutual_inductance_ind = (coordinate_number + 1) : (coordinate_number + receivers_number);

end


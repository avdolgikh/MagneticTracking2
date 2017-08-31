function [ emitter_coordinates ] = SolveEmitterByNNet( mutual_inductances, nnet )

    emitter_coordinates = nnet( mutual_inductances' )';
    
end


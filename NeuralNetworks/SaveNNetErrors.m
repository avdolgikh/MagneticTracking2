function [] = SaveNNetErrors( nnet, nnet_errors_file_name, training_error, generalization_error )

if exist(nnet_errors_file_name, 'file')
    nnet_errors = load(nnet_errors_file_name);
else
    nnet_errors = zeros(0, 6);
end

nnet_errors( size(nnet_errors, 1) + 1, :) = [
                nnet.numWeightElements
                training_error
                generalization_error
                nnet.layers{1}.size
                nnet.layers{2}.size
                nnet.layers{3}.size];
            % TODO: automate layer number defining.
            
nnet_errors = sortrows(nnet_errors, 1);

dlmwrite(nnet_errors_file_name, nnet_errors);

end


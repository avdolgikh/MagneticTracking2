function [ number ] = CalculateNNetFreeParamsNumber( inputSize, outputSize, hiddenLayerSize )
% Calcualtes number of weight elements of full-connected feedworward neural network

number = (inputSize + 1) * hiddenLayerSize(1);

for index = 1:size(hiddenLayerSize, 2)-1
   number = number + (hiddenLayerSize(index) + 1) * hiddenLayerSize(index + 1);
end

number = number + (hiddenLayerSize(end) + 1) * outputSize;

end



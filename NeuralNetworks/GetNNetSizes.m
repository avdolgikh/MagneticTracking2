function [ nnet_sizes ] = GetNNetSizes( freeParamsSizeRange, nnet_number, inputSize, outputSize )
    % Number of hidden layers = 3 (hard code).

    lb = [outputSize*4 outputSize*4 outputSize*4];
    ub = [outputSize*30 outputSize*30 outputSize*30];

    nnet_sizes = zeros(0, 3);
    
    step = round( ( freeParamsSizeRange(2) - freeParamsSizeRange(1) ) / nnet_number );
    
    for freeParamsSize = freeParamsSizeRange(1) : step : freeParamsSizeRange(2)
    
        equation = @(hiddenLayerSize) (  abs( CalculateNNetFreeParamsNumber( inputSize, outputSize, ...
			[hiddenLayerSize(1) hiddenLayerSize(2) hiddenLayerSize(3)] ) ...
				- freeParamsSize ) );

        [hiddenLayerSize, fval, exitflag] = ga(equation, 3, [], [], [], [], lb, ub, @eqCon, [1 2 3]);
     
        if (~Contains(nnet_sizes, hiddenLayerSize))
            nnet_sizes( size(nnet_sizes,1) + 1, :) = hiddenLayerSize;
        end
    end
   
end

function [c, ceq] = eqCon(hiddenLayerSize)
    ceq = [];
    c = [
	    1.5 - hiddenLayerSize(1)/hiddenLayerSize(2);
	    1.5 - hiddenLayerSize(2)/hiddenLayerSize(3);
        ];
end

function [c] = Contains(matrix, row)
    c = sum(ismember(matrix, row, 'rows')) > 0;
end


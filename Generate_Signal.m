function [signal] = Generate_Signal(params)
% Generates various types of signals
%
% Syntax: 
%    [signal] = Generate_Signal(params)
%
% Description: 
%     This function creates a signal. It takes in a size paramter and a
%     params.signalType paramter. The size paramter specifies the size of the
%     signal to be produced while the params.signalType parameter specifies what
%     type of signal will be produced
%
% Inputs:
%     params.signalType   - The type of signal to be produced. 0 is a random
%                       signal. 1 is a sine wave. 2 is a constant signal.
%     params.nSignal      - The size of the signal to be produced
%
% Outputs:
%     signal           - A 1D vector which contains the values of the
%                           signal. 
%
% Optional key/value pairs:
%     None.
%
% See also: 
%
% History:
%   02/14/18  ak   First Draft.
%   03/22/18  ak   Updated style to make uniform with rest of code

%% Create a signal with given length
secondDim = params.nSignal^(params.dimension -1);
n = rand;
signal = zeros(params.nSignal, secondDim);
%% Fill in values in accordance with the type of signal specified
if params.signalType == 0
    for i = 1:params.nSignal
        if params.dimension == 1
            signal(i) = rand;
        else
            for j = 1:params.nSignal
                signal(i,j) = rand;
            end
        end
    end
elseif params.signalType == 1
    for i = 1:params.nSignal
        if params.dimension == 1
            signal(i) = sin(pi * i / 32);
        else
            for j = 1:params.nSignal
                signal(i,j) = sin(pi * i * j/32);
            end
        end
    end
elseif params.signalType == 2
    for i = 1:params.nSignal
        if params.dimension == 1
            signal(i) = n;
        else
            for j = 1:params.nSignal
                signal(i,j) = n;
            end
        end
    end
else
    error("Not a valid option for signal type");
end


function [signal] = Generate_Signal(signal_type,max_size)
% Generates various types of signals
%
% Syntax: 
%    [signal] = Generate_Signal(signal_type,max_size)
%
% Description: 
%     This function creates a signal. It takes in a size paramter and a
%     signal_type paramter. The size paramter specifies the size of the
%     signal to be produced while the signal_type parameter specifies what
%     type of signal will be produced
%
% Inputs:
%     signal_type   - The type of signal to be produced. 0 is a random
%                       signal. 1 is a sine wave. 2 is a constant signal.
%     max_size      - The size of the signal to be produced
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
n = rand;
signal = zeros(max_size, 1);

%% Fill in values in accordance with the type of signal specified
if signal_type == 0
    for i = 1:max_size
        signal(i) = rand;
    end
elseif signal_type == 1
    for i = 1:max_size
        signal(i) = sin(pi * i / 32);
    end
elseif signal_type == 2
    for i = 1:max_size
        signal(i) = n;
    end
else
    error("Not a valid option for signal type");
end


function [signal] = Generate_Signal(signal_type,max_size)
% Generate_Signal takes in a signal type and size and returns a signal
% matching the initial conditions
n = rand;
signal = zeros(max_size, 1);
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


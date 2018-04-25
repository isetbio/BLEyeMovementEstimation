function [] = Plot_Data(signal, recoveredSignal, interpolatedSignal, name, fig, params)
% Plot the original and recovered signals
%
% Syntax:
%   [] = Plot_Data(signal, recovered_signal, params)
%
% Description:
%   This function plots the original signal, data points, and interpolated
%   signal. It is used to visualize what the eye perceives in comparison
%   with what the stimulus actually is.
%
% Inputs:
%     samples            - A 2d vector containing all the samples used in
%                          the simulation
%     signal             - A 1D vector which contains the values of the
%                          original signal. 
%     recoveredSignal   -  A 1D vector which contains the values of the
%                          signal recovered using one of the analysis
%                          methods
%     interpolatedSignal - A 1D vector containing the interpolated signal
%                          based on the recovered signal
%     params             - Standard parameters structure for the calculation.
%                          See EyeMovements_1d for details 
% Outputs:
%    None.
%    
% Optional key/value pairs:
%    None.
%
% See also:
%
% History
%   03/22/18  ak    Finished modulating code
%   03/30/18  ak    Moved interpolation code to Interpolate function
%   04/22/18  ak    Modified function to allow trial by trial simulation

%% Plot the signals

% Plot the original signal and the data points from the recovered signal
imageEmbeddedReceptorIndex = find(recoveredSignal ~= 0);
figure(fig); clf; hold on
x = 1:params.nSignal;
plot(x, signal,'k','LineWidth', 3);
plot(x(imageEmbeddedReceptorIndex),recoveredSignal(imageEmbeddedReceptorIndex),...
    'ro','MarkerFaceColor','r','MarkerSize',12);

% Interpolate the data if the user indicated so
if params.interpolate > 0
    % Add interpolated image to the plot
    hold on;
    plot(x, interpolatedSignal,'b', 'LineWidth', 2);
end

% Set standard axis and legend
axis([1,params.nSignal,-1.5,1.5])
title(name);
if (params.interpolate > 0)
    legend("original signal", "samples", "eye's interpretation");
else
    legend("original signal", "samples");
end
end


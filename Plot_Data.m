function [] = Plot_Data(samples, signal, recovered_signal, params)
% Plot the original and recovered signals
%
% Syntax:
%   [] = Plot_Data(signal, recovered_signal, params)
%
% Description:
%   
%
% Inputs:
%     signal             - A 1D vector which contains the values of the
%                           original signal. 
%     recovered_signal   - A 1D vector which contains the values of the
%                           signal recovered using one of the analysis
%                           methods
%     params             - Standard parameters structure for the calculation.
%                           See EyeMovements_1d for details 
% Outputs:
%    None.
%    
% Optional key/value pairs:
%    None.
%
% See also:
%
% History
%   03/22/18  ak       Finished modulating code

%% Plot the signals

% Visualize the output for each trial as a row in a grayscale image
figure; clf; 
imshow(samples'/max(samples(:)), 'InitialMagnification', 1000);

% Plot the original signal and the data points from the recovered signal
imageEmbeddedReceptorIndex = find(recovered_signal ~= 0);
figure; clf; hold on
x = 1:params.nSignal;
plot(x, signal,'k','LineWidth', 3);
plot(x(imageEmbeddedReceptorIndex),recovered_signal(imageEmbeddedReceptorIndex),...
    'ro','MarkerFaceColor','r','MarkerSize',12);

% Interpolate the data if the user indicated so
if params.interpolate > 0
    interpolatedImage = interp1(x(imageEmbeddedReceptorIndex),...
        recovered_signal(imageEmbeddedReceptorIndex), x,'linear');
    
    % Add interpolated image to the plot
    hold on;
    plot(x, interpolatedImage,'b', 'LineWidth', 2);
end

% Set standard axis and legend
axis([1,params.nSignal,-1.5,1.5])

if (params.interpolate > 0)
    legend("original signal", "samples", "eye's interpretation");
else
    legend("original signal", "samples");
end

end


function [recoveredSignal, interpolatedSignal] = Method_0(samples, eye, params)
% Reconstruct signal with perfect knowledge of eye position history
%
% Syntax:
%   [recoveredSignal, interpolatedSignal] = Method_0(samples, eye, params)
%
% Description:
%   This runs the "simple" method of analysis. This method takes
%   the eye model, the receptor samples versus time matrix, and the parameters.
%
%   It uses the information to recover the signal.
%
%   At each time point, we have a response from each receptor. This method
%   assumes that the eye does not move and simply takes the average
%   response of each receptor as the recovered_signal
%
% Inputs:
%     eye                - A vector with 1's where there are receptors
%     samples            - A m by n matrix, where m is the number of time
%                          points and n is the number of receptors.  So
%                          each row is the responses at one time point.
%     params             - Standard parameters structure for the calculation.
%                           See EyeMovements_1d for details 
% Outputs:
%     recoveredSignal   - A 1D vector representing the signal that was
%                         created based on the brains interpretation of
%                         the sample data given the current method
%     interpolatedSignal -  A 1D vector that is the recovered signal after
%                           it has been interpolated       
%
% Optional key/value pairs:
%    None.
%
% See also:
%

% History
%   03/14/18  dhb, ak  Redefine interface.
%   03/22/18  ak       Finished modulating code
%   04/01/18  ak       Adjusted code to interpolate in method
  
%% Get the average response of each receptor
samples = samples';
% Get the average response of each receptor
averageOutput = mean(samples,1);

% Find eye's position with respect to vector indices
pos_0 = floor(params.nSignal/2) - floor(params.eyeSize/2);

%% Create the recovered signal
secondDim = params.nSignal^(params.dimension-1);
recoveredSignal = zeros(params.nSignal,secondDim);
imageEmbeddedReceptorIndex = find(eye == 1);
imageEmbeddedReceptorIndex = imageEmbeddedReceptorIndex + pos_0;
recoveredSignal(imageEmbeddedReceptorIndex) = averageOutput;

%% Get interpolated signal
x = 1:params.nSignal; 
imageEmbeddedReceptorIndex = find(recoveredSignal ~= 0);
effectiveReceptorLocations = x(imageEmbeddedReceptorIndex);
effectiveSamples = recoveredSignal(imageEmbeddedReceptorIndex);
imageLocations = x;
interpolatedSignal = Interpolate(effectiveReceptorLocations,...
effectiveSamples, imageLocations);



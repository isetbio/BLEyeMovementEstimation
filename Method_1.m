function [recoveredSignal, interpolatedSignal] = Method_1(eye,samples,positionHistory,params)
% Reconstruct signal with perfect knowledge of eye position history
%
% Syntax:
%   [recoveredSignal] = Method_1(eye,samples,positionHistory,params)
%
% Description:
%   This runs the "smart" method of analysis. This method takes
%   the eye model, the receptor samples versus time matrix, the
%   position history and the parameters.
%
%   It uses the information to recover the signal.
%
%   At each time point, we have a location for each receptor.  This defines
%   an effective position for each receptor at each time point, in the the
%   spatial domain of the signal.  Over time points, for each sampled
%   location, we can obtain the average response and use this to generate a
%   model of the signal that is formed using the given data
%
% Inputs:
%     eye                - A vector with 1's where there are receptors
%     samples            - A m by n matrix, where m is the number of time
%                          points and n is the number of receptors.  So
%                          each row is the responses at one time point.
%     positionHistory    - A vector containing the positional offset of the
%                          receptor array with respect to the signal, where 0
%                          means the receptor array is centered on the signal.
%                          Can be positive or negative.
%     params             - Standard parameters structure for the calculation.
%                          See EyeMovements_1d for details 
% Outputs:
%     recoveredSignal   - A 1D vector representing the signal that was
%                          created based on the brains interpretation of
%                          the sample data given the current method
%     interpolatedSignal -  A 1D vector that is the recovered signal after
%                           it has been interpolated 

% Optional key/value pairs:
%    None.
%
% See also:
%

% History
%   03/14/18  dhb, ak  Redefine interface.
%   03/22/18  ak       Finished modulating code
%   04/01/18  ak       Adjusted code to interpolate in method

%% Get the average response of each position that the eye had
repeats = zeros(params.nSignal,1);
image = zeros(params.nSignal,1);
receptor_index = find(eye==1)-1;

% Loop through and count the number of times each position was looked at by
% a receptor
for i = 1:params.nTimes
    adjustedPos = positionHistory(i) + floor(params.nSignal/2) - ...
        floor(params.eyeSize/2);
    adjustedReceptorIndex = receptor_index + adjustedPos;
    repeats(adjustedReceptorIndex) = repeats(adjustedReceptorIndex) + 1;
    image(adjustedReceptorIndex) = image(adjustedReceptorIndex) + ...
        samples(:,i);
end

image = image ./ repeats;
image(isnan(image)) = 0;
recoveredSignal = image;

%% Get interpolated signal
x = 1:params.nSignal; 
imageEmbeddedReceptorIndex = find(recoveredSignal ~= 0);
effectiveReceptorLocations = x(imageEmbeddedReceptorIndex);
effectiveSamples = recoveredSignal(imageEmbeddedReceptorIndex);
imageLocations = x;
interpolatedSignal = Interpolate(effectiveReceptorLocations,...
effectiveSamples, imageLocations);






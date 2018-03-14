function [recoveredSignal,effectiveSamples] = Method_1(eye,samples,positionHistory,params)
positionHistory,receptorIndex,signal,params)
% Reconstruct signal with perfect knowledge of eye position history
%
% Syntax:
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
%   location, we can obtain the average response.  The effectiveSamples is 
%   a 2 by N matrix, where the first row contains each position that was in
%   fact sampled over eye movements and the second row contains the
%   corresponding average response.
%
% Inputs:
%
% Outputs:
%
% Optional key/value pairs:
%    None.
%
% See also:
%

% History
%   03/14/18  dhb, ak  Redefine interface.

output = zeros(params.nTimes,params.eyeSize);
image = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
repeats = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
for i = 1:params.nTimes
    % Find position that we want, store it, and sample the signal
    % corresponding to the eye being in this position.
    pos = round(pos_0 + params.maxEyeMovement * (2 * rand - 1));
    positionHistory(i) = pos;
    outputThisPosition = eye .* buffered_signal(pos:pos+params.eyeSize-1);
    
    % Add noise to the receptor responses
    % Save the responses for this position.
    noise = randn(params.nReceptors, 1) * params.noiseSd;
    outputThisPosition(receptorIndex) = outputThisPosition(receptorIndex) + noise;
    image(pos:(pos + params.eyeSize-1)) = image(pos:(pos + params.eyeSize-1)) + outputThisPosition;
    repeats(pos:(pos + params.eyeSize-1)) = repeats(pos:(pos + params.eyeSize-1)) + eye;
    output(i,:) = image(pos+1:pos + params.eyeSize);
end

% Get the average response of each position that the eye had
image = image ./ repeats;
image(isnan(image)) = 0;
result = image(params.maxEyeMovement+1:params.maxEyeMovement + params.nSignal);
imageEmbeddedReceptorIndex = find(image ~= 0);

% Set up the x co-ordinates of the original and resulting signal
x = 1:params.nSignal;
x = x';
output_Image = result;

% Structure params.interpolate the data if the user indicated so
if params.interpolate > 0
    output_Image = interp1(x(imageEmbeddedReceptorIndex), result(imageEmbeddedReceptorIndex), x, 'linear', 'extrap');
end

% Plot the data
%
% Visualize the output for each trial as a row in a grayscale image
figure; clf; 
imshow(output'/max(output(:)));

% Make a graph that shows the signal, data, and recovered signal
figure; clf; hold on
plot(x, signal, 'r', 'LineWidth', 2);
hold on;
plot(x, output_Image, 'b', 'LineWidth', 2);
legend("original signal", "eye's interpretation");


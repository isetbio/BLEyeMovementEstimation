function [positionHistory] = Method_1(pos_0,eye,buffered_signal,...
    positionHistory,receptorIndex,signal,params)
%METHOD2 Summary of this function goes here
%   This runs the "smart" method of analysis. This method takes in 
%   the initial position, the eye model, the buffered signal, a field
%   called position history which it later returns containing the
%   eye positions chosen in each trial, the the set of receptors, the
%   signal, and the params set at the beginning of the program.
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
% get the average response of each position that the eye had
image = image ./ repeats;
image(isnan(image)) = 0;
result = image(params.maxEyeMovement+1:params.maxEyeMovement + params.nSignal);
imageEmbeddedReceptorIndex = find(image ~= 0);
%set up the x co-ordinates of the original and resulting signal
x = 1:params.nSignal;
x = x';
output_Image = result;
%params.interpolate the data if the user indicated so
if params.interpolate > 0
    output_Image = interp1(x(imageEmbeddedReceptorIndex), result(imageEmbeddedReceptorIndex), x, 'linear', 'extrap');
end
%plot the data
% Visualize the output for each trial as a row in a grayscale image
figure; clf; 
imshow(output'/max(output(:)));
figure; clf; hold on
plot(x, signal, 'r', 'LineWidth', 2);
hold on;
plot(x, output_Image, 'b', 'LineWidth', 2);
legend("original signal", "eye's interpretation");


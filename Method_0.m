function [positionHistory] = Method_0(pos_0,eye,buffered_signal,...
    positionHistory,receptorIndex,pos_0_image,signal,params)
%METHOD1 Summary of this function goes here
%   This runs the "simple" method of analysis. This method takes in 
%   the initial position, the eye model, the buffered signal, a field
%   called position history which it later returns containing the
%   eye positions chosen in each trial, the the set of receptors, the
%   signal, and the params set at the beginning of the program. 
output = zeros(params.nTimes,params.eyeSize);
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
    output(i,:) = outputThisPosition;
end

% Get the average response of each position that the eye had
averageOutput = mean(output,1);

% Visualize the output for each trial as a row in a grayscale image
figure; clf; 
imshow(output'/max(output(:)));

% Plot the signal and the corresponding average resonses
imageEmbeddedAverageOutput = zeros(params.nSignal,1);
imageEmbeddedAverageOutput(pos_0_image:(pos_0_image+params.eyeSize-1)) = averageOutput;
imageEmbeddedReceptorIndex = find(imageEmbeddedAverageOutput ~= 0);
figure; clf; hold on
x = 1:params.nSignal;
plot(x, signal,'r','LineWidth', 3);
plot(x(imageEmbeddedReceptorIndex),imageEmbeddedAverageOutput(imageEmbeddedReceptorIndex),'ro','MarkerFaceColor','r','MarkerSize',12);

% Interpolate the data if the user indicated so
if params.interpolate > 0
    interpolatedImage = interp1(x(imageEmbeddedReceptorIndex),imageEmbeddedAverageOutput(imageEmbeddedReceptorIndex), x,'linear','extrap');
    % Add interpolated image to the plot
    hold on;
    plot(x, interpolatedImage,'b', 'LineWidth', 2);
    legend("original signal", "samples", "eye's interpretation");
end


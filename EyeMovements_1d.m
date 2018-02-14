% EyeMovements_1d
%
% Description:
%    Simulates an "eye" that moves in one spatial dimensional dimension.
%    
%    At the top there are parameters that specify the size of the eye, the
%    number of receptors, how the receptors get distributed etc.  There are
%    also parameters that describe the type of signal that will be
%    simulated.
%

% History:
%   02/xx/18  ak       Wrote first draft.
%   02/14/18  ak, dhb  Added header comments to Anant's first draft.

% TODO:
%   (Boring things)
%   a) Fix code so you can specify maxEyeMovement = 0.
%   b) Then fix code so that with no eye movements, the samples line up
%   directly with the signal they are sampling, when the noise is also
%   zero.
%
%   (Interesting things)
%   a) Now lets add a smarter but not realisitc interpolation algorithm, 
%   that has access to exactly where the eye is at each time.

% Parameters describing what we'll simulate
params.nSignal = 128;           % Max size of signal vector
params.signalType = 1;          % 0 = random, 1 = sine wave, 2 = constant
params.eyeSize = 82;            % Number of pixels in the eye
params.nReceptors = 38;         % Number of receptors, can't exceed number of pixels.
params.eyeDistribution = 0;     % 0 = random, 1 = uniform
params.maxEyeMovement = 20;      % Maximum number of pixels the eye can go left/right
params.noiseSd = 0.05;          % Amount of noise added to receptor responses (sd)
params.nTimes = 10;             % Number of "times" to generate data for.
params.interpolate = 1;         % Decide whether or not to interpolate the data

% Set up some signal.  This is just a set of numbers on a vector of length
% params.nSignal.  You can generate random numbers, or draw a sine wave, or
% any pattern you like.  You can even have more than one option here,
% controlled by some flag.
%
% The signal gets inserted into a buffer that is larger and padded with
% zeros, so that we have room to move the eye.
signal = Generate_Signal(params.signalType, params.nSignal);
buffered_signal = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
buffered_signal(params.maxEyeMovement:params.maxEyeMovement + params.nSignal-1) = signal;

% Set up eye.  This inolves choosing positions for the params.nReceptors
% actual receptors in the vector that specifies the full eye.  You can
% again choose them at random or make them as regularly spaced as possible
% given the parameters, or have multiple options.  But, it would work for
% any choice of parameters as long as there are not more receptors than eye
% positions.
eye = Generate_Eye(params.eyeSize, params.nReceptors, params.eyeDistribution);
receptorIndex = find(eye == 1);

% Write a loop that chooses an eye position each time through and samples
% the signal from that eye position.  Define position 0 to be when the eye
% is centered on the signal. If receptors fall outside of the signal for
% any eye position, set their response to zero.
positionHistory = zeros(params.nTimes, 1);
pos_0 = round(params.nSignal/2) + params.maxEyeMovement - round(params.eyeSize/2);
pos_0_image = round(params.nSignal/2) - round(params.eyeSize/2);
%image = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
%repeats = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);

% Loop through and take a sample of what the eye sees for x number of trials
% Keep track of the position by adding it to the position history array
% Add some noise to the data in order to simulate the imperfections of the
% eye.
output = zeros(params.nTimes,params.eyeSize);
for i = 1:params.nTimes
    % Find position that we want, store it, and sample the signal
    % corresponding to the eye being in this position.
    pos = round(pos_0 + params.maxEyeMovement * (2 * rand - 1));
    positionHistory(i) = pos;
    outputThisPosition = eye .* buffered_signal(pos:pos+params.eyeSize-1);
    
    % Add noise to the receptor responses
    noise = randn(params.nReceptors, 1) * params.noiseSd;
    outputThisPosition(receptorIndex) = outputThisPosition(receptorIndex) + noise;
    
    % Save the responses for this position.
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
end

% Add interpolated image to the plot
hold on;
plot(x, interpolatedImage,'b', 'LineWidth', 2);
legend("original signal", "samples", "eye's interpretation");

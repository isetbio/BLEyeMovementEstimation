% Skeleton

% Parameters describing what we'll simulate
params.nSignal = 128;           % Max size of signal vector
params.signalType = 1;          % 0 = random, 1 = sine wave, 2 = constant
params.eyeSize = 82;            % Number of pixels in the eye
params.nReceptors = 38;         % Number of receptors, can't exceed number of pixels.
params.eyeDistribution = 1;     % 0 = random, 1 = uniform
params.maxEyeMovement = 40;     % Maximum number of pixels the eye can go left/right
params.noiseSd = 0.05;          % Amount of noise added to receptor responses (sd)
params.nTimes = 1000;             % Number of "times" to generate data for.
params.interpolate = 1;         % Decide whether or not to interpolate the data

% Set up some signal.  Thisis just a set of numbers on a vector of length
% params.nSignal.  You can generate random numbers, or draw a sine wave, or
% any pattern you like.  You can even have more than one option here,
% controlled by some flag.
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
% Write a loop that chooses an eye position each time through and samples
% the signal from that eye position.  Define position 0 to be when the eye
% is centered on the signal. If receptors fall outside of the signal for
% any eye position, set their response to zero.
%
positionHistory = zeros(params.nTimes, 1);
pos_0 = params.nSignal / 2 + params.maxEyeMovement - params.eyeSize / 2;
image = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
repeats = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);

% Loop through and take a sample of what the eyes for x number of trials
% Keep track of the position by adding it to the position history array
% Add some noise to the data in order to simulate the imperfections of the
% eye
for i = 1:params.nTimes
    pos = round(pos_0 + params.maxEyeMovement * (2 * rand - 1));
    positionHistory(i) = pos;
    noise = randn(params.eyeSize, 1) * 0.05;
    output = eye .* buffered_signal(pos:pos+params.eyeSize-1);
    output = output + noise;
    image(pos:(pos + params.eyeSize-1)) = image(pos:(pos + params.eyeSize-1)) + output;
    repeats(pos:(pos + params.eyeSize-1)) = repeats(pos:(pos + params.eyeSize-1)) + eye;
end

% get the average response of each position that the eye had
image = image ./ repeats;
result = image(params.maxEyeMovement:params.maxEyeMovement + params.nSignal-1);

%set up the x co-ordinates of the original and resulting signal
x = 1:params.nSignal;
xq = 1:params.nSignal;

%interpolate the data if the user indicated so
if params.interpolate > 0
    v = result(x);
    xq = 1:0.5:params.nSignal;
    result = interp1(x, v, xq);
end

%plot the data
plot(x, signal);
hold on;
plot(xq, result);
legend("original signal", "eye's interpretation");
% In choosing eye position, could just draw random positions for each
% "time" within range.  
%
% Then add noise to the receptor responses
%
% And make some plot of the responses, that gets update each time through
% the loop.
%
% Keep track of the sequence of eye positions, so we can later see whether
% we can recover it properly.

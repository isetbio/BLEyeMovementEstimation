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
%   02/22/18  ak       Finished second draft


% Parameters describing what we'll simulate
params.nSignal = 128;           % Max size of signal vector
params.signalType = 1;          % 0 = random, 1 = sine wave, 2 = constant
params.eyeSize = 82;            % Number of pixels in the eye
params.nReceptors = 38;         % Number of receptors, can't exceed number of pixels.
params.eyeDistribution = 0;     % 0 = random, 1 = uniform
params.maxEyeMovement = 10;     % Maximum number of pixels the eye can go left/right
params.noiseSd = 0.05;          % Amount of noise added to receptor responses (sd)
params.nTimes = 100;             % Number of "times" to generate data for.
params.interpolate = 0;         % Decide whether or not to interpolate the data
params.method = 0;              % 0 = simple method, 1 = smart method

% Set up some signal.  This is just a set of numbers on a vector of length
% params.nSignal.  You can generate random numbers, or draw a sine wave, or
% any pattern you like.  You can even have more than one option here,
% controlled by some flag.
%
% The signal gets inserted into a buffer that is larger and padded with
% zeros, so that we have room to move the eye.
signal = Generate_Signal(params.signalType, params.nSignal);
buffered_signal = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
buffered_signal(params.maxEyeMovement+1:params.maxEyeMovement + params.nSignal) = signal;

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

% Loop through and take a sample of what the eye sees for x number of trials
% Keep track of the position by adding it to the position history array
% Add some noise to the data in order to simulate the imperfections of the
% eye.
if params.method == 0
    postitionHistory = Method_0(pos_0,eye,buffered_signal,...
    positionHistory,receptorIndex,pos_0_image,signal,params);
else
    postitionHistory = Method_1(pos_0,eye,buffered_signal,...
    positionHistory,receptorIndex,signal,params);
end

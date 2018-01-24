% Skeleton

% Parameters describing what we'll simulate
params.nSignal = 128;           % Max size of signal vector
params.eyeSize = 82;            % Number of pixels in the eye
params.nReceptors = 39;         % Number of receptors, can't exceed number of pixels.
params.maxEyeMovement = 40;     % Maximum number of pixels the eye can go left/right
params.noiseSd = 0.05;          % Amount of noise added to receptor responses (sd)
params.nTimes = 100;            % Number of "times" to generate data for.

% Set up some signal.  Thisis just a set of numbers on a vector of length
% params.nSignal.  You can generate random numbers, or draw a sine wave, or
% any pattern you like.  You can even have more than one option here,
% controlled by some flag.

% Set up eye.  This inolves choosing positions forthe params.nReceptors
% actual receptors in the vector that specifies the full eye.  You can
% again choose them at random or make them as regularly spaced as possible
% given the parameters, or have multiple options.  But, it whould work for
% any choice of parameters as long as there are not more receptors than eye
% positions.

% Write a loop that chooses an eye position each time through and samples
% the signal from that eye position.  Define position 0 to be when the eye
% is centered on the signal. If receptors fall outside of the signal for
% any eye position, set their response to zero.
%
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

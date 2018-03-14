function [samples,positionHistory] = Get_Samples(signal,eye,params)
% Generate samples for a series of eye positions
%
% Syntax:
%     [samples,positionHistory] = Get_Samples(bufferedSignal,eye,params)    
%
% Description:
%     A longer description of what happens goes here.
%
% Inputs:
%     bufferedSignal     - A vector containing the signal.
%     eye                - A vector with 1's where there are receptors.
%     params             - Standard parameters structure for the
%                          calculation.  See EyeMovements_1d
%
% Outputs:
%     samples            - A m by n matrix, where m is the number of time
%                          points and n is the number of receptors.  So
%                          each row is the responses at one time point.
%     positionHistory    - A vector containing the positional offset of the
%                          receptor array with respect to the signal, where 0
%                          means the receptor array is centered on the signal.
%                          Can be positive or negative.
%
% Optional key/value pairs:
%     None.
%
% See also: 
%

% History:
%   03/14/18  dhb, ak   Drafted interface and comments.

%% Pad signal with zeros on either side so we don't have edge problems
buffered_signal = zeros(params.nSignal + 2 * params.maxEyeMovement, 1);
buffered_signal(params.maxEyeMovement+1:params.maxEyeMovement + params.nSignal) = signal;

% Write a loop that chooses an eye position each time through and samples
% the signal from that eye position.  Define position 0 to be when the eye
% is centered on the signal. If receptors fall outside of the signal for
% any eye position, set their response to zero.
positionHistory = zeros(params.nTimes, 1);
pos_0 = round(params.nSignal/2) + params.maxEyeMovement - round(params.eyeSize/2);
pos_0_image = round(params.nSignal/2) - round(params.eyeSize/2);

%% Choose positions for each time

%% Get samples for each time.
%
% Involves shifting the from center by the position and then sampling
% the signals where the receptors
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
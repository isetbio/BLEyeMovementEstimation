function [samples,positionHistory] = Get_Samples(signal,eye,params)
% Generate samples for a series of eye positions
%
% Syntax:
%     [samples,positionHistory] = Get_Samples(signal,eye,params)    
%
% Description:
%     This function takes in the signal, eye, and paramters in order to
%     create sample data to be used by the different methods that can be
%     implemented. This will produce a 2D vector 'samples' which contains the
%     receptor responses of each trial. This will also produce a 1D vector
%     'positionHistory' which will keep track of the position of the center
%     of the eye in each trial. The center of the eye is defined as being 0
%     when it is looking at the center of the signal.
%
% Inputs:
%     signal     - A vector containing the signal.
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
%
% History:
%   03/14/18  dhb, ak   Drafted interface and comments.
%   04/11/18  ak        Added 2D functionality
%
%% Create samples and positionHistory vectors
samples = zeros(params.nReceptors, params.nTimes);
positionHistory = zeros(params.nTimes, 2);
secondDim = (params.nSignal + 2 * params.maxEyeMovement) ^ (params.dimension - 1);

%% Pad signal with zeros on either side so we don't have edge problems
bufferedSignal = zeros(params.nSignal + 2 * params.maxEyeMovement, secondDim);
bufferedSignal(params.maxEyeMovement+1:params.maxEyeMovement + params.nSignal,...
                (params.maxEyeMovement+1)^(params.dimension -1):(params.maxEyeMovement + params.nSignal)...
                ^(params.dimension -1)) = signal;
pos = zeros(params.dimension,1);

%% Get samples and add noise to the data
% Write a loop that chooses an eye position each time through and samples
% the signal from that eye position.  Define position 0 to be when the eye
% is centered on the signal. If receptors fall outside of the signal for
% any eye position, set their response to zero.
for i = 1:params.nTimes
    for j = 1:params.dimension
        pos(j) = int16(rand * 2 * params.maxEyeMovement - params.maxEyeMovement + 1);
    end
    positionHistory(i,:) = pos;
    noise = randn(params.nReceptors,1) * params.noiseSd;
    if params.dimension == 1
        response = Get_Response(eye, bufferedSignal, pos, params) + noise;
    else 
        response = Get_Response_2D(eye, bufferedSignal, pos, params) + noise;
    end
    samples(:,i) = response;
end
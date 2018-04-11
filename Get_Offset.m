function [offset] = Get_Offset(eye, sample, runningImage, i, params)
% Generate samples for a series of eye positions
%
% Syntax:
%     [offset] = Get_Offset(eye, sample, runningImage, i, params)   
%
% Description:
%     This function takes in eye, sample, and running image and finds the
%     offset which makes the sample most closely resemble the running
%     image. It this returns this offset
%
% Inputs:
%     eye               - A vector with 1's where there are receptors.
%     sample            - A single sample of what the eye has seen
%     runningImage      - A 1D vector containing the image the brain has
%                         processed thus far
%     i                 - the sample number
%     params`           - Standard parameters structure for the
%                         calculation.  See EyeMovements_1d
%
% Outputs:
%     offset            - A single integer representing the offset which is
%                         most likely for this sample
%
% Optional key/value pairs:
%     None.
%
% See also: 
%
%
% History:
%   03/30/18  ak    First Draft
%
%% Calculate the MSE for every possible eye position and choose the most likely
if(i ~= 1)
    imageLocation = 1:params.nSignal;
    possibleOffset = NaN(2 * params.maxEyeMovement + 1, 1);
    for i = -params.maxEyeMovement:params.maxEyeMovement
        % Calculate the image at the current offset
        effectiveReceptorIndex = find(eye == 1) + i + floor(params.nSignal/2) -...
                                 floor(params.eyeSize/2);
        effectiveSamples = sample;
        currentTrial = Interpolate(effectiveReceptorIndex, effectiveSamples,...
                       imageLocation);
        A = ~isnan(currentTrial);
        B = ~isnan(runningImage);
        C = A & B;
        % Find the MSE at this offset and store it
        if(max(C) < 1)
            error = 0;
        else
            error = immse(currentTrial(C), runningImage(C));
        end
        possibleOffset(i + params.maxEyeMovement + 1) = error;
    end
    % Return the offset with the least error
    offset = find(possibleOffset == min(possibleOffset)) - params.maxEyeMovement - 1;
    % Prevents cases where there are multiple offsets with 0 error. This
    % occurs when the eye is significantly smaller than the signal.
    offset = offset(1);
else
    % Base case for the first sample
    offset = 0;
end
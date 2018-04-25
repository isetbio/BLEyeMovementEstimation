function [recoveredSignal, interpolatedSignal, offsetHistory] = Method_3(eye,samples, pos_0, params)
% Reconstruct signal with perfect knowledge of eye position history
%
% Syntax:
%   [recoveredSignal, interpolatedSignal] = Method_3(eye,samples,params)
%
% Description:
%   This runs the smarter method of analyzing the eye's perception by
%   implementing a learning heuristic. The method will create a
%   running simulation of the image and adjust it with each new trial. This
%   method does not get access to the position history
%
% Inputs:
%     eye                - A vector with 1's where there are receptors
%     samples            - A m by n matrix, where m is the number of time
%                          points and n is the number of receptors.  So
%                          each row is the responses at one time point.
%     pos_0              - The initial position of the eye.
%     params             - Standard parameters structure for the calculation.
%                          See EyeMovements_1d for details 
% Outputs:
%     recoveredSignal   - A 1D vector representing the signal that was
%                          created based on the brains interpretation of
%                          the sample data given the current method. In
%                          this case, it is the same as the interpolated
%                          signal for convenience
%     interpolatedSignal -  A 1D vector that is the recovered signal after
%                           it has been interpolated

% Optional key/value pairs:
%    None.
%
% See also:
%

% History
% 3/28/18     ak    First Draft
% 04/02/18    ak    Completed
% 04/22/19    ak    Fixed off by one error
  
%% Create original image which will be modified
runningImage = NaN(1,params.nSignal);
imageLocation = 1:params.nSignal;
offsetHistory = zeros(params.nTimes, 1);

%% Cycle through the trials and make a more accurate image
for i = 1:params.nTimes
    % Find the most likely offset
    if i == 1
        offset = pos_0-1;
    else 
        offset = Get_Offset(eye, samples(:,i), runningImage, i, params);
    end
    if i==1
        offset = offset + 1;
    end
    offsetHistory(i) = offset;
    effectiveReceptorIndex = find(eye == 1) + offset + floor(params.nSignal/2) -...
                             floor(params.eyeSize/2);
    effectiveSamples = samples(:,i);
    currentTrial = Interpolate(effectiveReceptorIndex, effectiveSamples, imageLocation);
    % Only update the indices which have values
    validReceptors = ~isnan(runningImage);
    invalidReceptors = isnan(runningImage);
    oldValid = runningImage(validReceptors) * params.alpha;
    newValid = currentTrial(validReceptors) * (1 - params.alpha);
    newValid(isnan(newValid)) = oldValid(isnan(newValid)) / 4;
    % Update the running image
    runningImage(validReceptors) = oldValid + newValid;
    runningImage(invalidReceptors) = currentTrial(invalidReceptors);
end
%% Return the now accurate image
%interpolatedSignal = zeros(params.nSignal, 1);
%interpolatedSignal(1:end-1) = runningImage(2:end);
interpolatedSignal = runningImage;
recoveredSignal = NaN(1,params.nSignal);
    
end


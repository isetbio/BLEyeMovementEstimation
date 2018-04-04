function [interpolatedSignal] = Interpolate(effectiveReceptorLocations,...
                                effectiveSamples, imageLocations)
% Generate samples for a series of eye positions
%
% Syntax:
%     [interpolatedSignal] = Interpolate(effectiveReceptorLocations,...
%                            effectiveSamples, imageLocations)    
%
% Description:
%     This function takes in the effective receptor locations, effective
%     samples, and image locations in order to construct an interpolated
%     signal based on the limited data available. It always returns an
%     array of the signal length and values that on either side of the
%     signal are left as NaN.
%
% Inputs:
%     effectiveReceptorLocations  - A 1D array containing the receptor
%                                   locations with respect to the original
%                                   signal
%     effectiveSamples            - A 1D array containing the receptor
%                                   samples
%     imageLocations              - A 1D array containing the indices of
%                                   the original signal
%
% Outputs:
%     interpolatedSignal - A 1D vector containing an interpolated signal
%                          based on the receptor locations and sample values
%                          provided
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
%% Interpolate the signal and return
interpolatedSignal = interp1(effectiveReceptorLocations,...
        effectiveSamples, imageLocations,'linear');
end


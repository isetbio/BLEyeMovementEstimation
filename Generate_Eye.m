function [eye] = Generate_Eye(params)
% Generates a model of the eye
%
% Syntax: 
%    [eye] = Generate_Eye(params)
%
% Description: 
%     This function generates a model of the eye. The function can create
%     an eye of the given size and with a given number of params.nReceptors, as
%     long as the number of params.nReceptors does not exceed the  size of the eye.
%     The params.nReceptors can be arranged uniformly in the eye or at randomly. 
%
% Inputs:
%     params        - Standard parameters structure for the calculation.
%                       See EyeMovements_1d for details 
%
% Outputs:
%     eye           - A 1D vector with size equal to the size of the eye.
%                       1s represent the presence of a receptor and 0s
%                       represent a lack of a receptor
%
% Optional key/value pairs:
%     None.
%
% See also: 
%
% History:
%   02/14/18  ak   First Draft.
%   03/22/18  ak   Updated style to make uniform with rest of code
%   04/10/18  ak   Added 2D functionality

%% Create the model of the eye
secondDim = params.eyeSize^(params.dimension-1);
eye = zeros(params.eyeSize, secondDim);
eye1D = eye(:);

%% Place the params.nReceptors in the eye according to the params.eyeDistribution specified
if(params.eyeDistribution == 0)
    indices = randperm(params.eyeSize^params.dimension);
    indices = indices(1:params.nReceptors);
    eye1D(indices) = 1;
    eye = reshape(eye1D, params.eyeSize, secondDim);
elseif(params.eyeDistribution == 1)
    factor = params.eyeSize / params.nReceptors;
    rec = 1:params.nReceptors;
    rec = rec * factor;
    rec = round(rec);
    eye1D(rec) = 1;
    eye = reshape(eye1D, params.eyeSize, secondDim);
else
    error("params.eyeDistribution option not defined");
end


function [eye] = Generate_Eye(eyeSize, receptors, distribution)
% Generates a model of the eye
%
% Syntax: 
%    [eye] = Generate_Eye(eyeSize, receptors, distribution)
%
% Description: 
%     This function generates a model of the eye. The function can create
%     an eye of the given size and with a given number of receptors, as
%     long as the number of receptors does not exceed the  size of the eye.
%     The receptors can be arranged uniformly in the eye or at randomly. 
%
% Inputs:
%     eyeSize       - The size of the eye
%     receptors     - The number of receptors in the eye
%     distribution  - The distribution of the receptors in the eye. 0 is a
%                       random distribution and 1 is a uniform distribution. 
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

%% Create the model of the eye
eye = zeros(eyeSize, 1);

%% Place the receptors in the eye according to the distribution specified
if(distribution == 0)
    indices = randperm(eyeSize);
    indices = indices(1:receptors);
    eye(indices) = 1;
elseif(distribution == 1)
    factor = eyeSize / receptors;
    rec = 1:receptors;
    rec = rec * factor;
    rec = round(rec);
    eye(rec) = 1;
else
    error("Distribution option not defined");
end


function [] = Plot_Grey_Scale(samples)
% Plot the gray scale representation of the samples
%
% Syntax:
%   [] = Plot_Data(positionHistory, offsetHistory, params)
%
% Description:
%   This function takes in the samples taken by the eye and creates a grey
%   scale image of the samples. Each sample is represented by a row in the
%   image.
%
% Inputs:
%     samples            - A m by n matrix, where m is the number of time
%                          points and n is the number of receptors.  So
%                          each row is the responses at one time point.
% Outputs:
%    None.
%    
% Optional key/value pairs:
%    None.
%
% See also:
%
% History
%   04/06/18   ak   First draft
figure; clf; 
imshow(samples'/max(samples(:)), 'InitialMagnification', 1000);
end


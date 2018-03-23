function [response] = Get_Response(eye,buffered_signal,eye_pos, params)
% Generates the response of the eye as it views a signal from a specified
% location. 
%
% Syntax: 
%    [response] = Get_Response(eye,buffered_signal,eye_pos, params)
%
% Description: 
%     This function takes in a model of the eye, a buffered signal, the
%     eye's current position, and params. It generates a vector of the 
%     receptor's response to looking at the signal from the given position.
%
% Inputs:
%     eye            - A vector with 1's where there are receptors
%     buffered_signal - A vector which contains the signal padded by 0s
%     eye_pos        - The current position of the eye  
%     params         - Standard parameters structure for the calculation.
%                       See EyeMovements_1d for details 
%
% Outputs:
%     response       - A 1D vector with size equal to the number of
%                       receptors. Each value is the corresponding
%                       receptors response to the stimuli from its
%                       position. e.g. index 10 contains the output
%                       generated by receptor 10 in the eye as it looks at
%                       the signal
%
% Optional key/value pairs:
%     None.
%
% See also: 
%
% History:
%   03/22/18  ak   First draft


%% Calculate starting position relative to the vector index
adjusted_pos = params.maxEyeMovement + eye_pos;

%% Find responses and record them in response vector
pos_0 = floor(params.nSignal/2) - floor(params.eyeSize/2);
receptor_index = find(eye == 1);
receptor_index = receptor_index + pos_0;

%Create a visual_field vector which represents the range the eye can
%currrently see
visual_field = buffered_signal(adjusted_pos:adjusted_pos + params.nSignal-1);


response = visual_field(receptor_index);
end


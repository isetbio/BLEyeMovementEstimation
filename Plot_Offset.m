function [] = Plot_Offset(positionHistory, offsetHistory1, offsetHistory2, fig, params)
% Plot the original and estimated points for method 3
%
% Syntax:
%   [] = Plot_Data(positionHistory, offsetHistory, params)
%
% Description:
%   This function takes in the positions of the eye and method 3's
%   estimates of the eye position and graphs both in a scatterplot to
%   visualize any discrepancies.
%
% Inputs:
%     positionHistory    - A vector containing the positional offset of the
%                          receptor array with respect to the signal, where 0
%                          means the receptor array is centered on the signal.
%                          Can be positive or negative
%     offsetHistory      - A vector containing the programs estimated offset of the
%                          receptor array with respect to the signal, where 0
%                          means the receptor array is centered on the signal.
%                          Can be positive or negative
%     params             - Standard parameters structure for the calculation.
%                          See EyeMovements_1d for details 
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
%   04/22/18   ak   Modified function to allow trial by trial simulation
%   05/3/18    ak   Updated to allow multiple sets of offsets

%% Plot the Offsets and Position History
x = 1:params.nTimes;
figure(fig); clf; hold on
plot(x,positionHistory,'ro','MarkerFaceColor','r','MarkerSize',12);
plot(x,offsetHistory1,'bo','MarkerFaceColor','b','MarkerSize',8);
plot(x,offsetHistory2,'go','MarkerFaceColor','b','MarkerSize',6);
plot(x,positionHistory,'r');
plot(x,offsetHistory1,'b');
plot(x,offsetHistory2,'g');
xlabel('Time Step');
ylabel('Eye Offset Position')
legend({'Position History', 'Offset History 3', 'Offset History 3a'},'Location','NorthEastOutside');
axis([0,params.nTimes,-params.maxEyeMovement,params.maxEyeMovement])
end


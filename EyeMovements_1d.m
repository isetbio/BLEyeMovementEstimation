% EyeMovements_1d
%
% Description:
%    Simulates an "eye" that moves in one spatial dimensional dimension.
%    
%    At the top there are parameters that specify the size of the eye, the
%    number of receptors, how the receptors get distributed etc.  There are
%    also parameters that describe the type of signal that will be
%    simulated.
%

% History:
%   02/xx/18  ak       Wrote first draft.
%   02/14/18  ak, dhb  Added header comments to Anant's first draft.
%   02/22/18  ak       Finished second draft
%   03/23/18  ak       Finished modulating code
%   04/10/18  ak       Started adding 2D functionality

% Freeze rng so we get same samples on multiple runs
% rng('default');

%% Parameters describing what we'll simulate
params.nSignal = 128;           % Max size of signal vector
params.dimension = 1;           % 1 = 1D, 2 = 2D - 2D signal is a square
params.signalType= 1;           % 0 = random, 1 = sine wave, 2 = constant
params.eyeSize = 82;            % Number of pixels in the eye
params.nReceptors = 40;         % Number of receptors, can't exceed number of pixels.
params.eyeDistribution = 1;     % 0 = random, 1 = uniform
params.maxEyeMovement = 20;     % Maximum number of pixels the eye can go left/right
params.noiseSd = 0.05;          % Amount of noise added to receptor responses (sd)
params.nTimes = 100;            % Number of "times" to generate data for.
params.interpolate = 1;         % Decide whether or not to interpolate the data
params.method = 3;              % 0 = simple method,
                                % 1 = smart method,
                                % 2 = learning method with history, 
                                % 3 = learning method without history
params.alpha = 0.8;             % ratio with which trials effect learning

%% Set up some signal.
%
% This is just a set of numbers on a vector of length
% params.nSignal.  You can generate random numbers, or draw a sine wave, or
% any pattern you like.  You can even have more than one option here,
% controlled by some flag.
signal = Generate_Signal(params);

%% Set up eye.
%
% This inolves choosing positions for the params.nReceptors
% actual receptors in the vector that specifies the full eye.  You can
% again choose them at random or make them as regularly spaced as possible
% given the parameters, or have multiple options.  But, it would work for
% any choice of parameters as long as there are not more receptors than eye
% positions.
eye = Generate_Eye(params);

%% Get the receptor samples for each time.
[samples,positionHistory] = Get_Samples(signal,eye,params);

% Loop through and take a sample of what the eye sees for x number of trials
% Keep track of the position by adding it to the position history array
% Add some noise to the data in order to simulate the imperfections of the
% eye.
%{
if params.method == 0
    [recoveredSignal, interpolatedSignal] = Method_0(samples, eye, params);
elseif params.method == 1
    [recoveredSignal, interpolatedSignal] = Method_1(eye, samples, positionHistory, params);
elseif params.method == 2
    [recoveredSignal, interpolatedSignal] = Method_2(eye, samples, positionHistory, params);
elseif params.method == 3
    [recoveredSignal, interpolatedSignal, offsetHistory] = Method_3(eye, samples,...
                                                           positionHistory(1), params);    
end
%}

%% Plot the data
if params.dimension == 1
    Plot_Grey_Scale(samples);
end
% Method 0
[recoveredSignal, interpolatedSignal] = Method_0(samples, eye, params);
Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 0', params);
% Method 1
[recoveredSignal, interpolatedSignal] = Method_1(eye, samples, positionHistory, params);
Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 1', params);
% Method 2
[recoveredSignal, interpolatedSignal] = Method_2(eye, samples, positionHistory, params);
Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 2', params);
% Method 3
[recoveredSignal, interpolatedSignal, offsetHistory] = Method_3(eye, samples,...
                                                       positionHistory(1), params);                                                   
Plot_Offset(positionHistory, offsetHistory, params);
Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 3', params);
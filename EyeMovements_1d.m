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
%   04/22/18  ak       Added visualize flag to allow trial by trial
%                      simulation of data

%% Initial Settings
% Freeze rng so we get same samples on multiple runs
rng('default');

%% Allow pausing
pause on;

%% Clear
clear; close all;

%% Parameters describing what we'll simulate
params.nSignal = 128;           % Max size of signal vector
params.dimension = 1;           % 1 = 1D, 2 = 2D - 2D signal is a square
params.signalType= 3;           % 0 = random, 1 = sine wave, 2 = constant, 3 = filtered noise
params.spatialFrequencyX = 4;   % Spatial frequency of sinusoid
params.spatialFrequencyY = 7;   % Spatial frequency of sinusoid
params.filterWidth = 2;        % For filtered noise, this is the filter width
params.phaseX = 0;              % Spatial phase in X
params.phaseY = 0;              % Spatial phase in Y
params.eyeSize = 82;            % Number of pixels in the eye
params.nReceptors = 20;         % Number of receptors, can't exceed number of pixels.
params.eyeDistribution = 1;     % 0 = random, 1 = uniform
params.maxEyeMovement = 20;     % Maximum number of pixels the eye can go left/right
params.noiseSd = 0.05;          % Amount of noise added to receptor responses (sd)
params.nTimes = 100;            % Number of "times" to generate data for.
params.interpolate = 1;         % Decide whether or not to interpolate the data
params.method = 3;              % 0 = simple method,
                                % 1 = smart method,
                                % 2 = learning method with history, 
                                % 3 = learning method without history
params.alpha = 0.5;             % Ratio with which trials effect learning
                                % This applies to methods 2 and 3.  A value
                                % of 0 uses only the current sample, and as
                                % alpha increases the past begins to
                                % matter.
params.visualize = 0;           % 0 = run all trials and display final graphs
                                % 1 = display graphs after each trial and
                                % update results

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
fig0 = figure;
fig1 = figure;
fig2 = figure;
fig3 = figure;
fig3a = figure;
figOffset = figure;
if params.visualize == 0
    % Method 0
    [recoveredSignal, interpolatedSignal] = Method_0(samples, eye, params);
    Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 0', fig0, params);
    % Method 1
    [recoveredSignal, interpolatedSignal] = Method_1(eye, samples, positionHistory, params);
    Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 1', fig1, params);
    % Method 2
    [recoveredSignal, interpolatedSignal] = Method_2(eye, samples, positionHistory, params);
    Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 2',fig2, params);
    % Method 3
    [recoveredSignal, interpolatedSignal, offsetHistory1] = Method_3(eye, samples,...
                                                          positionHistory(1), params);
    Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 3',fig3, params);
    % Method 3a
    [recoveredSignal, interpolatedSignal, offsetHistory2] = Method_3a(eye, samples,...
                                                          positionHistory(1), params);
    Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 3a',fig3a, params);
    Plot_Offset(positionHistory, offsetHistory1, offsetHistory2, figOffset, params);
else
    for i = 1:params.nTimes
        new_params = params;
        new_params.nTimes = i;
         % Method 0
        [recoveredSignal, interpolatedSignal] = Method_0(samples(:,1:i), eye, new_params);
        Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 0', fig0, new_params);
        % Method 1
        [recoveredSignal, interpolatedSignal] = Method_1(eye, samples(:,1:i), positionHistory(1:i), new_params);
        Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 1', fig1, new_params);
        % Method 2
        [recoveredSignal, interpolatedSignal] = Method_2(eye, samples(:,1:i), positionHistory(1:i), new_params);
        Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 2', fig2, new_params);
        % Method 3
        [recoveredSignal, interpolatedSignal, offsetHistory1] = Method_3(eye, samples(:,1:i),...
                                                               positionHistory(1), new_params);
        Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 3', fig3, new_params);
        % Method 3a
        [recoveredSignal, interpolatedSignal, offsetHistory2] = Method_3a(eye, samples(:,1:i),...
                                                               positionHistory(1), new_params);
        Plot_Offset(positionHistory(1:i), offsetHistory1, offsetHistory2, figOffset, new_params);
        Plot_Data(signal, recoveredSignal, interpolatedSignal, 'Method 3a', fig3a, new_params);
        pause;
    end
end

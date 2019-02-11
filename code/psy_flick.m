% Clear the workspace and the screen

sca;
close all;
clearvars;

f = 30;
sw = 0;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
grey = white / 2;

% Open an on screen window using PsychImaging and color it grey.
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% Retreive the maximum priority number and set max priority
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Here we use to a waitframes number greater then 1 to flip at a rate not
% equal to the monitors refreash rate. For this example, once per second,
% to the nearest frame
flipSecs = 1/f;
waitframes = round(flipSecs / ifi);

% Flip outside of the loop to get a time stamp
vbl = Screen('Flip', window);
tic
% Run until a key is pressed
while ~KbCheck
    
    % Color the screen a random color
    if sw == 0
        Screen('FillRect', window, [0 0 255]);
        sw = 1;
    elseif sw == 1
        Screen('FillRect', window, [0 255 0]);
        sw = 0;
    end
        
        
        
        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        
    end
    toc
    % Clear the screen.
    sca;
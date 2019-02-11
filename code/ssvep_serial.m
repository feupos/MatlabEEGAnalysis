function x = ssvep_serial(comPort,f,t)

% Clear the workspace and the screen
sca;


v = zeros(2,600*t);
pattern = zeros(2,600*t);

i = 1;
a = zeros(2,600*t);
temp = zeros(2,600*t);



% Here we call some default settings for setting up Psychtoolbox
%PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);

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
flipSecs = 1;
stimFreq = f;
waitframes = round(1/(stimFreq*2*ifi));
%waitframes = round(flipSecs / ifi);

% Flip outside of the loop to get a time stamp
vbl = Screen('Flip', window);
step = 1;


delete(instrfindall);
% Open serial connection with Arduino
s = serial(comPort);
set(s,'DataBits',8);
set(s,'StopBits',1);
set(s,'BaudRate',115200);
set(s,'Parity','none');
fclose(s);
fopen(s);

start = GetSecs();
old = start;
% while (GetSecs() - start <= t)
%
%     % Color the screen a random color
%     %Screen('FillRect', window, rand(1, 3));
%
%      if step == 1
%         step = 2;
%         Screen('FillRect', window, white);
%     elseif step == 2
%         step = 1;
%         Screen('FillRect', window, black);
%     end
%
%     % Flip to the screen
%     vbl = Screen('Flip', window, vbl + (waitframes ) * ifi);
%     vbl-old
%     old = vbl;
%
%
% end
step = 0;
j = 1;
while (i <=600*t)
    
    
       if (GetSecs() - vbl) >= (1/60)*2
        if step == 0
            if vbl - old >=1
                step = 1;
                old = vbl;
            end
        end          
            
        
        if step == 1
            step = 2;
            Screen('FillRect', window, white);
        elseif step == 2
            step = 1;
            Screen('FillRect', window, black);
            if vbl - old >=1
                step = 0;
                old = vbl;
            end
        end
        
        % Flip to the screen
        vbl = Screen('Flip', window);
        pattern(1,j) = step;
        pattern(2,j) = GetSecs()-start;
        j = j+1;
        %vbl = Screen('Flip', window);
        
        a(1,1) = fread(s,1,'uint8');
        a(1,2) = fread(s,1,'uint8');
        b = a(1,1) + bitshift(a(1,2),8);
        b = typecast(uint16(b),'int16');
        v(1,i) = b;
        v(2,i) = GetSecs()-start;
        i = i+1;

        
    end
end
v(2,:) = v(2,:) - v(2,1);
pattern(2,:) = pattern(2,:) - pattern(2,1);

x = struct('data',v,'pattern',pattern);

% Clear the screen.
sca;
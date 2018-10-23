function settings = AST3_initialize(data)

commandwindow;
PsychDefaultSetup(1);

% response domain
settings.eh = 'e'; % h = hand, e = eyes

% screen
settings.screen.Number = max(Screen('Screens'));
[settings.screen.outwindow, settings.screen.outwindowdims] = Screen('Openwindow',settings.screen.Number, 0); % make screen, black bg

% files
settings.files.outfolder = fullfile(fileparts(which('AST2.m')),'out');
clocktime = clock; hrs = num2str(clocktime(4)); mins = num2str(clocktime(5));
settings.files.outfile = ['Subject_' num2str(data.Nr) '_' date '_' hrs '.' mins 'h.mat'];

% eyetracker
settings.eyetracker = EyelinkInitDefaults(settings.screen.outwindow);
ListenChar(2); HideCursor;
if ~EyelinkInit(0, 1)
    Eyelink('Shutdown');
    sca;
    ListenChar(0);
    return;
end
Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
settings.files.edfFile=['AST_S' num2str(data.Nr) '.edf'];
Eyelink('Openfile', settings.files.edfFile);
EyelinkDoTrackerSetup(settings.eyetracker);
EyelinkDoDriftCorrection(settings.eyetracker);
settings.eyetracker.srate = 1000;
settings.eyetracker.minsac = 2;

% general
settings.general.trials = 100;
settings.general.blocks = 6;
settings.general.ratingbuffer = 4:10; % number of trials after an error during which a query is put
settings.general.antiratio = .8;
% keys
KbName('UnifyKeyNames'); % unify keyboard
settings.keys.right = KbName('RightArrow');
settings.keys.left = KbName('LeftArrow');
settings.keys.noerror = KbName('DownArrow');
settings.keys.error = KbName('UpArrow');

% screen properties (manually set depending on setup)
settings.screen.cm_h = 53.5; % horizontal
settings.screen.cm_d = 77; % distance from screen
settings.screen.distance = settings.screen.cm_d;
settings.screen.width = settings.screen.cm_h;

% duration
settings.duraton.fix = .75;
settings.duraton.iti = 1;
settings.duration.deadline = 1;
settings.duration.rating = 5;
settings.duration.punishment = 5;
settings.duration.nopunishment = 1;

% layout
settings.layout.square.color = [255 255 0];
settings.layout.square.size = 3; % in deg of visual angle
settings.layout.square.width = 5;
settings.layout.stim.size = 2; % in deg of visual angle
settings.layout.stim.color = [255 255 255];
settings.layout.stim.hemifieldpos = 10; % deg of visual angle +/- from center (original:3)
settings.layout.fixcolor = [255 255 255];
settings.layout.inccolor = [255 0 0];
settings.layout.corcolor = [0 255 0];
settings.layout.anticolor = [255 0 0];
settings.layout.procolor = [0 255 0];
settings.layout.introsize = 40;

% convert to pixels
settings.layout.square.size = ceil(2*tand(settings.layout.square.size/2)*settings.screen.distance * settings.screen.outwindowdims(3)/settings.screen.width);
settings.layout.stim.hemifieldpos = ceil(2*tand(settings.layout.stim.hemifieldpos/2)*settings.screen.distance * settings.screen.outwindowdims(3)/settings.screen.width);
settings.layout.stim.size = ceil(2*tand(settings.layout.stim.size/2)*settings.screen.distance * settings.screen.outwindowdims(3)/settings.screen.width);

% Stimuli
horzpos =   [settings.screen.outwindowdims(3)/2-settings.layout.stim.hemifieldpos settings.screen.outwindowdims(4)*1/2; ... % l
                    settings.screen.outwindowdims(3)/2+settings.layout.stim.hemifieldpos settings.screen.outwindowdims(4)*1/2]; ... % r
settings.stimuli.LP = horzpos(1,:); settings.stimuli.RP = horzpos(2,:);
settings.stimuli.Lfix = [...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, -SS/2+LP(1), -SS/2+LP(2), +SS/2+LP(1), -SS/2+LP(2) , ST); ' ...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, -SS/2+LP(1), +SS/2+LP(2), +SS/2+LP(1), +SS/2+LP(2) , ST); ' ...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, -SS/2+LP(1), -SS/2+LP(2), -SS/2+LP(1), +SS/2+LP(2) , ST); ' ...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, +SS/2+LP(1), -SS/2+LP(2), +SS/2+LP(1), +SS/2+LP(2) , ST); ' ...
    ];
settings.stimuli.Rfix = [...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, -SS/2+RP(1), -SS/2+RP(2), +SS/2+RP(1), -SS/2+RP(2) , ST); ' ...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, -SS/2+RP(1), +SS/2+RP(2), +SS/2+RP(1), +SS/2+RP(2) , ST); ' ...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, -SS/2+RP(1), -SS/2+RP(2), -SS/2+RP(1), +SS/2+RP(2) , ST); ' ...
    'Screen(' char(39) 'DrawLine' char(39) ', OW ,SC, +SS/2+RP(1), -SS/2+RP(2), +SS/2+RP(1), +SS/2+RP(2) , ST); ' ...
    ];
settings.stimuli.Rstim = ['Screen(' char(39) 'DrawDots' char(39) ', OW, [' num2str(settings.stimuli.RP) '], ' num2str(settings.layout.stim.size) ', [' num2str(settings.layout.stim.color) '],[0 0], 1); '];
settings.stimuli.Lstim = ['Screen(' char(39) 'DrawDots' char(39) ', OW, [' num2str(settings.stimuli.LP) '], ' num2str(settings.layout.stim.size) ', [' num2str(settings.layout.stim.color) '],[0 0], 1); '];

% prepare fonts
Screen('TextSize',settings.screen.outwindow,settings.layout.introsize);
Screen('TextFont',settings.screen.outwindow,'Arial'); % arial
Screen('TextStyle', settings.screen.outwindow, 0); % make normal

% Intro
AST3_countin(settings);
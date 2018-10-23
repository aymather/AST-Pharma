function [trialseq,eyedata] = AST3_backend(trialseq,settings,data)

% initialize
id = AST3_columns;

% short
OW = settings.screen.outwindow;
OWD = settings.screen.outwindowdims;
FC = settings.layout.fixcolor;
SC = settings.layout.square.color;
SS = settings.layout.square.size;
ST = settings.layout.square.width;
LP = settings.stimuli.LP;
RP = settings.stimuli.RP;

if strcmpi(settings.eh,'e')
    eyedata = zeros(settings.general.blocks*settings.general.trials,settings.duration.deadline*settings.eyetracker.srate+1);
    Eyelink('StartRecording');
    WaitSecs(.1);
    Eyelink('message', 'Block_1');
end

% TRIALS
for it = 1:size(trialseq,1)

    % fixation
    eval(settings.stimuli.Lfix); eval(settings.stimuli.Rfix);
    if trialseq(it,id.anti) == 1; FC = settings.layout.anticolor; else FC = settings.layout.procolor; end
    DrawFormattedText(OW, '+', 'center', 'center', FC); % set text 
    [~,fixonset] = Screen('Flip', OW); % update screen
    Eyelink('message', ['FixCross_' num2str(it)]);
    WaitSecs(settings.duraton.fix);

    % stimulus
    eval(settings.stimuli.Lfix); eval(settings.stimuli.Rfix); DrawFormattedText(OW, '+', 'center', 'center', FC); % set text 
    if trialseq(it,id.sdir) == 1; eval(settings.stimuli.Lstim); elseif trialseq(it,id.sdir) == 2; eval(settings.stimuli.Rstim); end
    [~,stimonset] = Screen('Flip', OW); % update screen
    Eyelink('message', ['Stimulus_' num2str(it)]);

    % response
    [trialseq(it,id.rdir),trialseq(it,id.RT),wavedata] = AST3_response(settings,stimonset);
    if strcmpi(settings.eh,'e')
        eyedata(it,:) = wavedata - min(wavedata);
    end
    
    % accuracy
    if isempty(trialseq(it,id.rdir));
        trialseq(it,id.acc) = 5;
    else
        if trialseq(it,id.anti) == 1
            if trialseq(it,id.rdir) == trialseq(it,id.sdir); trialseq(it,id.acc) = 2; else trialseq(it,id.acc) = 1; end
        elseif trialseq(it,id.anti) == 0
            if trialseq(it,id.rdir) == trialseq(it,id.sdir); trialseq(it,id.acc) = 1; else trialseq(it,id.acc) = 2; end
        end
        if trialseq(it,id.rdir) == 61; trialseq(it,id.acc) = 5; end % set acc to miss on anticipation
    end
    % if error, make sure next trial is same trial (avoid task-switching
    % confound during PES)
    if it < size(trialseq,1); if trialseq(it,id.acc) == 2; trialseq(it+1,id.anti) = trialseq(it,id.anti); end; end
    
    % rating
    trialseq = AST3_rating(trialseq,it,settings);
    
    % save
    save(fullfile(settings.files.outfolder,settings.files.outfile),'trialseq','settings');
    
    % iti
    eval(settings.stimuli.Lfix); eval(settings.stimuli.Rfix); DrawFormattedText(OW, '+', 'center', 'center', settings.layout.fixcolor); % set text 
    Screen('Flip', OW); % update screen
    WaitSecs(settings.duraton.iti);
    
    % blockfeedback
    if it == size(trialseq,1) || trialseq(it,id.block) ~= trialseq(it+1,id.block);
        AST3_block(trialseq,it,settings);
    end
    
end
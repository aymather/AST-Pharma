function AST3_block(trialseq,it,settings)

% shorten
OW = settings.screen.outwindow;
OWD = settings.screen.outwindowdims;
FC = settings.layout.fixcolor;
Screen('TextSize',OW,settings.layout.introsize);

id = AST3_columns;

Eyelink('StopRecording');

% Get stats
blocktrials = trialseq(trialseq(:,id.block) == trialseq(it,id.block),:);
RT = round(mean(blocktrials(blocktrials(:,id.acc)==1,id.RT)));
errortrials = blocktrials(blocktrials(:,id.acc) == 2,:);
errorrate = round(100*size(errortrials,1)/size(blocktrials,1));
if isnan(errorrate); errorrate = 0; end

% Prepare Display
currentblock = trialseq(it,id.block);
DrawFormattedText(OW, ['Block #' num2str(currentblock) '/' num2str(trialseq(end,id.block)) ' Summary'], 'center', OWD(4)/2-7/8*OWD(4)/2, FC);
DrawFormattedText(OW, ['Correct RT: ' num2str(RT)  ' ms'], 'center', OWD(4)/2-6/8*OWD(4)/2, FC);
DrawFormattedText(OW, ['Errors: ' num2str(size(errortrials,1)) ' (' num2str(errorrate) '%)' ], 'center', OWD(4)/2-5/8*OWD(4)/2, FC);
DrawFormattedText(OW, 'Press any key to continue...', 'center', OWD(4)-(settings.layout.introsize*2), FC); % set text

% Block data
blocks = length(unique(trialseq(:,id.block)));
for ib = 1:blocks
    blocktrials = trialseq(trialseq(:,id.block) == ib,:);
    blockRT(ib) = mean(blocktrials(blocktrials(:,id.acc)==1,id.RT));
end

% Make blockgraph for RT
DrawFormattedText(OW, 'Blockwise RT development:', 'center', OWD(4)/2-2/8*OWD(4)/2, FC);

% graph
horzdisplay = OWD(3)/(blocks+2); % divide horz screen into equally spaced positions (add one to not start at edges, add another one for legend)
bottomgraph = OWD(4)/2+6/8*OWD(4)/2; % vertical bottom of graph
topgraph = OWD(4)/2; % vertical top of graph
graphextend = bottomgraph - topgraph; % vertical extend of graph
maxvalueRT = 100*(ceil(max(blockRT)/100)); % maximum RT value (rounded to hundreds)
DrawFormattedText(OW, '0 ms', horzdisplay, bottomgraph , FC); % draw 0 ms scale
DrawFormattedText(OW, [num2str(maxvalueRT) ' ms'], horzdisplay, bottomgraph-graphextend , FC); % draw maxvalue ms scale
Screen('DrawLine',OW,FC,horzdisplay*2,bottomgraph,horzdisplay*(blocks+1),bottomgraph); % xaxis
Screen('DrawLine',OW,FC,horzdisplay*2,bottomgraph,horzdisplay*2,topgraph); %yaxis

% fill in values
for ib = 1:blocks
    DrawFormattedText(OW, num2str(ib), horzdisplay*(ib+1), bottomgraph+10 , FC); % draw number of block
    if ib <= currentblock % if block has values, draw point
        DrawFormattedText(OW, 'x', horzdisplay*(ib+1), bottomgraph-blockRT(ib)/maxvalueRT*graphextend , [255 0 0]);
    end
end

% Display
Screen('Flip', OW); % update screen
KbWait(-1);

% Count back in
if it < size(trialseq,1)
    EyelinkDoTrackerSetup(settings.eyetracker);
    AST3_countin(settings);
    Eyelink('StartRecording');
    Eyelink('message', ['Block_' num2str(trialseq(it,2))]);
end
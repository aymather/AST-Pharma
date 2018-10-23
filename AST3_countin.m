function AST3_countin(settings);

% shorten
FC = settings.layout.fixcolor;
OW = settings.screen.outwindow;

% display
DrawFormattedText(OW, 'Press any key to start!', 'center', 'center', FC); % set text
Screen('Flip', OW); KbWait(-3);
DrawFormattedText(OW, 'Ready in 3...', 'center', 'center', FC); % set text
Screen('Flip', OW); WaitSecs(1);
DrawFormattedText(OW, 'Ready in 2...', 'center', 'center', FC); % set text
Screen('Flip', OW); WaitSecs(1);
DrawFormattedText(OW, 'Ready in 1...', 'center', 'center', FC); % set text
Screen('Flip', OW); WaitSecs(1);
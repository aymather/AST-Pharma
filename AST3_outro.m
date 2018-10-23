function AST3_outro(settings);

% shorten
FC = settings.layout.fixcolor;
OW = settings.screen.outwindow;

% display
DrawFormattedText(OW, 'Press any key to finish!', 'center', 'center', FC); % set text
Screen('Flip', OW); KbWait(-3);
Priority(0);
ListenChar(0);
Screen('CloseAll');
ShowCursor;

% eyetracker
if strcmpi(settings.eh,'e')
    Eyelink('StopRecording');
    Eyelink('CloseFile');
    Eyelink('ReceiveFile',settings.files.edfFile, fullfile(settings.files.outfolder,settings.files.edfFile));
    Eyelink('Shutdown');
end
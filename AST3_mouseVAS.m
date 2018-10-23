function [percentage,position] = AST3_mouseVAS(settings)

% shorten
OW = settings.screen.outwindow;
OWD = settings.screen.outwindowdims;

% settings
linelength = 40; vaslength = 500;
linewidth = 5; vaswidth = 1;
linecolor = 255;

% initial position
vaspos = OWD(4)/2; % y
ix = OWD(3)/2;
iy = OWD(4)/2;
SetMouse(ix,iy);

% cursor
Screen('DrawLine',OW,linecolor,ix-linelength/2,iy,ix+linelength/2,iy,linewidth);
Screen('DrawLine',OW,linecolor,ix,iy-linelength/2,ix,iy+linelength/2,linewidth);
% vas lines
Screen('DrawLine',OW,linecolor,OWD(3)/2-vaslength,vaspos,OWD(3)/2+vaslength,vaspos,vaswidth);
Screen('DrawLine',OW,linecolor,OWD(3)/2-vaslength,vaspos-linelength,OWD(3)/2-vaslength,vaspos+linelength,vaswidth);
Screen('DrawLine',OW,linecolor,OWD(3)/2+vaslength,vaspos-linelength,OWD(3)/2+vaslength,vaspos+linelength,vaswidth);

% Wait for a click and hide the cursor
DrawFormattedText(OW, 'How sure are you?', 'center', OWD(4)/2-150, linecolor); % set text 
DrawFormattedText(OW, 'Not sure', OWD(3)/2-vaslength, vaspos+2*linelength, linecolor); % set text 
        DrawFormattedText(OW, 'Very sure', OWD(3)/2+vaslength, vaspos+2*linelength, linecolor); % set text 
Screen('Flip', OW);
% loop, track mouse
while 1
    [x,y,buttons] = GetMouse(OW);	
    if buttons(1) && x > OWD(3)/2-vaslength && x < OWD(3)/2+vaslength && y > OWD(4)/2-linelength && y < OWD(4)/2+linelength
        break;
    end
    if (x ~= ix || y ~= iy)
        
        DrawFormattedText(OW, 'How sure are you?', 'center', OWD(4)/2-150, linecolor); % set text 
        DrawFormattedText(OW, 'Not sure', OWD(3)/2-vaslength, vaspos+2*linelength, linecolor); % set text 
        DrawFormattedText(OW, 'Very sure', OWD(3)/2+vaslength, vaspos+2*linelength, linecolor); % set text 
        % update cursor
        Screen('DrawLine',OW,linecolor,x-linelength/2,y,x+linelength/2,y,linewidth);
        Screen('DrawLine',OW,linecolor,x,y-linelength/2,x,y+linelength/2,linewidth);
        % vaslines
        Screen('DrawLine',OW,linecolor,OWD(3)/2-vaslength,vaspos,OWD(3)/2+vaslength,vaspos,vaswidth);
        Screen('DrawLine',OW,linecolor,OWD(3)/2-vaslength,vaspos-linelength,OWD(3)/2-vaslength,vaspos+linelength,vaswidth);
        Screen('DrawLine',OW,linecolor,OWD(3)/2+vaslength,vaspos-linelength,OWD(3)/2+vaslength,vaspos+linelength,vaswidth);
        % flip
        Screen('Flip', OW);
    end
end

% draw final line
Screen('DrawLine',OW,linecolor,OWD(3)/2-vaslength,vaspos-linelength,OWD(3)/2-vaslength,vaspos+linelength,vaswidth);
Screen('DrawLine',OW,linecolor,OWD(3)/2+vaslength,vaspos-linelength,OWD(3)/2+vaslength,vaspos+linelength,vaswidth);
% vaslines
Screen('DrawLine',OW,linecolor,OWD(3)/2-vaslength,vaspos,OWD(3)/2+vaslength,vaspos,vaswidth);
Screen('DrawLine',OW,linecolor,x,vaspos-linelength,x,vaspos+linelength,vaswidth);
% correction/confirmation dialoge
Screen('Flip', OW);
WaitSecs(.1);
% output
position = [x y];
percentage = 100*(x - (OWD(3)/2-vaslength))/(vaslength*2);
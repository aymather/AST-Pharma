function trialseq = AST3_rating(trialseq,it,settings);

id = AST3_columns;

linelength = 40; 
linewidth = 5; 
linecolor = 255;

% start at trial 2 within each block
if it > 1
    
    % figure out if query is necessary
    qshift = 0;
    query = 0;
    % check if there has been no query in the last trial
    if trialseq(it-1,id.query) == 0
        if trialseq(it-1,id.acc) == 2 && trialseq(it,id.acc) == 1;
            query = 1;
            qshift = 1;
        end % flag 1 when due to error
        if query == 0
            if trialseq(it,id.query) == 1 % if has been marked for query
                % if both last two trials are correct and in the same block
                if trialseq(it-1,id.acc) == 1 && trialseq(it,id.acc) == 1 && trialseq(it-1,id.block) == trialseq(it,id.block)
                    query = 1;
                    qshift = 0;
                else % if has been marked for query byt there is an error in the last two trials, or it's the first trial of a block, shift
                    trialseq(it,id.query) = 0;
                    query = 0;
                    qshift = 1;
                end % of last 2 correct and in same block condition
            end % of check whether had been marked for query by prior error query
        end % if this trial isn't a query yet because of an error
    else % if there had already been a query in the last trial, adn there was supposed to be one now, shift
        if trialseq(it,id.query) == 1
            trialseq(it,id.query) = 0;
            query = 0;
            qshift = 1;
        end
    end % of check whether one of the last trial had a query already

    % if last trial is an error but current one is correct
    if query == 1

        % shorten
        FC = settings.layout.fixcolor;
        OW = settings.screen.outwindow;
        OWD = settings.screen.outwindowdims;
        IS = settings.layout.introsize;
        IC = settings.layout.inccolor;
        CC = settings.layout.corcolor;
        
        % display
        DrawFormattedText(OW, 'Error in last 2?','center', OWD(4)/2-2*IS, FC);
        DrawFormattedText(OW, 'Y', OWD(3)/2-2*IS, OWD(4)/2+1*IS, FC);
        DrawFormattedText(OW, 'N', OWD(3)/2+2*IS, OWD(4)/2+1*IS, FC);
        % cursor
        ix = OWD(3)/2;
        iy = OWD(4)/2;
        Screen('DrawLine',OW,linecolor,ix-linelength/2,iy,ix+linelength/2,iy,linewidth);
        Screen('DrawLine',OW,linecolor,ix,iy-linelength/2,ix,iy+linelength/2,linewidth);
        Screen('Flip', OW);
        btime = GetSecs;
        
        while 1
            [x,y,buttons] = GetMouse(OW);	
            % check if in Y area
            yx = OWD(3)/2-2*IS;
            yy = OWD(4)/2+1*IS;
            if x > yx - 50 && x < yx + 50 && y > yy - 50 && y < yy + 50
                in_y = 1; else in_y = 0;
            end
            % check if in N area
            nx = OWD(3)/2+2*IS;
            ny = OWD(4)/2+1*IS;
            if x > nx - 50 && x < nx + 50 && y > ny - 50 && y < ny + 50
                in_n = 1; else in_n = 0;
            end
            % interrupt if selected
            if buttons(1) && in_y; ea = 2; etime = GetSecs; break; end
            if buttons(1) && in_n; ea = 1; etime = GetSecs; break; end
            if (x ~= ix || y ~= iy)
                % update cursor
                Screen('DrawLine',OW,linecolor,x-linelength/2,y,x+linelength/2,y,linewidth);
                Screen('DrawLine',OW,linecolor,x,y-linelength/2,x,y+linelength/2,linewidth);
                DrawFormattedText(OW, 'Error in last 2?','center', OWD(4)/2-2*IS, FC);
                DrawFormattedText(OW, 'Y', OWD(3)/2-2*IS, OWD(4)/2+1*IS, FC);
                DrawFormattedText(OW, 'N', OWD(3)/2+2*IS, OWD(4)/2+1*IS, FC);
                % flip
                Screen('Flip', OW);
            end
        end
        % Wait for mouse button to not be pressed
        while 1
            [~,~,buttons] = GetMouse(OW);
            if ~buttons(1); break; end
        end
        WaitSecs(.01);
        % fill in
        trialseq(it,id.query) = 1;
        trialseq(it,id.qresp) = ea;
        trialseq(it,id.qrt) = etime-btime;
        
        % VAC!
        trialseq(it,id.perc) = AST3_mouseVAS(settings);
        
        % feedback
        if trialseq(it,id.qresp) ~= trialseq(it-1,id.acc)
            DrawFormattedText(OW, 'Incorrect', 'center', 'center', IC);
            Screen('Flip', OW);
            WaitSecs(settings.duration.punishment);
        else
            DrawFormattedText(OW, 'Correct', 'center','center', CC);
            Screen('Flip', OW);
            WaitSecs(settings.duration.nopunishment);
        end
        
    end
    
    % if this trial had been slated for query but was skipped because of error; or if this query was due to error; add query trial in the next X trials to balance out error queries
    if qshift == 1 
        if size(trialseq,1) - it > max(settings.general.ratingbuffer);
            selector = randperm(length(settings.general.ratingbuffer));
            trialseq(it+settings.general.ratingbuffer(selector(1)),id.query) = 1;
            % also ensure that said trial is a) the same type (anti/pro) as the error,
            % and b) preceded by an identical trialtype
            trialseq(it+settings.general.ratingbuffer(selector(1))-1,id.anti) = trialseq(it-1,id.anti);
            trialseq(it+settings.general.ratingbuffer(selector(1)),id.anti) = trialseq(it-1,id.anti);
        else trialseq(end,id.query) = 1;
        end
    end
    
end
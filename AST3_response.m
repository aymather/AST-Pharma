function [rdir,RT,wavedata] = AST3_response(settings,starttime); 

% empty assignments
rdir = 0; RT = 0;

if strcmpi(settings.eh,'h')

    % wait for resp
    DisableKeysForKbCheck('empty'); % enable all keys

    while (GetSecs - starttime) <= settings.duration.deadline

        % check
        [~, endtime, keycode] = KbCheck;

        % this if loop gets response, otherwise keeps checking
        if keycode(settings.keys.left) == 1
            rdir = 1; RT = round((endtime-starttime)*1000);
            break
        elseif keycode(settings.keys.right) == 1
            rdir = 2; RT = round((endtime-starttime)*1000);
            break
        end

    end
    eyedata = [];
elseif strcmpi(settings.eh,'e')
    
    data = eye_getdata(settings,settings.duration.deadline,starttime);
    wavedata = zeros(1,settings.duration.deadline*settings.eyetracker.srate+1);
    
    % wavedaa
    if ~isempty(data)

        % Store
        wavedata(1:size(data,2)) = data(1,:);
        missingsamples = length(wavedata) - size(data,2);
        if missingsamples > 0
            wavedata(size(data,2)+1:end) = data(1,end); % fill with last sample
        end
        if length(wavedata) > settings.duration.deadline*settings.eyetracker.srate+1
            wavedata = wavedata(1:settings.duration.deadline*settings.eyetracker.srate+1);
        end

        % derivative
        diffsac = abs([0 diff(data(1,:))]);
        signdiff = [0 diff(data(1,:))];

        % assign RT & direction
        exceed = find(diffsac>settings.eyetracker.threshold,1,'first');
        if isempty(exceed)
            RT = 0; rdir = 0;
        else
            RT = round(1000*data(2,exceed));
            % direction
            direction = signdiff(1,exceed);
            if direction < 0
                rdir = 1; % left
            else rdir = 2;
            end
        end

        % blink
        hasblink = 0;
        if sum(data(1,:)==0) > 0 % if blink
            hasblink = 1;
            blinkpoint = find(data(1,:)==0,1,'first')-1;
            if exceed > blinkpoint % blink before saccade
                rdir = 60;
                RT = 0;
            end
        end
        
        % anticipation
        if RT < 80
            rdir = 61;
        end
        
        eyedata = wavedata;

    else % if eyetracker failure
        rdir = 999; RT = 0; eyedata = wavedata;
    end
end

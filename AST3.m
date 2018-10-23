addpath(genpath(fileparts(which('AST3.m'))));
data = AST3_intro;
settings = AST3_initialize(data);
settings = eye_calibrate(settings,1);
%settings.eyetracker.threshold = 10;
trialseq = AST3_sequence(settings);
AST3_countin(settings);
[trialseq,eyedata] = AST3_backend(trialseq,settings,data);
save(fullfile(settings.files.outfolder,settings.files.outfile),'trialseq','settings','eyedata','data');
AST3_outro(settings);
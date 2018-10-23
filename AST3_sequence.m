function trialseq = AST3_sequence(settings);

% columns
id = AST3_columns;
ncolumns = 9;

% preassign
ntrials = settings.general.trials;
nblocks = settings.general.blocks;
trialseq = [];

for ib = 1:nblocks
    
    % directions
    lefttrials = zeros(ntrials/2,ncolumns); lefttrials(:,id.sdir) = 1;
    righttrials = zeros(ntrials/2,ncolumns); righttrials(:,id.sdir) = 2;
    
    % pro / anti
    antitrials = settings.general.antiratio*size(lefttrials,1);
    lefttrials(1:antitrials,id.anti) = 1;
    righttrials(1:antitrials,id.anti) = 1;
    
    % merge and shuffle
    blocktrials = [lefttrials; righttrials];
    blocktrials = blocktrials(randperm(size(blocktrials,1)),:);
    
    % blocknum
    blocktrials(:,id.block) = ib;
    
    % append
    trialseq = [trialseq; blocktrials];
    
end

% tnums
trialseq(:,id.tnum) = 1:size(trialseq,1);
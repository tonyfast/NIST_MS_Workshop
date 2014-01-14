loc = '../Data/Titanium/';
ff = dir(fullfile(loc,'*.png'));


cutoff = Inf;
ct = 0;
for ii = 1 : numel( ff )
    
    data = cast( round( imread( fullfile( loc, ff(ii).name ) )./255),'double');
    
    if ii == 1 % Initialize the variables as needed
        sz = size( data ); hsz = floor(sz./2);
        xx{1} = 1 : hsz(1); xx{2} =  1 : hsz(2); 
        init = SpatialStatsFFT( data( xx{1},xx{2}), [], 'cutoff',cutoff,'display',false,'periodic',true);
        features = zeros( numel( ff) * 4, min( (2*cutoff+1)^2,numel(init))*2);
    end
    
    % Make four images from each micrograph
    for aa = [ 0 1]*hsz(1)
        for bb = [ 0 1]*hsz(2)
            ct = ct + 1;
            tic;
            features( ct, : ) = [ SpatialStatsFFT( data( aa+xx{1},bb+xx{2}), [], 'cutoff',cutoff,'vector',true,'display',false,'periodic',true); ...
                SpatialStatsFFT( data( aa+xx{1},bb+xx{2}), 1-data( aa+xx{1},bb+xx{2}), 'cutoff',cutoff,'vector',true,'display',false,'periodic',true) ];
            t = toc;
        end
    end
    disp( sprintf( 'The statistics have been calculated for %i of %i samples in %f seconds.',ct, size(features,1), t));
end

%% Class of the Heat Treatment

membersstr = cellfun(@(x)strtok(x,'_'),{ff.name},'UniformOutput',false);
[~,~,membersid] = unique(membersstr)
membersid = repmat(membersid,1,4)';
membersid = membersid(:);



%%


ignore = [];%46
idpca = setdiff( 1:size(features,1),ignore );
[ U S V ] = pca( bsxfun(@minus, features(idpca,:), mean(features(idpca,:),2)));

scatter3( U(:,1),U(:,2),U(:,3),100, membersid(idpca),'filled')

%% TOGGLE PERIODICITY
%% TOGGLE CUTOFF
%% TAKE TRAINING DATA
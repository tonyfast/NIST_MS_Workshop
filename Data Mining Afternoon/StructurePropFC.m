
id = [ 1 100
    101 200];
ct = 0;
load('~/Dropbox/Tony FC/RveRandomDiff1to200.mat')
[ test xx ]  = SpatialStatsFFT( rand(size(K{1})), [], 'cutoff',30, 'vector', true,'display',false);
nt = numel( test );
F = zeros( numel(K), 2*nt );
clear test
for oo = 1 : 2
    load(sprintf('~/Dropbox/Tony FC/%ito%i.mat',id(oo,:)));
    for ii = 1 : numel( K )
        ct = ct + 1;
        disp(sprintf('Compute %i of %i samples.',ii, numel(K)));
        F(ct,1:nt) = SpatialStatsFFT( K{ii}, [], 'cutoff',30, 'vector', true,'display',false );
        F(ct,[1:nt]+nt) = SpatialStatsFFT( K{ii}, 1-K{ii}, 'cutoff',30, 'vector', true,'display',false,'periodic',true );
    end
end

%%
F2 = bsxfun( @rdivide, bsxfun(@minus, F(:,all(abs(xx) <=cut,2)), mean(F,1)), std(F,[],1));

%%
cut = 3;
[ U S V ] = pca( F2(:,all(abs(xx) <=cut,2)), 10 );

P = FeaturetoPoly( U , 3 );

[ y, ~, r] = regress( R, P )
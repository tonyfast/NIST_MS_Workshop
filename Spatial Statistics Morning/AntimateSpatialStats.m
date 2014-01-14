%%  Animate the Pair Correlation Function
close all
sampleimage = round(double(imread('../examples/Data/Example.png')./255));

%%
sz = 100;
sampleimage2 = sampleimage( 1:sz, 1:sz );

vecs = [ 0 10];
vecsind = vecs + 1;
% vecsind( vecsind < 1 ) =  sz + vecsind( vecsind < 1 );
vecsi = sub2ind( [sz sz], vecsind(:,1), vecsind(:,2) );

[ F , xx ] = SpatialStatsFFT( sampleimage2,[],'display',false,'shift',true, 'cutoff',15 );

subplot(1,2,1)
hs = surface( xx.values{2},xx.values{1},F,'FaceAlpha',.8 );
loopavg = zeros(size(vecs,1),1);
loopavgcum = zeros(size(vecs,1),2);
hold on
h = plot3( vecs(:,1),vecs(:,2),loopavg,'kd','Markersize',15,'Markerfacecolor','m');
set( h, 'Ydatasource','[vecs(:,1); -1*vecs(:,1)]',...
    'Xdatasource','[vecs(:,2); -1*vecs(:,2)]',...
    'Zdatasource','repmat(loopavg,2,1)');
view(3); 
hold off
grid on;

masked = zeros( [sz sz size(vecs,1)] );
for ii = 1 : size(vecs,1)
    filter = zeros(sz);
    filter(1) = 1;
    filter( vecsi(ii) ) = 1;
    masked(:,:,ii) = filter2( filter( 1:50,1:50), sampleimage2 );
    denom(:,:,ii) = filter2( filter( 1:50,1:50), ones(sz) );
end

id = find( sampleimage2 );  [ y x ] = ind2sub( size( sampleimage2 ), id );
vf = max(F(:));
start = true;
figure(gcf)
subplot(1,2,2);
hp = pcolor( sampleimage2 ) ; shading flat; axis equal; axis tight;
for ii = 2000 : numel(y)
    maski = [ id(ii) ] + [ 0 : sz^2 : (size(vecsi)-1)*sz^2]';
    loopavgcum(:,1) = prod(loopavgcum,2) + masked( maski );
    loopavgcum(:,2) = loopavgcum(:,2) + denom( maski );
    b = ~all( loopavgcum==0, 2);
    loopavgcum(b,1) = loopavgcum(b,1)./loopavgcum(b,2);
    loopavg(:) = vf * loopavgcum(:,1);
    refreshdata
    drawnow
    if start hold on; start = false; h2 = plot( [ y(ii); y(ii)+ vecs(:,2)],...
            [ x(ii); x(ii)+ vecs(:,1)], 'o','Markersize',15,'Markerfacecolor','c'); hold off; 
    end
    
    set( h2, 'Xdatasource',' [ y(ii); y(ii)+ vecs(:,2)]',...
    'Ydatasource','[ x(ii); x(ii)+ vecs(:,1)]',...
    'Zdatasource','1000*ones(size(vecs,1)+1,1)');
end
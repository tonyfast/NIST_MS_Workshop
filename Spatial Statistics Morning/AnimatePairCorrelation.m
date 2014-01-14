%%  Animate the Pair Correlation Function
close all
sampleimage = round(double(imread('../examples/Data/Example.png')./255));

%%
feature = 1;

%% 
% Extract a subset of the image for discussion
sz = 100;
sampleimage2 = sampleimage(1:sz,1:sz);

%%
% Use the SpatialStatisticsFFT Matlab utility to compute the mean and
% standard deviation of the pair correlation function
[ M, S ] = PairCorrelationFFT( sampleimage2 == feature );

nd = min(41, numel(M));
distance = [ 1 : nd ]-1;
M = M(1:nd); S = S(1:nd);

cutoffdistance = 10;

subplot( 1,2,1)
errorbar( distance, M, S )

hold on

loopavg = 0;
loopstd = 0;
loopavgcum = [0 0];

h1 = errorbar( cutoffdistance, loopavg, loopstd,'ko','MarkerFaceColor',.7*[1 1 1],'Markersize',14);
legend(h1,'Moving Average')
set(h1,'Xdatasource','cutoffdistance')
set(h1,'Ydatasource','loopavg')
set(h1,'Udatasource','loopstd')
set(h1,'Ldatasource','loopstd')

hold off
grid on; xlim([min(distance), max(distance)]);

subplot(1,2,2)
spy( sampleimage2 == feature, 'k.'); hold on;
colorbar
xlabel('')
axis equal; axis tight;


[ y x ] = find( sampleimage2 == feature );
D = pdist([x y]);
B = sparse(squareform( D <= ( cutoffdistance +.5) & D >= ( cutoffdistance - .5) ));
start= true;

[ X Y ] = meshgrid( -cutoffdistance:cutoffdistance, -cutoffdistance:cutoffdistance);
Filter = round(sqrt(X.^2 + Y.^2)) == cutoffdistance ;


numer = filter2( Filter, sampleimage2 == feature );
denom = filter2( Filter, ones(sz) );

co = jet(100);
hc = colormap( co )
np = 101;
for ii = 1e3 : numel(x)%x(randperm(numel(x)))'
    
    c = [x(ii), x(ii) + cutoffdistance*cosd(linspace(0,360,np)); ...
        y(ii), y(ii) + cutoffdistance*sind(linspace(0,360,np))]';
    
    loopavgcum(1) = prod(loopavgcum) + numer(y(ii),x(ii));
    loopavgcum(2) = loopavgcum(2) +  denom(y(ii),x(ii));
    loopavgcum(1) = loopavgcum(1)./loopavgcum(2);
    loopavg = M(1)*loopavgcum(1);
    if start
        h = scatter(c(:,1),c(:,2),50,co(numer(x(ii),y(ii)),:),'filled');
        set( h,'Xdatasource','c(:,1)');
        set( h,'Ydatasource','c(:,2)');
        set( h,'Cdatasource','co(round(100*numer(x(ii),y(ii))./denom(x(ii),y(ii))),:)');
        start =false;
    end
    if mod(ii,5) == 0
    refreshdata
    drawnow
    end
end

%%
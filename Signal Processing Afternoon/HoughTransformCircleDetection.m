%% Hough transform for detecting the centroids of circles

%% Generate a 100x100 image with ten random circles with a radius of three pixels
ncircles = 10;
sz = 100;

radii = 3*ones(ncircles,1);
radii(end) = 10;
[ data, XY ] = randomcircles( sz, radii );
surface(data);
hold on;
h = plot3( XY(:,1), XY(:,2), ones(ncircles,1), 'kd','Markerfacecolor','c','Markersize',15);
legend( h, 'Circle Centers' )
hold off;
figure(gcf)

%% Create a Filter to find the edge of a circle
mr = max( radii ); % Maximum radius
[ fX fY ] = meshgrid( -mr:mr );
DIST = sqrt( fX.^2 + fY.^2 );

radOI = 10;
filter = DIST < (radOI + .5) & DIST > (radOI - .5);
filtered = filter2( filter, data );

dfsz = 5;
dilatefilter = ones( dfsz );
dilatefilter( ceil(numel( dilatefilter )/2) ) = 0;
Dfiltered = imdilate( filtered, dilatefilter );

centerid = find( (filtered-Dfiltered) > 1 );
centerxy = zeros( numel( centerid ), 2 );
[ centerxy(:,2), centerxy(:,1) ] = ind2sub( [sz sz], centerid );
clf
surface(data);
hold on;
h = plot3( XY(:,1), XY(:,2), ones(ncircles,1), 'kd','Markerfacecolor','w','Markersize',15);
h2 = plot3( centerxy(:,1), centerxy(:,2), ones(size(centerxy,1),1), 'mx','Markerfacecolor','c','Markersize',15);
legend( [h h2], 'Original Circle Centers','Found Centers' )
hold off;
figure(gcf)
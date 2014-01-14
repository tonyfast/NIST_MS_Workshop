%% Peak detection in the peaks dataset in matlab
%
%% Create the example dataset
sz = 21;
data = peaks( sz );
surface( data );

%% Design the filter to find the peak/,cutoff
fsz = 5; % Filter size
filter = ones( fsz );
filter( ceil(fsz^2/2) ) = 0;

%% Dilate the image to find the peak
D = imdilate( data, filter);
peaksid = find( data > D );
peaksxy = zeros( numel( peaksid), 2 );
[peaksxy(:,1), peaksxy(:,2)] = ind2sub( [sz sz], peaksid);
clf
surface( data ); shading flat; colorbar
hold on
plot3( peaksxy(:,2), peaksxy(:,1), data( peaksid ),'o' );
hold off
title(sprintf('%i peaks were found.',numel(peaksid)));
view(3);
figure(gcf)

%% Erode the image to find the valleys
E = imerode( data, filter);
valleyid = find( data < E );
valleyxy = zeros( numel( valleyid), 2 );
[valleyxy(:,1), valleyxy(:,2)] = ind2sub( [sz sz], valleyid);
clf
surface( data ); shading flat; colorbar
hold on
plot3( valleyxy(:,2), valleyxy(:,1), data( valleyid ),'o','Markersize',16 )
hold off
title(sprintf('%i vallies were found.',numel(valleyid)));
view(3);
figure(gcf)

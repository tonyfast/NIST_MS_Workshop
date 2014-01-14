%% Peak detection in the peaks dataset in matlab
%
%% Create the example dataset
sampleimage = round(double(imread('./Data/Example.png')./255));
[ data dev ] = PairCorrelationFFT( sampleimage, [], 'cutoff', 41);
errorbar( [ 1 : numel(data) ] -1, data, dev, 'LineWidth',3,'Color','k' );
xlim( [ 0 numel(data)] )
xlabel( 'Distance (pixels)','Fontsize',16 )
ylabel( 'Probability','Fontsize',16 )
grid on
set( gca, 'Fontsize', 14)
figure(gcf)

%% Design the filter to find the peak/,cutoff
fsz = 21; % Filter size
filter = ones( fsz,1 );
filter( ceil(fsz/2) ) = 0;

%% Dilate the image to find the peak
D = imdilate( data, filter);
peaksid = find( data > D );
plot( [ 1 : numel(data) ] -1, data, 'LineWidth',3,'Color','k' );
xlim( [ 0 numel(data)] )
xlabel( 'Distance (pixels)','Fontsize',16 )
ylabel( 'Probability','Fontsize',16 )
hold on
grid on
set( gca, 'Fontsize', 14)
plot( peaksid-1, data( peaksid ),'o','Markersize', 16 );
hold off
title(sprintf('%i peaks were found.',numel(peaksid)));
figure(gcf)

%% Erode the image to find the valleys
E = imerode( data, filter);
valleyid = find( data < E );
plot( [ 1 : numel(data) ] -1, data, 'LineWidth',3,'Color','k' );
xlim( [ 0 numel(data)] )
xlabel( 'Distance (pixels)','Fontsize',16 )
ylabel( 'Probability','Fontsize',16 )
hold on
grid on
set( gca, 'Fontsize', 14)
plot( valleyid-1, data( valleyid ),'o','Markersize', 16 );
hold off
title(sprintf('%i valley were found.',numel(valleyid)));
figure(gcf)
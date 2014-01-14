%% Digital Material Signal Processing
%
%% Indicator Functions
% Indicator functions identify the existance of a phase in space.
%
sz = 100;
radii = [ 21 4 6 6 6 10 ]; % Circle radii
% Make random circles that are indexed by their radius
data = randomcircles( sz, radii, radii );
subplot(1,2,1); pcolor(data); colorbar; shading flat; axis equal; axis tight;
xx = xlim; yy = xlim;

% An indicater function will identify the phases of interest like where the
% circles of radius six exist.
subplot(1,2,2); pcolor( double( data == 6 ) ); colorbar; shading flat; axis equal; axis tight;
xlim(xx);ylim(yy);
figure(gcf);


%% 
% Sometimes phases are bounded & continuous and the primitive basis can be used

sz = 100;
data = rand( sz );

bins = 0:.1:1;

DS = primitivebasis( data, bins );
disp( sprintf( horzcat( 'The size of the digital signal DS is ',repmat('%ix',1,ndims(DS)-1),'%i.'), size(DS)) );
disp( sprintf( 'The last dimension corresponds the number of bins, %i.', numel( bins ) ) );

%% Getting back the original data

weightedsignal = bsxfun(@times, DS, permute(bins(:),[2 : ( ndims(data) + 1 ) 1]));
originalsignal = sum( weightedsignal, ndims( weightedsignal ) );

%%
% There is numerical inaccuracy in the new signal which can be seen in the
% scale of the following colorbar
clf;
pcolor( data - originalsignal ); colorbar; shading flat; axis equal; axis tight;
figure(gcf);

%%
% There are other basis functions like Legendre polynomials that can used
% to discrete spatial values that are bounded and nonperiodic like volume
% fraction.
sz = 100;
data = peaks(sz);
data(:) = data - min(data(:));
data(:) = data ./ ( max(data(:)) - min(data(:))); 
L  = 0 : 6;
[ DP, LP ] = legendrebasis( data, L, [ 0 1] );

% Each layer in the signal is orthogonal to the others 

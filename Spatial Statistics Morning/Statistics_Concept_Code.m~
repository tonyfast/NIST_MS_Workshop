%% Brute Force Statistics Calculation
% Illustrate the fundamental concept of pair correlation functions and
% spatial statistics and what they physically mean.

%% Load in a Sample Image 
% after the path is set
addpath( '../functions/:..');

fn = './Data/15_2KX_6.png'; % filename
sampleimage = cast( imresize(imread( fn ),.1), 'double');

% Post process the image to be a double between zero and one
sampleimage(:) = round( sampleimage./255);

pcolor( sampleimage ); axis equal; shading flat
title(sprintf('Sample Image : %s', fn ), 'Interpreter','none','Fontsize',16 ); 
axis off; colormap gray;

%% Pair Correlation Function
% The pair correlation function is the probability of finding two features
% separated at a finite distance from each other.
%
% $$ p^{ij}_{r} = \sum^S_{r=1}{Insert and Equation} $$
%


veclen = 100 * [1 1];
dr = 10;
leftcorner = [300 450];
cntr = ( leftcorner + veclen(1)/2 );
pcolor( sampleimage ); axis equal; shading flat; colormap(summer);
hold on
% draw and annotate center point 
plot( cntr(1) , cntr(2), 'o','MarkerEdgeColor','k','MarkerSize',16); 
plot( cntr(1) , cntr(2), '.','MarkerEdgeColor','k','MarkerSize',16)
text( cntr(1) , cntr(2), '$$\mathbf{s}$$','Interpreter','Latex','Fontsize',30,...
    'VerticalAlignment','Bottom', 'HorizontalAlignment','Right'); 
% draw and annotate vector
plot( [ cntr(1) cntr(1) + cosd(45)*veclen(1)/2], ...
    [ cntr(2) cntr(2) + sind(45)*veclen(2)/2], ...
    'k-','MarkerEdgeColor','k','MarkerSize',16,'LineWidth',3); 
text( [ cntr(1) + cosd(45)*veclen(1)/4], ...
    [ cntr(2) + sind(45)*veclen(2)/4], ...
    '$$|\mathbf{r}|$$','Interpreter','Latex','Fontsize',30,'VerticalAlignment','Top'); 
% draw circles
rectangle('Position',[leftcorner+dr/2,veclen-dr],'Curvature', [ 1 1],'LineWidth',3,'Linestyle',':')
rectangle('Position',[leftcorner-dr/2, veclen+dr],'Curvature', [ 1 1],'LineWidth',3,'Linestyle',':')
hold off
xlim( cntr(1) + [-1 1].* veclen)
ylim( cntr(2) + [-1 1].* veclen)

%%
% In the above image, the pair correlation function defines the probability
% that a feature at the center of the annulus, $\mathbf{d}$, is a distance,
% $|\mathbf{r}|$, away from another phase of interest.

%% A prototypical way of computing pairwise correlation functions
% The following blocks of code illustrate ONE method of computing the
% pair correlation function using the histogram of the pairwise distance
% matrix.

% 1. Find where the feature of interest of exists
sz = 100;
feature = 0;
[ x y ] = find( sampleimage(1:sz,1:sz) == feature ); % Find all points in the image where the feature is zero

%%
% 2. Lower half of the Pairwise distance matrix
D = pdist( [ x y ] ); 

%%
% 3. Compute the histogram of pairwise distances 
bins =  0 :( sz/2+1 );  
[ I ] = hist( D , bins );
numer = [numel( x ), I(2:(end-1))]; % Add the zero distance of the correlation function
bins2=bins(1:(end-1));           % Remove the last bin because it includes information beyond what the analysis is concerned with.
%%
% 4. Create the normalization, or denominator
% I am computing the normalization by convolving a big matrix of ones with
% itself by turning normalize to be false.
[F, X] =  SpatialStatsFFT(ones(sz),[],'normalize',false );  
id = round(bsxfun( @hypot, X.values{1}',X.values{2} ));
denom = accumarray(id(id<=(max(bins2)))+1,F(id<=max(bins2)),[numel(bins2) 1],@sum);

plot( bins2, numer(:)./denom(:), 'ko-', 'LineWidth', 3 )

%%
AnimatePairCorrelation;

%%
AntimateSpatialStats;
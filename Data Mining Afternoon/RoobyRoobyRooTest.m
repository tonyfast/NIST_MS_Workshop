%% Structure-Structure Relationships
% This script uses the RoobyRoobyRoo molecular dynamics dataset to compare
% different potential models in Scooby Snacks Molecular Dynamics
% simulations.  The work flow uses pair correlation functions to
% statistically describe the models then use dimension reduction to
% visualize the comparison.

%% Load data and Compute Statistics
% Incrementally Compute the Pair Correlation function using the pairwise
% distance function.

loc = '../Data/ScoobySnacks';
ff = dir( fullfile( loc, '*.mat') );

cutoff = 60; inc = 1;
tvector = 0 : inc : cutoff;
for ii = 1 : numel( ff )
    load( fullfile( loc, ff( ii ).name),'meta','data' );
    if ii == 1 flds = fieldnames( meta ); end
    T(ii,:) = structfun( @(x)double(x(end)), meta,'UniformOutput',true);
    if ii == 1
        FEATURE = zeros( numel(ff), numel( tvector ) );
        distance = zeros( 1, size( data,1)^2/2 - size( data,1)/2 );
    end
    classname{ii} = meta.class;
    % Pairwise distance function
    distance(:) = pdist( data );
    [FEATURE(ii,:), ] = hist( distance, tvector );
    FEATURE(ii,1) = size( data,1 );
end

%% Dimension Reduction

W = bsxfun( @minus, FEATURE, mean(FEATURE,1) );
b = std( FEATURE,[],1) > 0;
% W(:,b) = bsxfun( @rdivide, W(:,b), std(FEATURE(:,b),[],1) );
W(:) = bsxfun( @rdivide, W, sqrt(sum(FEATURE.^2,2)) );



b = ones( 1, size(FEATURE,2) );
b(end) = 0;
b(all( ~isinf(W) | ~isnan(W),1 ) )= 0 ;
[ U S V ] = pca( W(:,1:(end-1)), 10 );

[umem, ~,id] = unique( classname );
sortid = [sortrows([id,T(:,1)],1)];
xx = find( sortid(2:end) == sortid(1:(end-1)) )


GRAPH = sparse(xx,xx+1,1,size(FEATURE,2),size(FEATURE,2));
GRAPH = GRAPH + GRAPH';

co = cbrewer('qual','Set1',21);
gplot3( GRAPH, U, 'k' );
hold on
for ii = 1 : max( id )
    h(ii) = plot3(  U(id==ii,1), U(id==ii,2), U(id==ii,3), 'ks','Markerfacecolor',co(ii,:),'Markersize',15);
end
legend( h, umem );
grid on
hold off
figure(gcf)

%%  Structure Property Homogenization Relationship

b = strcmp(flds, 'Press');

FF = FeaturetoPoly( U(:,1:10),3);
[~,p ] = rref( FF );
[coeff bint r rint] = regress( T(:,b), FF(:,p));
mean(abs(r))

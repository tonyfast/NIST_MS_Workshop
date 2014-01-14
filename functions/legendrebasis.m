function [ DP, legpoly] = legendrebasis( data, l, lims );

if nargin < 3
    lims = [-1 1];
end

N = numel(data );
DP = zeros( horzcat( size(data), numel(l) ) );

%% Normalize the data to be between negative one and one

data(:) = 2*(((data-lims(1))./diff(lims))-.5);
%%
for gg = 1 : numel( l )
    P = { 1, [ 1 0] };
    for jj =  2 : l(gg)
        ii = jj - 1;
        P{3 } = ( [(2*ii+1)*P{ 2 },0] - [0 , 0 , ii * P{1}] ) ./ (ii+1);
        P{1} = P{2};
        P{2} = P{3};
    end
    disp(P{2});

    switch l(gg)
        case 0
            P{2} = 1;
        case 1
            P{2} = [ 1 0 ];
    end
    if nargout == 2
        legpoly{gg} = P{2};
    end
    DP( [1:N] + N*(gg-1)) = polyval( P{2}, data );
end
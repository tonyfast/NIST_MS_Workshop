function [ data xx ] = randomcircles( sz, radii, nphase )
% Create an image with the dimensions size with non overlapping circles containing the
% radii assigned as an index.
% data - image with randomly placed circles
% xx - the positions of the peaks.

if nargin < 3
    nphase = 1*size(radii);
end

[ radii(:) shift ] = sort( radii );

data = zeros( sz );

ncircle = numel( radii );

mr = max( radii ); % maximum radius
[ X Y ] = meshgrid( -mr:mr, -mr:mr );
DIST = sqrt( X.^2 + Y.^2 );
temp = ones(sz);
for ii = 1 : ncircle
    filter = DIST < (radii(ii)+.5);
    temp(:) = 1;
    while ii == 1 | all(temp==1) | any( and( data(:), temp(:) ) )
        [ xx(ii,:) ] = round(rand( 1,2) .* (sz-1))+1;
        temp(:) = 0;
        temp(xx(ii,2),xx(ii,1)) = 1;
        temp(:) = imdilate( temp, filter );
        if ii == 1 
            break
        end
    end
    
    if numel( nphase ) == 1
        data(:) = data + temp*(round(rand(1)*(nphase-1))+1);
    else
        data(:) = data + temp*nphase(shift(ii));
    end
end
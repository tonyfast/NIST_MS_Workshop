function DSP = primitivebasis( A, bins )
% DMS is the output digital microstructure signal

% number of dimensions in the dataset
nd = ndims( A );
% number of bins
nb = numel( bins );

DSP = zeros( horzcat( size(A), nb ) );

DSP(:) = bsxfun( @minus, A, permute(bins(:), [2:(nd+1) 1]));
DSP(:) = bsxfun( @rdivide, DSP, permute(gradient(bins(:)), [2:(nd+1) 1]));
DSP(:) = abs( DSP(:) );
DSP( DSP > 1 ) = 0;
DSP( DSP ~= 0 ) = 1 - DSP( DSP ~= 0 );
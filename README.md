NIST_MS_Workshop
================


pdist = @(x)sqrt(sum(bsxfun( @minus, permute( x, [1 3 2]), permute( x, [3 1 2])).^2,3));

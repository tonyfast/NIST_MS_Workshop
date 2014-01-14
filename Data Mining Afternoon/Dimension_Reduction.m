%% Principal Component Analysis


X = rand(100,12);
[ U S V ] = pca(bsxfun(@minus, X, mean(X,2)),6);

[Usvd Ssvd Vsvd ] = svd( bsxfun(@minus, X, mean(X,2)) );

diag(S),diag(Ssvd)

%% The first few eigenvalues of the covariance matrix of the data
sqrt(eig(X'*X)) 
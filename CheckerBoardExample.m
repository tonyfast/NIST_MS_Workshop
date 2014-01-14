%% Tell me about this image
%
A = round(checkerboard( 20,20 ));
imshow(A);
figure(gcf);

L = bwlabel(A,4);
pcolor(L); shading flat;
colormap( rand( max(L(:)),3))

%% Separate 0 and nonzero features
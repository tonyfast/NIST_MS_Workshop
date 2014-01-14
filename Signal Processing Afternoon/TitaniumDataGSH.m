dataloc = '../Data/Deformed.h5';

datastruc = h5read( dataloc, '/RAW');

GSHcell = arrayfun(@(x,y,z)gsh_hcp_tri_L_4(x,y,z),datastruc.phi_2,datastruc.PHI,datastruc.phi_1,'UniformOutput',false);

%%
GSH = permute(reshape(cell2mat(GSHcell),[15 size(GSHcell,1) size(GSHcell,2) ] ),[ 2 3 1]);

[Gx,Gy] = gradient(GSH);

figure(2)
Feature = real(sum(sqrt(Gx.^2+Gy.^2),3));
subplot(1,2,1)
pcolor(Feature); 
shading flat; colormap jet; colorbar;
subplot(1,2,2);
hist( Feature(Feature>1e-1), 51)
figure(gcf)
subplot(1,2,1)
spy(Feature>1)

%%  Add features

Feature = real(sum(sqrt(Gx.^2+Gy.^2),3)) .* (1./datastruc.Image_Quality);
Feature(isinf(Feature)) = max(Feature(~isinf(Feature)));

subplot(1,2,1)
pcolor(Feature); 
shading flat; colormap jet;colorbar;
subplot(1,2,2);
[ yy,xx] = hist( Feature(:), 101);
plot(xx,yy,'LineWidth',3)
set(gca,'Yscale','log')
grid on
figure(gcf)

subplot(1,2,1)
spy( Feature > .002 );figure(gcf)
X = rand( 21,2);

T = delaunayn(X);
perms = [ 1 2; 2 3; 1 3];
G = sparse(21,21);
pdist = @(x)sqrt(sum(bsxfun( @minus, permute( x, [1 3 2]), permute( x, [3 1 2])).^2,3));
D = pdist(X);
for ii = 1 : 3
    G(:) = G + sparse( T(:,perms(ii,1)), T(:,perms(ii,2)) , D( sub2ind( [ 21 21], T(:,perms(ii,1)), T(:,perms(ii,2)) )),21,21)

end
G(:) = G + G'

gplot( G, X,'k-')
hgp = findobj( 'Color','k','LineStyle','-');
set(hgp, 'LineWidth',3)
hold on
plot( X(:,1), X(:,2),'kd','Markerfacecolor','c','Markersize',15);
hold off
%%
st = 1;
[ D, p ] = dijkstra( G,st);
endnodes =[  getOutput( @min, 2, abs(D-mean(D))) getOutput( @max, 2, D) ];
co ='rb';
for ii = 1 : numel(endnodes)
    ct= 1;
    nd = [];
    nd(1) = endnodes(ii);
    while nd(ct) ~= 0
        ct = ct + 1;
        nd(ct) = p(nd(ct-1));
    end
    nd(end) = st;
    if ii == 1 hold on; end
    plot( X(nd,1), X(nd,2), horzcat(co(ii),'--x'),'LineWidth',4)
end
hold off
figure(gcf)

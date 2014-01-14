function P = FeaturetoPoly( data, pord );

nd = size( data, 2);


prevct = 1;
P = ones( size(data,1),1);
ct = 0;
for ii = 1 : pord
    fp = true;
    for jj = prevct: size(P,2)
        for ll = 1 : nd
            if fp fp = false; prect = size(P,2); end
            prevct = size(P,2);
            ct = ct + 1;
            P(:,ct) = P(:,jj).*data(:,ll);
        end
    end
    
end

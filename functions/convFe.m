function fe = convFe(dt,KK,eta)

    [index1,~] = size(eta);
    if index1 ~= 1
        eta = eta.';
    end
    [index1,~] = size(KK);
    if index1 ~= 1
        KK = KK.';
    end 

    etaMat = flipud(buffer(eta,length(KK),length(KK)-1));

    fe = dt*KK*etaMat;
end
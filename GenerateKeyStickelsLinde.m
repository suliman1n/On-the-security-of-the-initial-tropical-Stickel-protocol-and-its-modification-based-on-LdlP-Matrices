function [key,U,V,W] = GenerateKeyStickelsLinde(n,min_W,max_W,k_range,a_range)
    
    
    k1=randi([0, k_range]);
    k2=randi([0, k_range]);
    a=randi([a_range, 0]);
    b=randi([a_range, 0]);
    W=randi([min_W,max_W],n,n);
    %W=MaxplusId(n);
    A1 = GenerateRandomMatrixLindePuente(n, k1, a);
    A2 = GenerateRandomMatrixLindePuente(n, k2, b);

    l1=randi([0, k_range]);
    l2=randi([0, k_range]);
    c=randi([a_range, 0]);
    d=randi([a_range, 0]);
    B1 = GenerateRandomMatrixLindePuente(n, l1, c);
    B2 = GenerateRandomMatrixLindePuente(n, l2, d);

    

    
    temp1=TropMulti(A1,W);
    U = TropMulti(temp1,A2);

    temp2=TropMulti(B1,W);
    V = TropMulti(temp2, B2);

    
    KA = TropMulti(A1, TropMulti(V,A2));
    KB = TropMulti(B1, TropMulti(U,B2));

    
    if isequal(KA, KB)
        key = KA;
    else
        key = [];
    end
end

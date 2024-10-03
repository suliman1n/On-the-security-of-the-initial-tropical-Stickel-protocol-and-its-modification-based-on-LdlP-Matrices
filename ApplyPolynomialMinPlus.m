function V_X = ApplyPolynomialMinPlus(V, X)
    
    [n, m] = size(X);
    [p, q] = size(V);
    D = zeros(n, m) + (inf);
    temp = D;
    for i = 1:q
        if V(1, i) == 0
            temp = minplusTropId(n) + V(2, i);
            D = min(D, temp);
        else
            c = fastpowerminplus(X, V(1, i));
            temp = V(2, i) + c;
            D = min(D, temp);
        end
    end
    
    V_X = D;
end
function [key,U,V,A,B,W] = GenerateKeyStickels(n, mm, mM, D, pm, pM)
    
    A = randi([mm, mM], n);
    B = randi([mm, mM], n);
    %W=randi([mm, mM], n);
    W=minplusTropId(n);

    
    p1 = GenerateRandomPolynomial(D, pm, pM);
    p2 = GenerateRandomPolynomial(D, pm, pM);
    q1 = GenerateRandomPolynomial(D, pm, pM);
    q2 = GenerateRandomPolynomial(D, pm, pM);

    
    temp = minplusMulti(ApplyPolynomialMinPlus(p1, A), W);
    U=minplusMulti(temp,ApplyPolynomialMinPlus(p2, B));

    temp = minplusMulti(ApplyPolynomialMinPlus(q1, A), W);
    V=minplusMulti(temp,ApplyPolynomialMinPlus(q2, B));

    
    KA = minplusMulti(ApplyPolynomialMinPlus(p1, A), minplusMulti(V, ApplyPolynomialMinPlus(p2, B)));
    KB = minplusMulti(ApplyPolynomialMinPlus(q1, A), minplusMulti(U, ApplyPolynomialMinPlus(q2, B)));

    
    if isequal(KA, KB)
        key = KA;
    else
        key = [];
    end
end

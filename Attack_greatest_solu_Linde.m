function recovered_key = Attack_greatest_solu_Linde(U,V,W)
    
    n = size(U, 1);

    c = zeros(n^2, n^2);

    for alpha = 1:n^2
        for beta = 1:n^2
            temp=TropMulti(get_generatorLinde(alpha, n)',W);
            T = TropMulti(temp,get_generatorLinde(beta, n)') - U;

            
            c_ab = min(-1*T(:));
            c(alpha,beta) = c_ab;
        end
    end



    recovered_key = -inf * ones(n, n); 


for i = 1:n^2  
    for j = 1:n^2
        mat = TropMulti(TropMulti(get_generatorLinde(i, n)', V), get_generatorLinde(j, n)');
        recovered_key = max(recovered_key, c(i,j) + mat); 
    end
end
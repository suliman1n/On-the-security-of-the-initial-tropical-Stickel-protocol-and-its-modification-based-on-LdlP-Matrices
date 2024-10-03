function [S, c,x,y,cover,K_attack] = AttackLinde(U,V,W)
    
    n = size(U, 1)*size(U, 1);



    
    S = cell(n, n);
    c = zeros(n, n);

    for alpha = 1:n
        for beta = 1:n
            temp=TropMulti(get_generatorLinde(alpha, sqrt(n))',W);
            T = TropMulti(temp,get_generatorLinde(beta, sqrt(n))') - U;

            
            c_ab = min(-1*T(:));

            if c_ab >= 20000
                S_ab = zeros(size(T));
            else
                S_ab = (-1*T == c_ab);
            end

      

            S{alpha,beta} = S_ab;
            c(alpha,beta) = c_ab;
        end
    end

    % find one small cover of [1,n]x[1,n]

    cover = findMinimumCover1(S);

        
    [alpha, beta] = ind2sub([n, n], cover);
    cover_alpha_beta = [alpha', beta'];
    [x, y] = SolveSystemGivenCoverLinde(cover_alpha_beta, c);
    if ~isempty(x)
      
            K_attack = TropMulti(reshape(x, sqrt(n), sqrt(n)),TropMulti(V,reshape(y, sqrt(n), sqrt(n))));
            %key==K_attack
    else
        K_attack=[];
    end

end




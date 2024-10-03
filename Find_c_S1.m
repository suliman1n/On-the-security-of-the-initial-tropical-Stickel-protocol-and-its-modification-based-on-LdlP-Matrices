function [S, c] = Find_c_S1(A, B,W, U,d)
    
   
    
    S = cell(d + 1, d + 1);
    c = zeros(d + 1, d + 1);

    for alpha = 0:d
        for beta = 0:d
            temp=minplusMulti(fastpowerminplus(A,alpha),W);
            T = minplusMulti(temp, fastpowerminplus(B,beta)) - U;

            
            c_ab = min(T(:));            
            S_ab = (T == c_ab);
            

      
            S{alpha+1,beta+1} = S_ab;
            c(alpha+1,beta+1) = c_ab;
        end
    end
end
function A = fastpowerminplus(B, t)
    [n, m] = size(B);
    
    if (n ~= m)
        error("Dimension Error! Not a square matrix")
    end
    
    if t == 0
        A = minplusTropId(n);
        return
    end 
    
    exp = dec2bin(t);
    value = minplusTropId(n); 
    
    for i = 1:length(exp)
        value = minplusMulti(value, value);
        
        if exp(i) == '1'
            value = minplusMulti(value, B);
        end
    end
    
    A = value;
end

function result = GenerateRandomMatrixLindePuente(n, k, a)
    result = zeros(n, n);
    for i = 1:n
        for j = 1:n
            if i == j
                result(i, j) = k; %negative
            else
                result(i, j) = randi([2*a, 1*a]);
            end
        end
    end
end
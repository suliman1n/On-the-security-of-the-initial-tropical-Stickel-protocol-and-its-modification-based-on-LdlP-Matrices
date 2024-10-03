function [x, y] = SolveSystemGivenCover(cover_alpha_beta, c)
    [n, ~] = size(c);

    
    Aeq = [];
    beq = [];
    A = [];
    b = [];
    for k = 1:size(cover_alpha_beta, 1)
        alpha = cover_alpha_beta(k, 1);
        beta = cover_alpha_beta(k, 2);

        % Equality constraints for elemtns in the cover
        Aeq = [Aeq; zeros(1, 2 * n)]; 
        Aeq(end, alpha) = 1; 
        Aeq(end, n + beta) = 1; 
        beq = [beq; -c(alpha, beta)];
    end

    % Inequality constraints for elemnts to in the cover
    for i = 1:n
        for j = 1:n
            if ~ismember([i, j], cover_alpha_beta, 'rows')
                A = [A; zeros(1, 2 * n)];
                A(end, i) = -1;
                A(end, n + j) = -1;
                b = [b; c(i, j)];
            end
        end
    end

    
    f = zeros(1, 2*n);

    intcon = 1:2 * n;

    
    options = optimoptions('intlinprog', 'Display', 'off');
    z = intlinprog(f,intcon,A,b,Aeq,beq,[],[],options);

    % Check if a solution exists
    if isempty(z)
        x = [];
        y = [];
        return;
    end

    x = z(1:n);
    y = z(n+1:end);

end

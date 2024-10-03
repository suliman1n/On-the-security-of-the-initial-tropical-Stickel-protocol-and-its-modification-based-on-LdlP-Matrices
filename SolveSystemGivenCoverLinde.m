function [x, y] = SolveSystemGivenCoverLinde(cover_alpha_beta, c)
    [n, ~] = size(c);

    
    Aeq = [];
    beq = [];
    Ain = [];
    bin = [];
    for k = 1:size(cover_alpha_beta, 1)
        alpha = cover_alpha_beta(k, 1);
        beta = cover_alpha_beta(k, 2);

        % Equality constraints for elemtns in the cover
        Aeq = [Aeq; zeros(1,n+n+4)]; 
        Aeq(end, alpha) = 1; 
        Aeq(end, n + beta) = 1; 
        beq = [beq; c(alpha, beta)];
    end

    % Inequality constraints for elemnts not in the cover
    for i = 1:n
        for j = 1:n
            if ~ismember([i, j], cover_alpha_beta, 'rows')
                Ain = [Ain; zeros(1, n+n+4)];
                Ain(end, i) = 1;
                Ain(end, n + j) = 1;
                if c(i,j)==inf
                    c(i,j)=10000;
                end
                bin = [bin; c(i, j)];
            end
        end
    end


    %x constrains
    for i = 1:sqrt(n)
        for j = 1:sqrt(n)
            if (i==j)
                Aeq = [Aeq; zeros(1,n+n+4)];
                Aeq(end,(i-1)*sqrt(n)+j)=1;
                Aeq(end,n+n+3)=-1;
                beq=[beq;0];
            else
                Ain = [Ain; zeros(2,n+n+4)];
                Ain(end-1,(i-1)*sqrt(n)+j)=-1;
                Ain(end-1,n+n+1)=2;
                Ain(end,(i-1)*sqrt(n)+j)=1;
                Ain(end,n+n+1)=-1;
                bin=[bin;0;0];

            end   
        end
    end

    
    %y constrains
    for i = 1:sqrt(n)
        for j = 1:sqrt(n)
            if (i==j)
                Aeq = [Aeq; zeros(1,n+n+4)];
                Aeq(end,n+(i-1)*sqrt(n)+j)=1;
                Aeq(end,n+n+4)=-1;
                beq=[beq;0];
            else
                Ain = [Ain; zeros(2,n+n+4)];
                Ain(end-1,n+(i-1)*sqrt(n)+j)=-1;
                Ain(end-1,n+n+2)=2;
                Ain(end,n+(i-1)*sqrt(n)+j)=1;
                Ain(end,n+n+2)=-1;
                bin=[bin;0;0];

            end   
        end
    end





    
    f = zeros(1, n+n+4);

    intcon = 1:n+n+4;

   
    lb = -inf * ones(n+n+4, 1);
    lb(end-1:end) = 0;

    ub = inf * ones(n+n+4, 1);
    ub(end-3:end-2) = 0;

    
    options = optimoptions('intlinprog', 'Display', 'off');
    z = intlinprog(f,intcon,Ain,bin,Aeq,beq,lb,ub,options);
    %z=linprog(f,Ain,bin,Aeq,beq,lb,ub);

    % Check if a solution exists
    if isempty(z)
        x = [];
        y = [];
        return;
    end

    x = z(1:n);
    y = z(n+1:end-4);

end

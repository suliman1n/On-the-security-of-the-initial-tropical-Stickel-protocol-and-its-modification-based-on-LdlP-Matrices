num_trials = 1;
time_taken_avg = zeros(1, 12);
n_values = 2:13;

for n = n_values
    time_taken_trials = zeros(1, num_trials);
    
    for trial = 1:num_trials
        tic;
        k_range = 100;
        a_range = -100;
        min_W=-100;
        max_W=100;
        [key,U,V,W] = GenerateKeyStickelsLinde(n,min_W,max_W,k_range,a_range);
        n = size(U, 1);

        X_ind = reshape(1:n^2, n, []).';
        Y_ind = reshape(n^2+1:2*n^2, n, []).';
        w5_ind = reshape(2*n^2+4+1:2*n^2+4+n^4, n*n, []).';

        M = 100000;
        Ain = zeros(2*n^4, 2*n^2+4+n^4);
        bin = zeros(2*n^4, 1);
        Aeq = zeros(n^2,2*n^2+4+n^4);
        beq = zeros(n^2, 1);

        Ain_row_counter = 1;
        Aeq_row_counter = 1;

        for i = 1:n
            for j = 1:n
                for k = 1:n
                    for l = 1:n
                        Ain(Ain_row_counter, X_ind(i, k)) = 1;
                        Ain(Ain_row_counter, Y_ind(l, j)) = 1;
                        bin(Ain_row_counter) = U(i, j) - W(k, l);
                        Ain_row_counter = Ain_row_counter + 1;
                    end
                end

                for k = 1:n
                    for l = 1:n
                        Ain(Ain_row_counter, X_ind(i, k)) = -1;
                        Ain(Ain_row_counter, Y_ind(l, j)) = -1;
                        Ain(Ain_row_counter, w5_ind(n*(i-1)+j, n*(k-1)+l)) = M;
                        bin(Ain_row_counter) = -U(i, j) + M + W(k, l);
                        Ain_row_counter = Ain_row_counter + 1;
                    end
                end

                Aeq(Aeq_row_counter, w5_ind(n*(i-1)+j, 1:n^2)) = ones(1, n^2);
                beq(Aeq_row_counter) = 1;
                Aeq_row_counter = Aeq_row_counter + 1;
            end
        end

        for i = 1:n
            for j = 1:n
                if i == j
                    Aeq = [Aeq; zeros(1, 2*n^2+4+n^4)];
                    Aeq(end, (i-1)*n + j) = 1;
                    Aeq(end, n^2 + n^2 + 3) = -1;
                    beq = [beq; 0];
                else
                    Ain = [Ain; zeros(2, 2*n^2 + 4 + n^4)];
                    Ain(end-1, (i-1)*n + j) = -1;
                    Ain(end-1, n^2 + n^2 + 1) = 2;
                    Ain(end, (i-1)*n + j) = 1;
                    Ain(end, n^2 + n^2 + 1) = -1;
                    bin = [bin; 0; 0];
                end
            end
        end

        for i = 1:n
            for j = 1:n
                if i == j
                    Aeq = [Aeq; zeros(1, 2*n^2 + 4 + n^4)];
                    Aeq(end, n^2 + (i-1)*n + j) = 1;
                    Aeq(end, n^2 + n^2 + 4) = -1;
                    beq = [beq; 0];
                else
                    Ain = [Ain; zeros(2, 2*n^2 + 4 + n^4)];
                    Ain(end-1, n^2 + (i-1)*n + j) = -1;
                    Ain(end-1, n^2 + n^2 + 2) = 2;
                    Ain(end, n^2 + (i-1)*n + j) = 1;
                    Ain(end, n^2 + n^2 + 2) = -1;
                    bin = [bin; 0; 0];
                end
            end
        end

        f = zeros(1, 2*n^2 + 4 + n^4);
        intcon = 1:2*n^2 + 4 + n^4;
        lb = -inf * ones(2*n^2 + 4 + n^4, 1);
        lb(2*n^2 + 3:2*n^2 + 4) = 0;
        ub = inf * ones(2*n^2 + 4 + n^4, 1);
        ub(2*n^2 + 1:2*n^2 + 2) = 0;
        lb(2*n^2 + 4 + 1:end) = 0;
        ub(2*n^2 + 4 + 1:end) = 1;

        model.A = sparse([Ain; Aeq]);
        model.obj = f;
        model.modelsense = 'min';
        model.rhs = [bin; beq];
        model.lb = lb;
        model.ub = ub;
        model.vtype = [repmat('C', 1, 2*n^2 + 4), repmat('B', 1, n^4)];
        model.sense = [repmat('<', size(Ain, 1), 1); repmat('=', size(Aeq, 1), 1)];

        params.outputflag = 1;
        params.BranchDir = 0;
        params.MIPFocus = 0;
        params.TimeLimit = 60*1000;

        result = gurobi(model, params);

        z = result.x;
        x = z(1:n^2);
        y = z(n^2+1:2*n^2);
        temp = TropMulti(reshape(x, n, n)', V);
        K_attack = TropMulti(temp, reshape(y, n, n)');

        time_taken_trials(trial) = toc;
    end
    
    time_taken_avg(n-1) = mean(time_taken_trials);
end

figure;
plot(n_values, time_taken_avg, '-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Dimension n', 'FontSize', 12);
ylabel('Average Time Taken (seconds)', 'FontSize', 12);
title('Average Time to Recover Key vs Dimension n', 'FontSize', 14);
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

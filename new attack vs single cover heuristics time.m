n = 10;
mm = -1000;
mM = 1000;
pm = -1000;
pM = 1000;
num_trials = 1; 


time_attack1 = zeros(1, 9); 
time_attack2 = zeros(1, 9); 


for D = 2:10
    attack1_times = []; 
    attack2_times = []; 
    
    for trial = 1:num_trials
        [key, U, V, A, B, W] = GenerateKeyStickels(n, mm, mM, D, pm, pM);

        
        d = D;
        tic;
        [S, c] = Find_c_S1(A, B, W, U, d);
        cover = findMinimumCover1(S);
        [dPlusOne, ~] = size(S);
        linearIndex = cover;
        [alpha, beta] = ind2sub([dPlusOne, dPlusOne], linearIndex);
        cover_alpha_beta = [alpha', beta'];
        [x, y] = SolveSystemGivenCover(cover_alpha_beta, c);

        if ~isempty(x)
            K_attack1 = minplusMulti(ApplyPolynomialMinPlus([0:d; x'], A), ...
                        minplusMulti(V, ApplyPolynomialMinPlus([0:d; y'], B)));
            if all(K_attack1 == key) 
                attack1_time = toc; 
                attack1_times = [attack1_times, attack1_time]; 
            else
                toc; 
            end
        else
            toc; 
        end

        
        tic; 
        [S, c] = Find_c_S1(A, B, W, U, d);
        K_attack2 = inf * ones(n, n);

        for i = 0:d
            for j = 0:d
                mat = minplusMulti(minplusMulti(fastpowerminplus(A, i), V), fastpowerminplus(B, j));
                K_attack2 = min(K_attack2, -c(i+1,j+1) + mat);
            end
        end
        if all(K_attack2 == key) 
            attack2_time = toc; 
            attack2_times = [attack2_times, attack2_time];
        else
            toc; 
        end
    end
    
    
    if ~isempty(attack1_times)
        time_attack1(D-1) = mean(attack1_times);
    else
        time_attack1(D-1) = NaN; 
    end
    
    if ~isempty(attack2_times)
        time_attack2(D-1) = mean(attack2_times);
    else
        time_attack2(D-1) = NaN; 
    end
end


D_values = 2:10;
figure;
plot(D_values, time_attack2, '-o', 'DisplayName', 'The new Attack', 'LineWidth', 2);
hold on;
plot(D_values, time_attack1, '-s', 'DisplayName', 'The Heuristic', 'LineWidth', 2,'Color',[1 0.5 0]);
xlabel('Polynomial degree D');
ylabel('Average Time (seconds)');
legend('show');
grid on;

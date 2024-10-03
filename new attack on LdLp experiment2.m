n_values = 2:20;
trial_count = 10;
k_range = 100;
a_range = -100;
W_ranges = [-10, 10; -100, 100; -1000, 1000; -100000, 100000];
success_rates = zeros(length(n_values), size(W_ranges, 1));

for w_idx = 1:size(W_ranges, 1)
    min_W = W_ranges(w_idx, 1);
    max_W = W_ranges(w_idx, 2);
    
    for i = 1:length(n_values)
        n = n_values(i);
        success_count = 0;
        
        for trial = 1:trial_count
            [key, U, V, W] = GenerateKeyStickelsLinde(n, min_W, max_W, k_range, a_range);
            recovered_key = Attack_greatest_solu_Linde(U, V, W);
            
            if isequal(recovered_key, key)
                success_count = success_count + 1;
            end
        end
        
        success_rates(i, w_idx) = success_count / trial_count;
    end
end


figure;
hold on;


line_styles = {'-', '--', ':', '-.'};
markers = {'o', 's', 'd', 'x'};  

for w_idx = 1:size(W_ranges, 1)
    plot(n_values, success_rates(:, w_idx), ...
        'LineStyle', line_styles{w_idx}, 'Marker', markers{w_idx}, ...
        'LineWidth', 2, 'DisplayName', sprintf('[%d, %d]', W_ranges(w_idx, 1), W_ranges(w_idx, 2)));
end


xlabel('Dimension n');
ylabel('Success Rate');
legend('show', 'Location', 'best');
title('Success Rate vs Dimension n for Different W Ranges');
grid on;

hold off;

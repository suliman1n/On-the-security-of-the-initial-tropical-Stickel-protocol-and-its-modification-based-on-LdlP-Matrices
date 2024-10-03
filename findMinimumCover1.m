function cover = findMinimumCover1(S)
    n=size(S{1},1);
    sum_S_ab = zeros(n, n);
    cover = [];
    while any(sum_S_ab(:) == 0)
        [i, j] = find(sum_S_ab == 0, 1);
        S_ab_ij = find(cellfun(@(x) x(i,j) == 1, S));
        counts = cellfun(@(x) sum(x(:)), S(S_ab_ij));
        [~, largest] = max(counts);
        largest_ab=S_ab_ij(largest);
        if ~ismember(largest_ab, cover)
            cover = [cover, largest_ab];
            sum_S_ab = sum_S_ab + S{largest_ab};
        end
    end
end
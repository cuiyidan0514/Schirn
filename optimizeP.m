function P = optimizeP(alpha, candidate_labels, C)
    tmp = candidate_labels - C;
    th = alpha / 2;
    P = zeros(size(candidate_labels));
    P(tmp > th) = tmp(tmp > th) - th;
    P(tmp < -th) = tmp(tmp < -th) + th;
    %P = candidate_labels - C;
    P = max(P,0);
    P = min(P,candidate_labels);
    P(P>0.5) = 1;
    P(P<=0.5) = 0;
end
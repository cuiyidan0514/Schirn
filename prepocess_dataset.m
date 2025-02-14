function features = prepocess_dataset(features, threshold)
% 归一化
mean_features = mean(features);  
std_features = std(features);  
standardized_features = (features - mean_features) ./ std_features;  
% 稀疏化
sparse_features = standardized_features;  
sparse_features(abs(sparse_features) < threshold) = 0; 
% 对非零元素再次归一化
non_zero_elements = sparse_features(sparse_features ~= 0);    
if ~isempty(non_zero_elements)  
    min_non_zero = min(non_zero_elements);  
    max_non_zero = max(non_zero_elements);    
    normalized_features = sparse_features;  
    if max_non_zero ~= min_non_zero  
        normalized_features(normalized_features ~= 0) = ...  
            (normalized_features(normalized_features ~= 0) - min_non_zero) / (max_non_zero - min_non_zero);  
    else   
        normalized_features(normalized_features ~= 0) = 1;   
    end  
else  
    normalized_features = sparse_features;
end
% 去除nan
normalized_features(isnan(normalized_features)) = 0;  
features = normalized_features;

end
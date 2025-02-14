%addpath(genpath(pwd))

% dataset

data = load('..\dataset\real-world\music_style.mat');
%data = load('YeastMF_3.mat');

% parameter settings
r=200; 
nfold = 5;
generate_dataset = false;

lambda_range = 0.04;
%lambda_range = 0.01:0.01:0.1;

alpha_range = 0.5;
%alpha_range = 0.1:0.1:2;

beta_range = 0.1;
%beta_range = [0.1,10,100,250,1000];

[lambda_grid, alpha_grid, beta_grid] = ndgrid(lambda_range,alpha_range,beta_range);

lambda_list = lambda_grid(:);
alpha_list = alpha_grid(:);
beta_list = beta_grid(:);

best_score = struct('avgpre', 0, 'oneerror', 0, 'rankloss', 0, 'cvg', 0, 'hamming', 0);
best_params = struct('lambda', 0, 'alpha', 0, 'beta', 0);
best_prec = 0;

for i = 1:length(lambda_list)  

    lambda = lambda_list(i);  
    alpha = alpha_list(i);  
    beta = beta_list(i); 
    %disp(lambda);
    %disp(alpha);
    %disp(beta);

    [P, cvg_result, prec_result, rank_result, auc_result, oneerror_result, hamming_result, avgauroc_result, top1_result, top3_result, top5_result] = run_arts(r, data, generate_dataset, lambda, alpha, beta);   
    fprintf('\n');
    
    % fprintf('average precision mean:%.3f,std:%.3f\n',mean(prec_result),std(prec_result));
    % fprintf('OneError loss mean:%.3f,std:%.3f\n',mean(oneerror_result),std(oneerror_result));
    % fprintf('ranking loss mean:%.3f,std:%.3f\n',mean(rank_result),std(rank_result));
    % fprintf('coverage mean:%.3f,std:%.3f\n',mean(cvg_result),std(cvg_result));
    % fprintf('hamming loss mean:%.3f,std:%.3f\n',mean(hamming_result),std(hamming_result));

    current_prec = mean(prec_result);
    if current_prec > best_prec
        best_prec = current_prec;

        best_score.cvg = mean(cvg_result);
        best_score.avgpre = mean(prec_result);
        best_score.rankloss = mean(rank_result);
        best_score.oneerror = mean(oneerror_result);
        best_score.hamming = mean(hamming_result);

        best_params.lambda = lambda;
        best_params.alpha = alpha;
        best_params.beta = beta;
    end
end

%disp(norm(P,1));
%disp(nnz(P));

% disp('Best Parameters:');
% disp(best_params);
% disp('Best Score:');
% disp(best_score);
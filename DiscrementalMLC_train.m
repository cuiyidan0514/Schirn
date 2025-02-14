function [W1,P] =DiscrementalMLC_train(Xtrain, candidate_labels, lambda, alpha, beta)
[n, c]=size(candidate_labels); % m是标签个数
[~, q]=size(Xtrain);

% 6 parameters to be optimized
P = zeros(size(candidate_labels)); %噪声标签矩阵
W1 = ones(q, c); %权重矩阵W
C = ones(size(candidate_labels)); %C
phi = ones(size(candidate_labels)); %Φ
rho = 1e-4; %ρ

M = Xtrain' * Xtrain;
iteration = 0;

diffs = zeros(100,1);
losses = zeros(100,1);

while iteration < 100
    % optimize W1
    Wpre = W1;
    W1 = (2*beta*eye(q)+rho*M) \ (rho*Xtrain'*C-Xtrain'*phi);
    %W1 = (Xtrain'*Xtrain+beta*eye(q)) \ (Xtrain'*(candidate_labels-P));

    % optimize P: noisy labels
    P = optimizeP(alpha, candidate_labels, C);
    %P = optimizeP(alpha, candidate_labels, Xtrain*W1); %high-rank only

    % optimize C
    C = optimizeC(Xtrain, candidate_labels, phi, rho, P, W1, lambda);

    % optimize phi
    phi = phi + rho*(Xtrain*W1-C);

    % optimize rho
    rho = 1.1*rho;
    rho = min(rho,10);
    
    iteration = iteration + 1; 

    diff = norm(W1-Wpre,'fro');
    diffs(iteration) = diff;

    % A = Xtrain*W1;
    % [U,S,V] = svd(A);
    % 
    % loss = norm(Xtrain*W1-(candidate_labels-P),'fro')^2 - lambda * norm(diag(S),1) + alpha * norm(P,1) + beta * norm(W1,'fro')^2;
    % loss1 = norm(Xtrain*W1-(candidate_labels-P),'fro')^2;
    % loss2 = - lambda * norm(diag(S),1) + alpha * norm(P,1);
    % loss3 = beta * norm(W1,'fro')^2;
    % losses(iteration) = loss;
end
% disp(loss);
% disp(loss1);
% disp(loss2);
% disp(loss3);
writecell(num2cell(diffs(1:iteration)),'cvg_music_style.xlsx');
end


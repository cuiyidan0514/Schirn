function [P, cvg_result, prec_result, rank_result, auc_result, oneerror_result, hamming_result, avgauroc_result, top1_result, top3_result, top5_result] = run_arts(r, samples, generate_dataset, lambda, alpha, beta)

if generate_dataset
    features = double(samples.data);
    labels = double(samples.target); % 6139*39
    %candidate_labels = double(samples.candidate_labels'); % 6139*39
else
    % emotions
    data=double(samples.data);
    target=double(samples.target');
    target(target < 1) = 0;
end

n=size(data, 1); % 样本数
ntrain=floor(0.8*n); % 用来训练的样本数
ntest = ceil(0.2*n);

indice = 1:n;

cvg_result = [];
prec_result = [];
rank_result = [];
auc_result = [];
oneerror_result = [];
top1_result = [];
top3_result = [];
top5_result = [];
avgauroc_result = [];
hamming_result = [];

rank_list = [];

    for r=r % 对于不同的missing rate进行训练
        if generate_dataset
            % 如果要生成偏标签数据集
            %mask = genObv(labels, candidate_labels, r); % mask=1,noisy labels; else mask=0
            mask = genObv_syn(labels, r);
            I = ones(size(labels));
            %candidate_labels = candidate_labels + mask .* (I - candidate_labels); % 生成的偏标签矩阵，即observed label matrix
            candidate_labels = labels + mask .* (I - labels);
            rank_list = [rank_list;r,rank(tt)];
            save('chess_40.mat', 'features', 'labels','candidate_labels');
        else
            % 直接使用生成好的偏标签数据集
            candidate_labels = double(samples.candidate_labels');
            candidate_labels(candidate_labels < 1) = 0;
            % disp('gt label matrix:');
            % disp(rank(target));
            % disp('observed label matrix:');
            % disp(rank(candidate_labels));
        end
    % end
    % r_values = rank_list(:, 1);  
    % rank_values = rank_list(:, 2);  
    % 
    % figure;  
    % plot(r_values, rank_values, '-o'); % '-o' adds markers to the line  
    % xlabel('noisy label num');  
    % ylabel('Rank of candidate label matrix');  
    % title('');  
    % grid on;

         for kk = 54 % 5折，每折用同一个随机数种子
             %% 随机将数据集划分为训练集和测试集
             s = RandStream.create('mt19937ar','seed',kk);
             RandStream.setGlobalStream(s);
             ind=randperm(n); % ind是对n个数进行了乱序排列
             %disp(kk);
 
             Xtrn = data(ind(1:ntrain), :);
             Xtst = data(ind(ntrain+1:end), :);
             candidate_labels_train = candidate_labels(ind(1:ntrain),:);
             candidate_labels_test = candidate_labels(ind(ntrain+1:end),:);
             % disp('test observed matrix:');
             % disp(rank(candidate_labels_test));
             Ytst = target(ind(ntrain+1:end),:);
 
             [W,P] = DiscrementalMLC_train(Xtrn, candidate_labels_train, lambda, alpha, beta); % 通过最小化目标函数，得到最优的W   
 
             %% 对测试集的数据预处理
             zz = mean(Ytst,2); % 129*1
             if ~isempty(zz)
                 Ytst(zz==0,:) = []; %129*19
                 Xtst(zz==0,:) = []; %129*260
             end
             %% 评估模型在测试集上的效果
             tstv = Xtst*W;
             tstv=tstv'; % 模型输出
             Ytst=Ytst'; % 测试集的真实样本
             [Cvg, AvgPrec, RkL, Top1, Top3, Top5, AvgAuc, oneerror, hamming_loss, ave_auroc] =  evalt(tstv, Ytst); % 在测试集上评估W的性能
             cvg_result = [cvg_result,Cvg];
             prec_result = [prec_result,AvgPrec];
             rank_result = [rank_result,RkL];
             auc_result = [auc_result,AvgAuc];
             oneerror_result = [oneerror_result,oneerror];
             top1_result = [top1_result,Top1];
             top3_result = [top3_result,Top3];
             top5_result = [top5_result,Top5];
             avgauroc_result = [avgauroc_result,ave_auroc];
             hamming_result = [hamming_result,hamming_loss];
         end
    end

    % P_gt = candidate_labels - target;
    % disp(norm(P_gt,1));

 end

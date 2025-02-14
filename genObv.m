function mask = genObv( train_target, candidate_labels, r )
% mask is a mask where 1 indicates the corresponding index is candidate labels 
     
     mask = zeros(size(candidate_labels));
     s = RandStream.create('mt19937ar','seed', r);
     RandStream.setGlobalStream(s);
     
     num_pos = 0;
     num_can = 0;
     [n,~] = size(candidate_labels);
     for i=1:n
         y1 = train_target(i,:);
         pos1 = find(y1==1);
         num_pos = num_pos + length(pos1); %gt num
         mask(i,pos1) = 1; % 正样本在mask中为1
         neg = find(y1~=1);
         pi = randperm(length(neg)); % 找到所有为0的标签序号，并将其顺序打乱
         pi = pi(1:r); % 从里面挑出一定比例的序号
         mask(i,neg(pi)) = 1; % 将这些挑出来的序号在mask中的位置改为1
         num_can = num_can + length(pos1) + r;
     end
     disp(num_can / n);
     disp(num_pos / n);
end


function mask = genObv_syn( train_target, r )
% mask is a mask where 1 indicates the corresponding index is candidate labels 
     
     mask = zeros(size(train_target));
     s = RandStream.create('mt19937ar','seed', r);
     RandStream.setGlobalStream(s);
     
     num_can = 0;
     [n,~] = size(train_target);
     for i=1:n
         y1 = train_target(i,:);
         pos = find(y1==1);
         mask(i,pos) = 1; % 正样本在mask中为1
         neg = find(y1~=1);
         pi = randperm(length(neg)); % 找到所有为0的标签序号，并将其顺序打乱
         pi = pi(1:r); % 从里面挑出一定比例的序号
         mask(i,neg(pi)) = 1; % 将这些挑出来的序号在mask中的位置改为1
         num_can = num_can + length(pos) + r;
     end
     %disp(num_can / n);
end


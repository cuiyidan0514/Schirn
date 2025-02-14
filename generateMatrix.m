function modifiedMatrix  = generateMatrix(inputMatrix,p)  
    % 计算每列中1的个数  
    columnSums = sum(inputMatrix, 1); % 每列的1的个数  
    
    % 找到1最少的列的索引  
    [~, minIndex] = min(columnSums);  
    
    % 获取该列中的1的行索引  
    rowsWithOnes = find(inputMatrix(:, minIndex) == 1);  
    
    % 计算需要变为0的1的数量  
    numOnesToTurnZero = floor(length(rowsWithOnes) * p); 
    disp(numOnesToTurnZero);
    
    % 如果该列中没有1，直接返回输入矩阵  
    if numOnesToTurnZero == 0  
        modifiedMatrix = inputMatrix;  
        return;  
    end  

    % 随机选择numOnesToTurnZero个1的索引进行变更  
    randomIndices = randperm(length(rowsWithOnes), numOnesToTurnZero);  
    rowsToModify = rowsWithOnes(randomIndices);  
    
    % 将选中的1变为0  
    inputMatrix(rowsToModify, minIndex) = 0;  

    % 返回修改后的矩阵  
    modifiedMatrix = inputMatrix; 
end 

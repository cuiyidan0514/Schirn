data1 = load('medical-test.mat');
data2 = load("medical-train.mat");

data = [data1.data; data2.data];
target = [data1.target; data2.target];

save('medical.mat',"data","target");
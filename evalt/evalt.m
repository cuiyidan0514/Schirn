function [ Cvg, AvgPrec, RkL, Top1, Top3, Top5, AvgAuc, oneerror, Hamming, ave_auroc] = evalt(Fpred,Ygnd)

Ypred = sign(Fpred-0.8);
Ypred((Ypred<0)) = 0;
%disp(rank(Ypred));
%disp(rank(Ygnd));

mypred = sign(Fpred-0.5);
mypred((mypred<0)) = 0;
% disp('test label matrix:')
% disp(rank(mypred));
% disp('test gt matrix:')
% disp(rank(Ygnd));

%% Coverage
Cvg = coverage(Fpred,Ygnd);
%disp(['Coverage: ',num2str(Cvg)]);
Result.Coverage = Cvg;

%% Average Precision
AvgPrec = Average_precision(Fpred,Ygnd);
% disp(['Average Precision: ',num2str(AvgPrec)]);
Result.AveragePrecision = AvgPrec;

%% Ranking Loss
RkL = Ranking_loss(Fpred,Ygnd);
% disp(['Ranking Loss: ',num2str(RkL)]);
Result.RankingLoss = RkL;

%% TopRate
Top1 = topRate(Fpred',Ygnd',1);
Top3 = topRate(Fpred',Ygnd',3);
Top5 = topRate(Fpred',Ygnd',5);
%disp(['TopRate1: ',num2str(Top1)]);
%disp(['TopRate3: ',num2str(Top3)]);
%disp(['TopRate5: ',num2str(Top5)]);

%% AvgAuc
AvgAuc = avgauc(Fpred,Ygnd);
Result.AvgAuc = AvgAuc;
%disp(['AvgAuc: ',num2str(AvgAuc)]);

%% Hamming Loss
Hamming = Hamming_loss(Ypred,Ygnd);
Result.Hamming=Hamming;
%disp(['Hamming Loss: ',num2str(Hamming)]);

%% OneError
oneerror = One_error(Fpred,Ygnd);
Result.oneerror=oneerror;
%disp(['OneError Loss: ',num2str(oneerror)]);

%% Ave_AUROC
ave_auroc = Ave_AUROC(Ypred,Ygnd);
Result.ave_auroc=ave_auroc;
%disp(['Ave_AUROC Loss: ',num2str(ave_auroc)]);

%if Cvg < 0.3
    disp(['Average Precision: ',num2str(AvgPrec)]);
    disp(['OneError Loss: ',num2str(oneerror)]);
    disp(['Ranking Loss: ',num2str(RkL)]);
    disp(['Coverage: ',num2str(Cvg)]);
    disp(['Hamming Loss: ',num2str(Hamming)]);
end



function[fvalue]=objvalue(Xtrain,candidate_labels,X,J,P,lambda,Wtplus1,Wtplus2,gamma,alpha,beta)
[d, m] = size(Wtplus1);
% Function value (residual)
non_can = ones(size(candidate_labels)) - candidate_labels;
term1 = norm(J .* (Xtrain*Wtplus1+P-candidate_labels),'fro')^2;
term2 = norm(J .* (Xtrain*Wtplus2-P-non_can),'fro')^2;
term3 = gamma * norm(Xtrain*Wtplus1+Xtrain*Wtplus2-ones(size(candidate_labels)),'fro')^2;

Sabs=0;
for i=1:m
  S=svd(X{i}*Wtplus1, 'econ');
  Sabs=Sabs+sum(abs(S));
end
term4=lambda*Sabs;

S1=svd(Xtrain*Wtplus1, 'econ');
term5=lambda*sum(abs(S1));

P(P<0)=0;
P(P>=0)=1;
term6 = alpha * norm(P,1); 

term7 = beta * (norm(Wtplus1,'fro')^2 + norm(Wtplus2,'fro')^2);

fvalue = term1+term2+term3+term4-term5+term6+term7;


end
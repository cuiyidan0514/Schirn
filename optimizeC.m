function C = optimizeC(Xtrain, candidate_labels, phi, rho, P, W1, lambda)

omega = 1+0.5*rho;
t = (2*candidate_labels-2*P+phi+rho*Xtrain*W1) / (2*omega);
[U,S,V] = svd(t);
S1 = S+lambda/omega;
S1(S1<0) = 0;
C = U*S1*V';

end
% FGLS regression example

clear;
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Lecture/Lecture 4/lecture example/example.mat';
y = unaid;
N = length(y);
X = [ones(N,1) dur ncb rank year];
lss = examplefunctionlss(y,X);
e_hat = lss.u_hat;
e_hat_sq_log = log(e_hat.^2);
X = [ones(N,1) dur ncb rank year];
lss_hk = examplefunctionlss(e_hat_sq_log,X);
O = diag(exp(lss_hk.y_hat));
OI = inv(O);
P = chol(OI,'lower');
y_t = P'*y;
X_t = P'*X;
lss_fgls = examplefunctionlss(y_t,X_t);
B_hat_fgls = lss_fgls.B_hat;

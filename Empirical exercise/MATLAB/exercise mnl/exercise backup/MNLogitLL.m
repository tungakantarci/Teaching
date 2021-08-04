function LL = MNLogitLL(Beta,y,X)

N = size(X,1);
K = size(X,2);
J = size(Beta,1)/K+1;

Beta = reshape(Beta,K,J-1);

expxb = exp(X * Beta);
expxb_augmented = [expxb,ones(N,1)];

MyIndex = NaN(N,J);

for count = 1:J
    MyIndex(:,count) = (y == count);
end

ll_i = log(sum(expxb_augmented .* MyIndex,2) ./ sum(expxb_augmented,2));

LL = -sum(ll_i);

return
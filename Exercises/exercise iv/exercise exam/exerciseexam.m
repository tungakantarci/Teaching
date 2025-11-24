% Exam question - Endogeneity test

% Import raw data file
clear;
filename = '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical Exercise/MATLAB/exercise iv/exercise data/exam.csv';
delimiterIn = ',';
headerlinesIn = 1;
matfile = importdata(filename,delimiterIn,headerlinesIn);
[N,k] = size(matfile.data);
for i = 1:k
    eval([cell2mat(matfile.textdata(i)) '= matfile.data(:,i);'])
end

% Testing the endogeneity of cigarprice 
x_0 = ones(N,1);
y = wage;
X = [x_0 educ age black]; 
S071 = exercisefunctiontwo(y,X);
Z = [x_0 fatheduc motheduc age black];
S072 = exercisefunctionone(y,X,Z);
B = S071.B_hat(2,1); 
b = S072.B_hat_st(2,1);
B_hat_VCE = S071.B_hat_VCE(2,2); % S071.B_hat_VCE_robust(2,2) could be used. 
b_hat_VCE = S072.B_hat_VCE_st(2,2); % S072.B_hat_VCE_robust_st(2,2) could be used. 
H_s = (b-B)*inv(b_hat_VCE-B_hat_VCE)*(b-B); % H_s = ((b-B)/(b_hat_VCE-B_hat_VCE))*(b-B) could be used. 
H_p = chi2cdf(H_s,1,'upper');

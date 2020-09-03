% Empirical exercise - The two-stage least squares estimator 

%% 1. Aim of the exercise
% To learn to tackle endogeneity using the instrumental variable method. 

%% 2. Load the data
clear;
% load 'M:\exercisetsls.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise iv/exercise mat/exercisetsls.mat';
N = size(cigarprice,1);
x_0 = ones(N,1);

%% 3. Produce descriptive statistics
A = [cigarcons cigarprice cigartax];
[R1,P1] = corrcoef(A);

%% 4. An endogenous variable and an instrumental variable
y = cigarcons;
X = [x_0 cigarprice]; 
Z = [x_0 cigartax];
S041 = exercisefunctiontslsrobust(y,X,Z);

%% 5. The forbidden regression 
y = cigarprice;
X = [x_0 cigartax]; 
S051 = exercisefunctionlssrobust(y,X);
y = cigarcons;
X = [x_0 S051.y_hat]; 
S052 = exercisefunctionlssrobust(y,X);

%% 6. Testing the relevance of the instrument 
y = cigarprice;
X = [x_0 cigartax]; 
S061 = exercisefunctionlssrobust(y,X);

%% 7. Testing the exogeneity of the instrument, and failing to do so 
y = cigarcons;
X = [x_0 cigarprice]; 
Z = [x_0 cigartax];
S071 = exercisefunctiontslsrobust(y,X,Z);
y = S071.u_hat_st;
X = [x_0 cigartax]; 
S072 = exercisefunctionlssrobust(y,X);

%% 8. Testing the endogeneity of cigarprice 
% Test one
y = cigarcons;
X = [x_0 cigarprice]; 
S081 = exercisefunctionlssrobust(y,X);
y = cigarcons;
X = [x_0 cigarprice]; 
Z = [x_0 cigartax];
S082 = exercisefunctiontslsrobust(y,X,Z);
B = S081.B_hat; 
b = S082.B_hat_st;
B_hat_VCE = S081.B_hat_VCE_robust;
b_hat_VCE = S082.B_hat_VCE_robust_st;
H_s = (b-B)'*inv(b_hat_VCE-B_hat_VCE)*(b-B);
H_p = chi2cdf(H_s,1,'upper');
% Test two
y = cigarprice;
X = [x_0 cigartax]; 
S083 = exercisefunctionlssrobust(y,X);
y = cigarcons;
X = [x_0 cigarprice S083.u_hat]; 
S084 = exercisefunctionlssrobust(y,X);
e = 0.00000001;
a = abs(S082.B_hat_st(1,1)-S084.B_hat(1,1)) <= e;
b = abs(S082.B_hat_st(2,1)-S084.B_hat(2,1)) <= e;

%% 9. Augment the instrumental variable regression with an exogenous variable 
income = income/1000000;
[R2,P2] = corrcoef(cigartax,income); 
y = cigarcons;
X = [x_0 cigarprice income]; 
Z = [x_0 cigartax income];
S091 = exercisefunctiontslsrobust(y,X,Z);

%% 10. An endogenous variable and two instrumental variables
y = cigarcons;
X = [x_0 cigarprice income]; 
Z = [x_0 cigartax cigartaxspecific income];
S101 = exercisefunctiontslsrobust(y,X,Z);

%% 11. Testing the relevance of the two instruments 
y = cigarprice;
X = [x_0 cigartax cigartaxspecific income]; 
S111 = exercisefunctionlssrobust(y,X);
y = cigarprice;
X = [x_0 income]; 
S112 = exercisefunctionlssrobust(y,X);
F_s = ((S112.RSS-S111.RSS)/2)/(S111.RSS/(N-4));
F_p = fcdf(2,N-4,F_s,'upper'); 

%% 12. Testing the exogeneity of the two instruments 
y = cigarcons;
X = [x_0 cigarprice income]; 
Z = [x_0 cigartax cigartaxspecific income];
S121 = exercisefunctiontslsrobust(y,X,Z);
y = S121.u_hat_st;
X = [x_0 cigartax cigartaxspecific income]; 
S122 = exercisefunctionlssrobust(y,X);
overid_s = N*S122.R2_c; 
overid_p = chi2cdf(overid_s,1,'upper');

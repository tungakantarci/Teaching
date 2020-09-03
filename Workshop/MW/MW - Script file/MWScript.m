% MATLAB Workshop - Script File

% -------------------------------------------------------------------------
% 1. Program Window
% -------------------------------------------------------------------------
a = 1;
edit untitled;

% -------------------------------------------------------------------------
% 2. Interacting with MATLAB
% -------------------------------------------------------------------------
a = 2;

% -------------------------------------------------------------------------
% 3. Creating a Script File
% -------------------------------------------------------------------------
cd 'M:\' 
edit scriptfile

% -------------------------------------------------------------------------
% 4. Program Syntax
% -------------------------------------------------------------------------
clear
5+5
a = 5+5
b = a+1
round(pi,3)
round(pi,3);

% -------------------------------------------------------------------------
% 5. Creating, Indexing, and Searching Arrays   
% -------------------------------------------------------------------------
c = [2 7 5 1 8 9 0 1 1]'
c(2,1)
c(1:3,:)
c = 0:2:10
c = [2 7 5 1 8 9 0 1 1]'
[row,col,v] = find(c(:,:) == 1,2,'first');

% -------------------------------------------------------------------------
% 6. Commenting, Breaking, and Masking Syntax in a Script File
% -------------------------------------------------------------------------
% You can add a line of comment.
a = 5+5; % You can annotate code.
% You can split a line of code across multiple lines. E.g.:
a = ... 
    5+5;
% You can mask multiple lines of code. E.g.:
%{
a = 5+5;
b = a+1;
%}
% You can mask a single line of code. E.g.:
% a = 5+5;

% -------------------------------------------------------------------------
% 7. Importing Raw Data Files
% -------------------------------------------------------------------------
clear;
filename = 'M:\MW - csv file.csv';
delimiterIn = ',';
headerlinesIn = 1;
mwmatfile = importdata(filename,delimiterIn,headerlinesIn);
save('M:\MW - mat file','mwmatfile');

% -------------------------------------------------------------------------
% 8. Opening Data Files
% -------------------------------------------------------------------------
clear;
load 'M:\MW - mat file.mat';

% -------------------------------------------------------------------------
% 9. Browsing the Data
% -------------------------------------------------------------------------
mwmatfile.data(1:20,:);
mwmatfile.data(:,1);
unique(mwmatfile.data(:,4));
mwmatfile.data(mwmatfile.data(:,4) == 1,[1 2 4]);
sortrows(mwmatfile.data,[2 -1]);
mwmatfile.data = sortrows(mwmatfile.data,[2 -1]);
[N,k] = size(mwmatfile.data);

% -------------------------------------------------------------------------
% 10. Producing Descriptive Statistics
% -------------------------------------------------------------------------
mean(mwmatfile.data,1);
mean(mwmatfile.data(mwmatfile.data(:,4) == 1,1));
tabulate(mwmatfile.data(:,2))
[r,p] = corrcoef(mwmatfile.data(:,1),mwmatfile.data(:,3));
mean(mwmatfile.data,1,'omitnan');
sum(isnan(mwmatfile.data(:,2)));

% -------------------------------------------------------------------------
% 11. Creating Variables 
% -------------------------------------------------------------------------
wage = mwmatfile.data(:,1);
wage+1;
-wage;
wage.^2;
wage(:) >= 20 & wage(:) <= 40;
log(wage);
exp(wage);

% -------------------------------------------------------------------------
% 12. Manipulating Variables 
% -------------------------------------------------------------------------
clearvars -except N k mwmatfile;
mwmatfile.data(:,6) = [];
mwmatfile.data(isnan(mwmatfile.data(:,2)),:) = [];
mwmatfile.data(mwmatfile.data(:,1) > 30,1) = NaN;

% -------------------------------------------------------------------------
% 13. Data Types
% -------------------------------------------------------------------------
doc Fundamental MATLAB Classes
isnumeric(mwmatfile.data)
iscellstr(mwmatfile.textdata)

% -------------------------------------------------------------------------
% 14. Scalar vs Vector Oriented Coding 
% -------------------------------------------------------------------------
% Scalar-oriented coding
uniq = unique(mwmatfile.data(:,2));
for i = uniq'
    mwmatfile.data(find(mwmatfile.data(:,2) == i,1,'first'),:) = [];
end
% Vector-oriented coding 
uniq = unique(mwmatfile.data(:,2));
[~,tag] = ismember(uniq,mwmatfile.data(:,2));
mwmatfile.data(tag',:) = [];

% -------------------------------------------------------------------------
% 15. Efficient calculation in MATLAB
% -------------------------------------------------------------------------
A = [1 2 3; 4 5 6; 7 8 9];
square_matrix = repmat(A,200); 
tic
efficientnot = square_matrix*eye(600); 
toc
tic
efficientyes = square_matrix*speye(600); 
toc

% -------------------------------------------------------------------------
% 16. Assign Names tp Vector Arrays
% -------------------------------------------------------------------------
clear;
load 'M:\MW - mat file.mat';
mwmatfile.data(isnan(mwmatfile.data(:,2)),:) = [];
[N,k] = size(mwmatfile.data);
for i = 1:k
    eval([cell2mat(mwmatfile.textdata(i)) '= mwmatfile.data(:,i);'])
end

% -------------------------------------------------------------------------
% 17. Regression Analysis Using Matrix Algebra
% -------------------------------------------------------------------------
y = wage;
x_0 = ones(N,1);
X = [x_0 educ exper];
B_hat_OLS = (X'*X)\X'*y;
B_hat_OLS = inv(X'*X)*X'*y;

% -------------------------------------------------------------------------
% 18. Creating Graphs 
% -------------------------------------------------------------------------
scatter3(educ,exper,wage,'filled')
hold on
educfit = min(educ):1:max(educ);
experfit = min(exper):1:max(exper);
[educFIT,experFIT] = meshgrid(educfit,experfit);
wageFIT = B_hat(1) + B_hat(2)*educFIT + B_hat(3)*experFIT;
mesh(educFIT,experFIT,wageFIT)
xlabel('educ')
ylabel('exper')
zlabel('wage')
view(-40,15)

% -------------------------------------------------------------------------
% 19. Working with a Custom-built Function
% -------------------------------------------------------------------------
LSS = MWFunctionLSS(y,X);
LSS.B_hat_OLS(2);
lrm = fitlm(X,y,'Intercept',false)

% -------------------------------------------------------------------------
% 20. The Optimisation Problem of an Econometrician
% -------------------------------------------------------------------------
B_ig = [1 1 1]';
options = optimset('GradObj','on','MaxFunEvals',100,'MaxIter',100, ...
    'Display','iter');
[B_hat_Section_20,SSR,exitflag,output,GradObj,hessian] = ...
    fminunc(@(B_true)MWFunctionSSR(y,X,B_true),B_ig,options);

% -------------------------------------------------------------------------
% 21. The Optimisation Problem of an Agent 
% -------------------------------------------------------------------------
X_ig = [15,5];
P = [4,7];
I = 100;
lb = [0,0];
[X_optimal,CDU,exitflag] = fmincon(@MWFunctionCDU,X_ig,P,I,[],[],lb);

% -------------------------------------------------------------------------
% 22. Debugging Program Code
% -------------------------------------------------------------------------
clear;
load 'M:\MW - mat file.mat';
uniq = unique(mwmatfile.data(:,2));
for i = uniq'
    mwmatfile.data(find(mwmatfile.data(:,7) == i,1,'first'),:) = [];
end

% -------------------------------------------------------------------------
% 23. Help System
% -------------------------------------------------------------------------
doc descriptive statistics
doc mean
help mean

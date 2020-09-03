% Exercise - Heteroskedasticity

% 1. Load the data
clear;
% load 'C:\Users\username\Desktop\exercise part one.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise hetero/exercise data/exercise part one.mat'
mwmatfile.data(isnan(mwmatfile.data(:,2)),:) = [];
[N,k] = size(mwmatfile.data);
wage = mwmatfile.data(:,1); 
educ = mwmatfile.data(:,2); 

% 2. Create the systematic component of the regression equation 
y = wage;
x_0 = ones(N,1);
X = [x_0 educ];
B_hat = (X'*X)\X'*y;

% 3. Obtain the fitted dependent variable and the fitted errors 
wageFIT = B_hat(1)+B_hat(2)*educ; 
residuals = wage-X*B_hat
  
% 4. Plot the scatter diagram and the fitted regression line
scatter(educ,wage,'filled')
hold on
plot(educ,wageFIT)
xlabel('Education')
ylabel('Wage')
title('Plot of wage against education overlayed with the fitted regression line')
hold off

% 5. Plot the scatter plot of the residuals against the independent variable 
scatter(educ,residuals,'filled')
hold on
plot(educ,ones(N,1)*mean(residuals))
xlabel('Education')
ylabel('Residuals')
title('Plot of residuals against education')

% -------------------------------------------------------------------------
% TTest(TAIL, NU, ALPHA, TSTAT) conducts the t-test. 
% 
% TAIL is the type of the hypothesis test. Possible types are:
%  - 'LeftTailed' for a left-tailed t-test
%  - 'RightTailed' for a right-tailed t-test
%  - 'TwoTailed' for a two-tailed t-test
%
% NU is the degrees of freedom. It must be a positive integer.
%
% ALPHA is the significance level. It must be a real number between 
% 0 and 1 (exclusive).
%
% TSTAT is the value of the t-statistic. It can take any finite 
% value. TSTAT is optional. If provided, the function will plot the 
% value of the t-statistic and indicate whether the null hypothesis 
% can be rejected.
% 
% The size of the plot can be customized by changing the values of 
% TTRT.scale, TTLT.scale, TTTT.scale in their corresponding function 
% files.
% -------------------------------------------------------------------------
TTest('TwoTailed',35,0.05,2.7)
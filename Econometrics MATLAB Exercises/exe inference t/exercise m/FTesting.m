% -------------------------------------------------------------------------
% FTest(TAIL, NU1, NU2, ALPHA, FSTAT) conducts the F-test.
%
% TAIL is the type of the hypothesis test. Possible types are:
%  - 'LeftTailed' for a left-tailed F-test
%  - 'RightTailed' for a right-tailed F-test
%  - 'TwoTailed' for a two-tailed F-test
%
% NU1 and NU2 are the degrees of freedom. They must be positive integers.
%
% ALPHA is the significance level. It must be a real number between 
% 0 and 1 (exclusive).
%
% FSTAT is the value of the F-statistic. It can take any finite 
% value. FSTAT is optional. If provided, the function will plot the 
% value of the F-statistic and indicate whether the null hypothesis 
% can be rejected.
% 
% The size of the plot can be customized by changing the values of 
% FTRT.scale, FTLT.scale, FTTT.scale in their corresponding function 
% files.
% -------------------------------------------------------------------------
 FTest('RightTailed',35,20,0.05,1.8)
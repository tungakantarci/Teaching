% -------------------------------------------------------------------------
% CsTest(TAIL, NU, ALPHA, CSSTAT) conducts the Chi-square test.
%
% TAIL is the type of the hypothesis test. Possible types are:
%  - 'LeftTailed' for a left-tailed Chi-square test
%  - 'RightTailed' for a right-tailed Chi-square test
%  - 'TwoTailed' for a two-tailed Chi-square test
%
% NU is the degrees of freedom. It must be a positive integer.
%
% ALPHA is the significance level. It must be a real number between 
% 0 and 1 (exclusive).
%
% CSTAT is the value of the Chi-square test statistic. It can take any 
% finite value. CSTAT is optional. If provided, the function will plot 
% the value of the Chi-square statistic and indicate whether the null 
% hypothesis can be rejected.
% 
% The size of the plot can be customized by changing the values of
% CsTRT.scale, CsTLT.scale, CsTTT.scale in their corresponding function
% files.
% -------------------------------------------------------------------------
CsTest('RightTailed',35,0.05,41.7)
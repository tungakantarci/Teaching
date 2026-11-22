function FT = FTest(tail, nu1, nu2, alpha, fstat)
%FTEST Visualize the F-test.
%   FTest(TAIL, NU1, NU2, ALPHA, FSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. Depending on the
%   input argument for TAIL, it calculates one or two critical values
%   corresponding to a one or two tailed F-test with NU1 and NU2 degrees of
%   freedom at an ALPHA level of significance and plots the related
%   rejection region(s). A vertical line representing the manually
%   calculated F-test statistic valued FSTAT will be plotted as well, this
%   input argument is optional. TAIL can be: 'LeftTailed', 'RightTailed',
%   and 'TwoTailed'.

% -------------------------------------------------------------------------
% Check if the user does not want to plot the test statistic, which happens
% when the number of input arguments is equal to four.
% -------------------------------------------------------------------------
if (nargin == 4)
    switch(tail)
        case "RightTailed"
            FTestRightTailed(nu1,nu2,alpha);
        case "LeftTailed"
            FTestLeftTailed(nu1,nu2,alpha);
        case "TwoTailed"
            FTestTwoTailed(nu1,nu2,alpha);
        otherwise
            uiwait(warndlg(['Please specify the correct tail, right, ' ...
                'left or two tailed.']))
            return
    end
else
    switch(tail)
        case "RightTailed"
            FTestRightTailed(nu1,nu2,alpha,fstat);
        case "LeftTailed"
            FTestLeftTailed(nu1,nu2,alpha,fstat);
        case "TwoTailed"
            FTestTwoTailed(nu1,nu2,alpha,fstat);
        otherwise
            uiwait(warndlg(['Please specify the correct tail, right, ' ...
                'left or two tailed.']))
            return
    end
end
function TT = TTest(tail, nu, alpha, tstat)
%TTEST Visualize the Student's t-test.
%   TTest(TAIL, NU, ALPHA, TSTAT) plots the theoretical Student's
%   t-distribution with NU degrees of freedom. Depending on the input
%   argument for TAIL, it calculates one or two critical values
%   corresponding to a one or two tailed t-test with NU degrees of freedom
%   at an ALPHA level of significance and plots the related rejection
%   region(s). A vertical line representing the manually calculated test
%   statistic valued TSTAT will be plotted as well, but this input argument
%   is optional. TAIL can be: 'LeftTailed', 'RightTailed', and 'TwoTailed'.

% -------------------------------------------------------------------------
% Check if the user does not want to plot the test statistic, which happens
% when the number of input arguments is equal to three.
% -------------------------------------------------------------------------
if (nargin == 3)
    switch(tail)
        case "RightTailed"
            TTestRightTailed(nu,alpha);
        case "LeftTailed"
            TTestLeftTailed(nu,alpha);
        case "TwoTailed"
            TTestTwoTailed(nu,alpha);
        otherwise
            uiwait(warndlg(['Please specify the correct tail, right, ' ...
                'left or two tailed.']))
            return
    end
else
    switch(tail)
        case "RightTailed"
            TTestRightTailed(nu,alpha,tstat);
        case "LeftTailed"
            TTestLeftTailed(nu,alpha,tstat);
        case "TwoTailed"
            TTestTwoTailed(nu,alpha,tstat);
        otherwise
            uiwait(warndlg(['Please specify the correct tail, right,' ...
                'left or two tailed.']))
            return
    end
end
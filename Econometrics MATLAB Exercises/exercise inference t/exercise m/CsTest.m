function CsT = CsTest(tail,nu,alpha,csstat)
%CsTEST Visualize a Chi-square test.
%   CsTest(TAIL, NU, ALPHA, CSSTAT) plots the theoretical Chi-squared
%   distribution with NU degrees of freedom. Depending on the input
%   argument for TAIL, it calculates one or two critical values
%   corresponding to a one or two tailed Chi-squared test with NU degrees
%   of freedom at an ALPHA level of significance and plots the related
%   rejection region(s). A vertical line representing the manually
%   calculated Chi-squared test statistic valued CSSTAT will be plotted as
%   well, this input argument is optional. TAIL can be: 'LeftTailed',
%   'RightTailed', and 'TwoTailed'.

% -------------------------------------------------------------------------
% Check if the user does not want to plot the test statistic, which happens
% when the number of input arguments is equal to three.
% -------------------------------------------------------------------------
if (nargin == 3)
    switch(tail)
        case "RightTailed"
            CsTestRightTailed(nu,alpha);
        case "LeftTailed"
            CsTestLeftTailed(nu,alpha);
        case "TwoTailed"
            CsTestTwoTailed(nu,alpha);
        otherwise
            uiwait(warndlg(['Please specify the correct tail,right,' ...
                'left or two tailed.']))
            return
    end
else
    switch(tail)
        case "RightTailed"
            CsTestRightTailed(nu,alpha,csstat);
        case "LeftTailed"
            CsTestLeftTailed(nu,alpha,csstat);
        case "TwoTailed"
            CsTestTwoTailed(nu,alpha,csstat);
        otherwise
            uiwait(warndlg(['Please specify the correct tail,right,' ...
                'left or two tailed.']))
            return
    end
end

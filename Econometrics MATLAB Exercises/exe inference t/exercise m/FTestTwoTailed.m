function FTTT = FTestTwoTailed(nu1, nu2, alpha, fstat)
%FTESTTWOTAILED Visualize the two-tailed F-test.
%   FTTT = FTestTwoTailed(NU1, NU2, ALPHA, FSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. It calculates the
%   two critical values corresponding to a two tailed F-test with NU1 and
%   NU2 degrees of freedom at an ALPHA level of significance and plots the
%   related rejection regions. A vertical line representing the manually
%   calculated F-test statistic valued FSTAT will be plotted, this input
%   argument is optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu1 <= 0)
    uiwait(warndlg(['The degrees of freedom of the first population' ...
        ' should be larger than zero.']));
    return
elseif (nu2 <= 0)
    uiwait(warndlg(['The degrees of freedom of the second population' ...
        ' should be larger than zero.']));
    return
elseif (mod(nu1, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of' ...
        ' freedom of the first population.']));
    return
elseif (mod(nu2, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of' ...
        ' freedom of the second population.']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and' ...
        ' one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the F-test statistic and make sure that
% the F-test statistic is nonnegative valued.
% -------------------------------------------------------------------------
if (nargin == 4)
    if (fstat < 0)
        uiwait(warndlg(['The test statistic cannot be negative valued,' ...
            ' please make sure that the test statistic is correctly' ...
            ' calculated.']));
        return
    end
    FTTT.Display = 1;
else 
    FTTT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical values.
% -------------------------------------------------------------------------
FTTT.CVleft = icdf('F',alpha/2,nu1,nu2);
FTTT.CVright = icdf('F',1-alpha/2,nu1,nu2);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical values as having only one or two degrees of freedom can result
% in large critical value. This has been done by setting the right end
% value of the interval to the value of the 99.99th percentile observation.
% -------------------------------------------------------------------------
FTTT.xmin = 0;
FTTT.xmax = icdf('F',0.9999,nu1,nu2);
FTTT.x = FTTT.xmin:0.01:FTTT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
FTTT.y = pdf('F',FTTT.x,nu1,nu2);

% -------------------------------------------------------------------------
% Calculating the rejection regions, as these areas need to be shown in the
% plot.
% -------------------------------------------------------------------------
FTTT.xleft = FTTT.xmin:0.001:FTTT.CVleft;
FTTT.xright = FTTT.CVright:0.001:FTTT.xmax;
FTTT.yleft = pdf('F',FTTT.xleft,nu1,nu2);
FTTT.yright = pdf('F',FTTT.xright,nu1,nu2);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the F-test statistic
% and calculate the p value. FTTT.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. FTTT.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. FTTT.scale scales the graph
% with respect to the monitor size of the user. xticks is used as it is
% necessary to show the exact critical value on the horizontal axis.
% -------------------------------------------------------------------------
FTTT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
FTTT.nodec = sprintf('%%.%df',0);
FTTT.variables = sprintf(['\\alpha = ',FTTT.alphadec,', \\nu_{1} = ', ...
    FTTT.nodec,', \\nu_{2} = ' FTTT.nodec],alpha,nu1,nu2);

FTTT.mp = get(0,'MonitorPositions');
FTTT.mwidth = FTTT.mp(1,3);
FTTT.mheight = FTTT.mp(1,4);
FTTT.scale = 0.8;

FTTT.gsize = FTTT.scale*FTTT.mheight;
FTTT.x0 = 0.5*(FTTT.mwidth - FTTT.gsize);
FTTT.y0 = 0.5*(FTTT.mheight - FTTT.gsize - 40);

figure
plot(FTTT.x,FTTT.y,'-black');
xticks([FTTT.CVleft FTTT.CVright]);
title("F-distribution");
subtitle({FTTT.variables},'Interpreter','tex');
xlabel("F-value");
ylabel("Density");
xlim([0 FTTT.xmax]);
FTTT.fig = gcf;
axis square
FTTT.fig.Position = [FTTT.x0,FTTT.y0,FTTT.gsize,FTTT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([FTTT.CVleft FTTT.CVright],'LineStyle',':','Color','#9a9afc', ...
    'LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
FTTT.arleft = area(FTTT.xleft,FTTT.yleft);
FTTT.arleft.FaceColor = 'blue';
FTTT.arleft.FaceAlpha = 0.15;
FTTT.arleft.EdgeColor = 'none';

FTTT.arright = area(FTTT.xright,FTTT.yright);
FTTT.arright.FaceColor = 'blue';
FTTT.arright.FaceAlpha = 0.15;
FTTT.arright.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated F-test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the fourth argument (the value of the test
% statistic). In the case that there is no input for the fourth argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the fourth argument, if the value of the test
% statistic lies between the two critical values. If this is the case, the
% null hypothesis cannot be rejected and a vertical light purple dotted
% line corresponding to the value of the F-test statistic and light purple
% shaded areas representing the p value will be added to the plot. Else,
% the null can be rejected and a purple vertical dotted line corresponding
% to the value of the F-test statistic and dark purple shaded areas
% displaying the p value will be plotted. The line will always be plotted,
% the corresponding area will only be shaded if it is contained in the
% interval of the plot.
%
% Afterwards the subtitle is updated and the code has finished running.
% -------------------------------------------------------------------------
if (FTTT.Display == 1)
    % Check if null can be rejected
    if (fstat > FTTT.CVleft && fstat < FTTT.CVright)
        xline(fstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        % Determine the interval of the light purple shaded area
        if (fstat >= icdf('F',0.5,nu1,nu2))
            FTTT.otherptail = 1 - cdf('F',fstat,nu1,nu2);
            FTTT.otherstat = icdf('F',FTTT.otherptail,nu1,nu2);
            FTTT.tintleft = FTTT.CVleft:0.001:FTTT.otherstat;
            FTTT.tintright = fstat:0.001:FTTT.CVright;
            FTTT.pval = (1 - cdf('F',fstat,nu1,nu2))*2;
        else
            FTTT.otherptail = cdf('F',fstat,nu1,nu2);
            FTTT.otherstat = icdf('F',1 - FTTT.otherptail,nu1,nu2);
            FTTT.tintleft = FTTT.CVleft:0.001:fstat;
            FTTT.tintright = FTTT.otherstat:0.001:FTTT.CVright;
            FTTT.pval = 2*cdf('F',fstat,nu1,nu2);
        end
        FTTT.tyl = pdf('F', FTTT.tintleft,nu1,nu2);
        FTTT.tlar = area(FTTT.tintleft,FTTT.tyl);
        FTTT.tlar.FaceColor = '#8a22b3';
        FTTT.tlar.FaceAlpha = 0.04;
        FTTT.tlar.EdgeColor = 'none';

        FTTT.tyr = pdf('F', FTTT.tintright,nu1,nu2);
        FTTT.trar = area(FTTT.tintright,FTTT.tyr);
        FTTT.trar.FaceColor = '#8a22b3';
        FTTT.trar.FaceAlpha = 0.04;
        FTTT.trar.EdgeColor = 'none';
    else
        xline(fstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        % Determine the interval of the dark purple shaded area
        if (fstat >= FTTT.CVright)
            FTTT.otherptail = 1 - cdf('F',fstat,nu1,nu2);
            FTTT.otherstat = icdf('F',FTTT.otherptail,nu1,nu2);
            FTTT.tintleft = FTTT.xmin:0.001:FTTT.otherstat;
            FTTT.tintright = fstat:0.001:FTTT.xmax;
            FTTT.pval = (1 - cdf('F',fstat,nu1,nu2))*2;
        else
            FTTT.otherptail = cdf('F',fstat,nu1,nu2);
            FTTT.otherstat = icdf('F',1 - FTTT.otherptail,nu1,nu2);
            FTTT.tintleft = FTTT.xmin:0.001:fstat;
            FTTT.tintright = FTTT.otherstat:0.001:FTTT.xmax;
            FTTT.pval = 2*cdf('F',fstat,nu1,nu2);
        end
        if (fstat < FTTT.xmax)
            FTTT.tyl = pdf('F',FTTT.tintleft,nu1,nu2);
            FTTT.tlar = area(FTTT.tintleft,FTTT.tyl);
            FTTT.tlar.FaceColor = '#8a22b3';
            FTTT.tlar.FaceAlpha = 1;
            FTTT.tlar.EdgeColor = 'none';

            FTTT.tyr = pdf('F',FTTT.tintright,nu1,nu2);
            FTTT.trar = area(FTTT.tintright,FTTT.tyr);
            FTTT.trar.FaceColor = '#8a22b3';
            FTTT.trar.FaceAlpha = 1;
            FTTT.trar.EdgeColor = 'none';
        end
    end
    FTTT.empdec = sprintf('%%.%df',4);
    FTTT.pdec = sprintf('%%.%df',4);
    FTTT.tp = sprintf(['Test statistic = ',FTTT.empdec,',p value = ', ...
        FTTT.pdec],fstat,FTTT.pval);
    subtitle({FTTT.variables,FTTT.tp},'Interpreter','tex');
end

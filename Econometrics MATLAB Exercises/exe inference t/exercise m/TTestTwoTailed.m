function TTTT = TTestTwoTailed(nu, alpha, tstat)
%TTESTTWOTAILED Visualize the two-tailed Student's t-test.
%   TTTT = TTestTwoTailed(NU, ALPHA, TSTAT) plots the theoretical student's
%   t-distribution with NU degrees of freedom. It calculates the two
%   critical values corresponding to a two tailed t-test with NU degrees of
%   freedom at an ALPHA level of significance and plots the related
%   rejection regions. A vertical line representing the manually calculated
%   test statistic valued TSTAT will be plotted, this input argument is
%   optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu <= 0)
    uiwait(warndlg('The degrees of freedom should be larger than zero.'));
    return
elseif (mod(nu, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of ' ...
        'freedom.']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and ' ...
        'one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the test statistic.
% -------------------------------------------------------------------------
if (nargin == 3)
    TTTT.Display = 1;
else 
    TTTT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical values.
% -------------------------------------------------------------------------
TTTT.CV = icdf('T',1-alpha/2,nu);
TTTT.CVleft = -TTTT.CV;
TTTT.CVright = TTTT.CV;

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical values as having only one or two degrees of freedom can result
% in large critical values. In most cases, the 0.01th percentile
% observation value for the left and and the 99.99th percentile observation
% value gives a good plot interval. When the degrees of freedom is very low
% (less than four), [min(TTTT.CVleft, -10), max(TTTT.CVright, 10)] results
% in an interval that allows the distribution to have visible tails.
% -------------------------------------------------------------------------
TTTT.xmin = min(TTTT.CVleft,max(-10,icdf('T',0.0001,nu)));
TTTT.xmax = max(TTTT.CVright,min(10,icdf('T',0.9999,nu)));
TTTT.x = TTTT.xmin:0.01:TTTT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
TTTT.y = pdf('T',TTTT.x,nu);

% -------------------------------------------------------------------------
% Calculating the rejection regions, as these areas need to be shown in the
% plot.
% -------------------------------------------------------------------------
TTTT.xleft = TTTT.xmin:0.001:TTTT.CVleft;
TTTT.xright = TTTT.CVright:0.001:TTTT.xmax;
TTTT.yleft = pdf('T',TTTT.xleft,nu);
TTTT.yright = pdf('T',TTTT.xright,nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. TTTT.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. TTTT.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. TTTT.scale scales the graph
% with respect to the monitor size of the user. xticks is used as it is
% necessary to show the exact critical value on the horizontal axis.
% -------------------------------------------------------------------------
TTTT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
TTTT.nodec = sprintf('%%.%df',0);
TTTT.variables = sprintf(['\\alpha = ',TTTT.alphadec,', \\nu = ', ...
    TTTT.nodec],alpha,nu);

TTTT.mp = get(0,'MonitorPositions');
TTTT.mwidth = TTTT.mp(1,3);
TTTT.mheight = TTTT.mp(1,4);
TTTT.scale = 0.8;

TTTT.gsize = TTTT.scale*TTTT.mheight;
TTTT.x0 = 0.5*(TTTT.mwidth - TTTT.gsize);
TTTT.y0 = 0.5*(TTTT.mheight - TTTT.gsize - 40);

figure
plot(TTTT.x,TTTT.y,'-black');
xticks([TTTT.CVleft 0 TTTT.CVright]);
title("t-distribution");
subtitle({TTTT.variables},'Interpreter','tex');
xlabel("t-value");
ylabel("Density");
TTTT.fig = gcf;
axis square
TTTT.fig.Position = [TTTT.x0,TTTT.y0,TTTT.gsize,TTTT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([TTTT.CVleft TTTT.CVright],'LineStyle',':','Color','#9a9afc', ...
    'LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
TTTT.arleft = area(TTTT.xleft,TTTT.yleft);
TTTT.arleft.FaceColor = 'blue';
TTTT.arleft.FaceAlpha = 0.15;
TTTT.arleft.EdgeColor = 'none';

TTTT.arright = area(TTTT.xright,TTTT.yright);
TTTT.arright.FaceColor = 'blue';
TTTT.arright.FaceAlpha = 0.15;
TTTT.arright.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
% 
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the absolute value of the test
% statistic is smaller than the critical value. If this is the case, the
% null hypothesis cannot be rejected and a vertical light purple dotted
% line corresponding to the value of the test statistic and light purple
% shaded areas representing the p value will be added to the plot. Else,
% the null can be rejected and a purple vertical dotted line corresponding
% to the value of the test statistic and dark purple shaded areas
% displaying the p value will be plotted. The line will always be plotted,
% the corresponding area will only be shaded if it is contained in the
% interval of the plot.
%
% Afterwards the subtitle will be updated and the code has finished
% running.
% -------------------------------------------------------------------------
if (TTTT.Display == 1)
    if (abs(tstat) < TTTT.CV)
        xline(tstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        TTTT.tintleft = TTTT.CVleft:0.001:-abs(tstat);
        TTTT.tintright = abs(tstat):0.001:TTTT.CVright;

        TTTT.tyl = pdf('T',TTTT.tintleft,nu);
        TTTT.tlar = area(TTTT.tintleft,TTTT.tyl);
        TTTT.tlar.FaceColor = '#8a22b3';
        TTTT.tlar.FaceAlpha = 0.04;
        TTTT.tlar.EdgeColor = 'none';

        TTTT.tyr = pdf('T',TTTT.tintright,nu);
        TTTT.trar = area(TTTT.tintright,TTTT.tyr);
        TTTT.trar.FaceColor = '#8a22b3';
        TTTT.trar.FaceAlpha = 0.04;
        TTTT.trar.EdgeColor = 'none';
    else
        xline(tstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        if all([tstat > TTTT.xmin tstat< TTTT.xmax])
            TTTT.tintleft = TTTT.xmin:0.001:-abs(tstat);
            TTTT.tintright = abs(tstat):0.001:TTTT.xmax;

            TTTT.tyl = pdf('T',TTTT.tintleft,nu);
            TTTT.tlar = area(TTTT.tintleft,TTTT.tyl);
            TTTT.tlar.FaceColor = '#8a22b3';
            TTTT.tlar.FaceAlpha = 1;
            TTTT.tlar.EdgeColor = 'none';

            TTTT.tyr = pdf('T',TTTT.tintright,nu);
            TTTT.trar = area(TTTT.tintright,TTTT.tyr);
            TTTT.trar.FaceColor = '#8a22b3';
            TTTT.trar.FaceAlpha = 1;
            TTTT.trar.EdgeColor = 'none';
        end
    end
    TTTT.pval = 2*cdf('T',-abs(tstat),nu);
    TTTT.empdec = sprintf('%%.%df',4);
    TTTT.pdec = sprintf('%%.%df',4);
    TTTT.tp = sprintf(['Test statistic = ',TTTT.empdec,',p value = ', ...
        TTTT.pdec],tstat,TTTT.pval);
    subtitle({TTTT.variables,TTTT.tp},'Interpreter','tex');
end

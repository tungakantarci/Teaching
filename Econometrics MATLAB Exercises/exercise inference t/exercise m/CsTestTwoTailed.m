function CsTTT = CsTestTwoTailed(nu, alpha, csstat)
%CsTESTTWOTAILED Visualize the two-tailed Chi-square test.
%   CSTTS = CSTestTwoTailed(NU, ALPHA, CSSTAT) plots the theoretical
%   Chi-square distribution with NU degrees of freedom. It calculates the
%   two critical values corresponding to a two tailed Chi-square test with
%   NU degrees of freedom at an ALPHA level of significance and plots the
%   related rejection regions. A vertical line representing the manually
%   calculated Chi-square test statistic valued CSSTAT will be plotted,
%   this input argument is optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu <= 0)
    uiwait(warndlg(['The degrees of freedom should be larger than ' ...
        'zero.']));
    return
elseif (mod(nu, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of ' ...
        'freedom .']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and' ...
        ' one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the Chi-square test statistic and make
% sure that the Chi-square test statistic is nonnegative valued.
% -------------------------------------------------------------------------
if (nargin == 3)
    if (csstat < 0)
        uiwait(warndlg(['The test statistic cannot be negative valued,' ...
            ' please make sure that the test statistic is correctly' ...
            ' calculated.']));
        return
    end
    CsTTT.Display = 1;
else 
    CsTTT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical values.
% -------------------------------------------------------------------------
CsTTT.CVleft = icdf('Chisquare',alpha/2,nu);
CsTTT.CVright = icdf('Chisquare',1-alpha/2,nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having a large degrees of freedom can result in a large
% critical value. This has been done by setting the right end value of the
% interval to the value of the 99.99th percentile observation.
% -------------------------------------------------------------------------
CsTTT.xmin = 0;
CsTTT.xmax = icdf('Chisquare',0.9999,nu);
CsTTT.x = CsTTT.xmin:0.01:CsTTT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
CsTTT.y = pdf('Chisquare',CsTTT.x,nu);

% -------------------------------------------------------------------------
% Calculating the rejection regions, as these areas need to be shown in the
% plot.
% -------------------------------------------------------------------------
CsTTT.xleft = CsTTT.xmin:0.001:CsTTT.CVleft;
CsTTT.xright = CsTTT.CVright:0.001:CsTTT.xmax;
CsTTT.yleft = pdf('Chisquare',CsTTT.xleft,nu);
CsTTT.yright = pdf('Chisquare',CsTTT.xright,nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the Chi-square test
% statistic and calculate the p value. CSTTS.alphadec is used to determine
% the number of decimals for displaying alpha, which depends on the user
% and hence is dynamic. CSTTS.nodec is used for the degrees of freedom,
% which don't have decimals. The code then asks for the size of the monitor
% of the user to calculate the size (in pixels) of the graph. CSTTS.scale
% scales the graph with respect to the monitor size of the user. xticks is
% used as it is necessary to show the exact critical value on the
% horizontal axis.
% -------------------------------------------------------------------------
CsTTT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
CsTTT.nodec = sprintf('%%.%df',0);
CsTTT.variables = sprintf(['\\alpha = ',CsTTT.alphadec,', \\nu = ', ...
    CsTTT.nodec],alpha,nu);

CsTTT.mp = get(0,'MonitorPositions');
CsTTT.mwidth = CsTTT.mp(1,3);
CsTTT.mheight = CsTTT.mp(1,4);
CsTTT.scale = 0.8;

CsTTT.gsize = CsTTT.scale*CsTTT.mheight;
CsTTT.x0 = 0.5*(CsTTT.mwidth - CsTTT.gsize);
CsTTT.y0 = 0.5*(CsTTT.mheight - CsTTT.gsize - 40);

figure
plot(CsTTT.x,CsTTT.y,'-black');
xticks([CsTTT.CVleft CsTTT.CVright]);
title("Chi-square distribution");
subtitle({CsTTT.variables},'Interpreter','tex');
xlabel("Chi-square value");
ylabel("Density");
xlim([0 CsTTT.xmax]);
CsTTT.fig = gcf;
axis square
CsTTT.fig.Position = [CsTTT.x0,CsTTT.y0,CsTTT.gsize,CsTTT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([CsTTT.CVleft CsTTT.CVright],'LineStyle',':','Color', ...
    '#9a9afc','LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
CsTTT.arleft = area(CsTTT.xleft,CsTTT.yleft);
CsTTT.arleft.FaceColor = 'blue';
CsTTT.arleft.FaceAlpha = 0.15;
CsTTT.arleft.EdgeColor = 'none';

CsTTT.arright = area(CsTTT.xright,CsTTT.yright);
CsTTT.arright.FaceColor = 'blue';
CsTTT.arright.FaceAlpha = 0.15;
CsTTT.arright.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated Chi-square test
% statistic and compute the corresponding p value. This part of the code
% will only run when there is input for the third argument (the value of
% the test statistic). In the case that there is no input for the third
% argument, the p value will not be calculated and the function has
% finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the value of the test
% statistic lies between the two critical values. If this is the case, the
% null hypothesis cannot be rejected and a vertical light purple dotted
% line corresponding to the value of the Chi-square test statistic and
% light purple shaded areas representing the p value will be added to the
% plot. Else, the null can be rejected and a purple vertical dotted line
% corresponding to the value of the Chi-square test statistic and dark
% purple shaded areas displaying the p value will be plotted.
%
% Afterwards the subtitle is updated and the code has finished running.
% -------------------------------------------------------------------------
if (CsTTT.Display == 1)
    % Check if null can be rejected
    if (csstat > CsTTT.CVleft && csstat < CsTTT.CVright)
        xline(csstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        % Determine the interval of the light purple shaded area
        if (csstat >= icdf('Chisquare',0.5,nu))
            CsTTT.otherptail = 1 - cdf('Chisquare',csstat,nu);
            CsTTT.otherstat = icdf('Chisquare',CsTTT.otherptail,nu);
            CsTTT.tintleft = CsTTT.CVleft:0.001:CsTTT.otherstat;
            CsTTT.tintright = csstat:0.001:CsTTT.CVright;
            CsTTT.pval = (1 - cdf('Chisquare',csstat,nu))*2;
        else
            CsTTT.otherptail = cdf('Chisquare',csstat,nu);
            CsTTT.otherstat = icdf('Chisquare',1 - CsTTT.otherptail,nu);
            CsTTT.tintleft = CsTTT.CVleft:0.001:csstat;
            CsTTT.tintright = CsTTT.otherstat:0.001:CsTTT.CVright;
            CsTTT.pval = 2*cdf('Chisquare',csstat,nu);
        end
        CsTTT.tyl = pdf('Chisquare',CsTTT.tintleft,nu);
        CsTTT.tlar = area(CsTTT.tintleft,CsTTT.tyl);
        CsTTT.tlar.FaceColor = '#8a22b3';
        CsTTT.tlar.FaceAlpha = 0.04;
        CsTTT.tlar.EdgeColor = 'none';

        CsTTT.tyr = pdf('Chisquare',CsTTT.tintright,nu);
        CsTTT.trar = area(CsTTT.tintright,CsTTT.tyr);
        CsTTT.trar.FaceColor = '#8a22b3';
        CsTTT.trar.FaceAlpha = 0.04;
        CsTTT.trar.EdgeColor = 'none';
    else
        xline(csstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        % Determine the interval of the dark purple shaded area
        if (csstat >= CsTTT.CVright)
            CsTTT.otherptail = 1 - cdf('Chisquare',csstat,nu);
            CsTTT.otherstat = icdf('Chisquare',CsTTT.otherptail,nu);
            CsTTT.tintleft = CsTTT.xmin:0.001:CsTTT.otherstat;
            CsTTT.tintright = csstat:0.001:CsTTT.xmax;
            CsTTT.pval = (1 - cdf('Chisquare',csstat,nu))*2;
        else
            CsTTT.otherptail = cdf('Chisquare',csstat,nu);
            CsTTT.otherstat = icdf('Chisquare',1 - CsTTT.otherptail,nu);
            CsTTT.tintleft = CsTTT.xmin:0.001:csstat;
            CsTTT.tintright = CsTTT.otherstat:0.001:CsTTT.xmax;
            CsTTT.pval = 2*cdf('Chisquare',csstat,nu);
        end
        CsTTT.tyl = pdf('Chisquare',CsTTT.tintleft,nu);
        CsTTT.tlar = area(CsTTT.tintleft,CsTTT.tyl);
        CsTTT.tlar.FaceColor = '#8a22b3';
        CsTTT.tlar.FaceAlpha = 1;
        CsTTT.tlar.EdgeColor = 'none';

        CsTTT.tyr = pdf('Chisquare',CsTTT.tintright,nu);
        CsTTT.trar = area(CsTTT.tintright,CsTTT.tyr);
        CsTTT.trar.FaceColor = '#8a22b3';
        CsTTT.trar.FaceAlpha = 1;
        CsTTT.trar.EdgeColor = 'none';
    end
    CsTTT.empdec = sprintf('%%.%df',4);
    CsTTT.pdec = sprintf('%%.%df',4);
    CsTTT.tp = sprintf(['Test statistic = ',CsTTT.empdec, ...
        ', p value = ',CsTTT.pdec],csstat,CsTTT.pval);
    subtitle({CsTTT.variables,CsTTT.tp},'Interpreter','tex');
end
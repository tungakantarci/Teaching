%% Exercise

h1 = doesItAll(rand(1,100),10);
h2 = doesItAll(rand(1,100),10,0.5,10);

function h = doesItAll(data_sim,nbins,t,ylim)
    plotType = '';
    if nargin >= 2
        h(1) = histogram(data_sim,nbins,'FaceColor','white','EdgeAlpha',0.15);
        plotType = 'a';
        xAxeLbl = 'a';
        yAxeLbl = 'a';
        plotLegends = {'a'};
    end
    
    if nargin >= 4
        h(2) = line([t t],[0 ylim],'Color','blue') ;
        plotType = 'b';
        xAxeLbl = 'b';
        yAxeLbl = 'b';
        plotLegends = {'b' 'b'};
    end
    
    title(['Fig: ' plotType]);
    legend(plotLegends);
    ylabel(yAxeLbl);
    xlabel(xAxeLbl);
end
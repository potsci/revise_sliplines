function [grains2,ebsd1,gB2,a,b,c,d]=RegionOfinterest(ebsd)
    % plot grains in IPF
    plotx2east;
    plotzIntoPlane;
    oM = ipdfHSVOrientationMapping(ebsd('indexed'));
    oM.inversePoleFigureDirection=zvector;
    %% set region
    a=input('\n please input the region range xmin: ');
    b=input('\n please input the region range ymin: ');
    c=input('\n please input the region range x range: ');
    d=input('\n please input the region range y range: ');
    region=[a,b,c,d];
    %  hold on
    %  % plot region in whole figure
    % rectangle('position',region,'edgecolor','w','linewidth',2);
    %   hold off
    condition=inpolygon(ebsd,region);
    ebsd1=ebsd(condition);

    %% plot region
    % plotx2east
    % figure
    % plot(ebsd1('indexed'),oM.orientation2color(ebsd1('indexed').orientations),zvector,'antipodal');
    %  % recaculate grains
    [grains2,ebsd1.grainId,ebsd1.mis2mean] = calcGrains(ebsd1,'angle',2*degree,'augmentation','convexhull','silent');   
    grains2=smooth(grains2);
    gB2=grains2.boundary('indexed','indexed');
    gB3=grains2.boundary('indexed','notIndexed');
    % plot grains boundary
    %  hold on,plot(gB2(gB2.misorientation.angle./ degree>=15),'linecolor','k','linewidth',0.5*2);
    % %     overlay small angle boundaries above 5°
    % hold on, plot(gB2((2<gB2.misorientation.angle/degree)&(gB2.misorientation.angle/degree <15)),'linecolor','w','linewidth',0.5*2);
    %     hold on, plot(grains2.innerBoundary,'linecolor','w','linewidth',0.5*2);    
    %     hold on, plot(gB3,'linecolor','k','linewidth',0.5*2);
    % hold off;
end
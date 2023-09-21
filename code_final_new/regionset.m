% plot grains in IPF
    plotx2east;
    plotzIntoPlane;
    oM = ipdfHSVOrientationMapping(ebsd('indexed'));
    oM.inversePoleFigureDirection=zvector;
%     figure
% plot(ebsd('Magnesium'),oM.orientation2color(ebsd('Magnesium').orientations),'antipodal');
% % plot grians boundary
%  hold on, plot(gB(gB.misorientation.angle./ degree>=15),'linecolor','b','linewidth',0.5*2);
% %     overlay small angle boundaries above 5°
%     hold on, plot(gB((2<gB.misorientation.angle/degree)&(gB.misorientation.angle/degree <15)),'linecolor','w','linewidth',0.5*2);
%     hold on, plot(grains.innerBoundary,'linecolor','w','linewidth',0.5*2);    
%     hold on, plot(gB1,'linecolor','k','linewidth',0.5);
%     hold off;
%% set region
% retangular
a=input('\n please input the region range xmin: ');
b=input('\n please input the region range ymin: ');
c=input('\n please input the region range x range: ');
d=input('\n please input the region range ymin: ');
region=[a,b,c,d];
% %  hold on
% %  % plot region in whole figure
% % rectangle('position',region,'edgecolor','w','linewidth',2);
% %   hold off
condition=inpolygon(ebsd,region);
ebsd1=ebsd(condition);

%% set region circle
% id=1291;
% [a,b]=centroid(grains(id));
% R=100;
% condition=(ebsd.x-a).^2+(ebsd.y-b).^2-R^2<0;
% ebsd1=ebsd(condition);
% hold on
% circle(a,b,R,'w');
%% plot region
plotx2east
figure
%   if strcmp(ext,'crc')
%     plot(ebsd1,ebsd1.bc,'silent');
%     colormap gray
%     freezeColors;
%   end
%     if strcmp(ext,'ang')1
%     plot(ebsd1,ebsd1.ci,'silent');
%     colormap gray
%     freezeColors;
%     end
 % recaculate grains
[grainsI,ebsd1.grainId] = calcGrains(ebsd1('indexed'),'angle',2*degree,'augmentation','silent');   
grainsI=smooth(grainsI);
gB2=grainsI.boundary('indexed','indexed');
gB3=grainsI.boundary('indexed','notIndexed');
% plotIPF
plot(ebsd1('indexed'),oM.orientation2color(ebsd1('indexed').orientations),zvector,'antipodal');
% plot grains boundary
 hold on,plot(gB2(gB2.misorientation.angle./ degree>=15),'linecolor','k','linewidth',0.5*2);
%     overlay small angle boundaries above 5°
hold on, plot(gB2((2<gB2.misorientation.angle/degree)&(gB2.misorientation.angle/degree <15)),'linecolor','w','linewidth',0.5*2);
    hold on, plot(grainsI.innerBoundary,'linecolor','w','linewidth',0.5*2);    
    hold on, plot(gB3,'linecolor','k','linewidth',0.5*2);
hold off;
 %% recaculate odf
% % compute optimal halfwidth from the meanorientations of grains
% psi1 = calcKernel(grains2('indexed').meanOrientation);
% % compute the ODF with the kernel psi
% odf1 = calcODF(ebsd1('indexed').orientations,'halfwidth',5*degree);
%% rotate
% rot=rotation('axis',xvector,'angle',90*degree);
% odf2=rotate(odf1,rot);
% %% plot pf in region
%     figure
%     plotx2north;
%     plotzIntoPlane;
%     plotPDF(odf1,hkl,'resolution',1*degree,'antipodal','complete','grid','on','fontsize',20,'tight','silent','minmax');
%    Rerange(gcf)
%     text(vector3d.X,'RD','BackgroundColor','w','fontSize',14);
%     text(vector3d.Y,'TD','BackgroundColor','w','fontSize',14);
%     mtexColorbar

%%
% condition=abs(gB2.misorientation.angle/degree-86)<5;
% condition1=angle(gB2.misorientation.axis,Miller(1,1,-2,0,CS{2}))/degree<5;
% hold on
% plot(gB2(condition & condition1),'linecolor','b','linewidth',2)
% export_fig(['NO17.png'],opts.dpi,'-transparent')
% close
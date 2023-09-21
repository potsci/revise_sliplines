% This function is used to crop the ebsd map when it is too large to same
% the calculation time
function [SubFolder,grainsI,ebsdI]=EBSDcrop(path,ebsd)
    plotx2east
    plotzIntoPlane
    % cropping the EBSD to a small area
    EC=input('\ncrop EBSD to a small area:','s');
    if strcmp(EC,'y')
    % define region of interest
        [grainsI,ebsdI,gB,x0,y0,xr,yr]=RegionOfinterest(ebsd);
    else
        ebsdI=ebsd;
        [grainsI,ebsdI.grainId,ebsdI.mis2mean] = calcGrains(ebsdI,'angle',2*degree,'augmentation','convexhull','silent'); 
        x0=0;
        y0=0;
        xr=max(max(ebsd.x));
        yr=max(max(ebsd.y));
        gB=grainsI.boundary;
    end
    %  SubFolder=[pwd, '\area' num2str(AId) '_' num2str(x0) 'x' num2str(y0) 'x' num2str(xr) 'x' num2str(yr)];
     SubFolder=[path, 'Analysis' '_' num2str(x0) 'x' num2str(y0) 'x' num2str(ceil(xr)) 'x' num2str(ceil(yr))];
     if ~exist(SubFolder, 'dir')
        mkdir(SubFolder);
     end
    % export grain boundary figure
    plotx2east
    plotzIntoPlane
    figure
    plot(ebsdI,ebsdI.imagequality);
    hold on
    plot(grainsI.boundary);
    % import figuresplot(gB2,'k');
    % export_fig([SubFolder '\area' num2str(AId) '.tif'],'-r500');
    export_fig([SubFolder '\GB+IQ.tif'],'-r100');
    close
end
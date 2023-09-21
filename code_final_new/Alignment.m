% This function is used to realign the SE and EBSD images and accordingly
% rotate the SE imgage at high magnification to exclude the influence
% introduced by misaligment at different mapping. This function we need
% three diffent reference points in SE and EBSD respectively, where the
% indentation impression are good candidates.
function Alignment(cs)
    %% set new EBSD mapping
    %% calculate ebsd data
    [file,path] = uigetfile('.osc','EBSD File');
    ebsd=calEBSD([path,file],cs);

    %% overlapping and alignment
    % ebsd data cropping
    [SubFolder,grainsI,ebsdI]=EBSDcrop(path,ebsd);
    % load SE and grain boundary image
    [file,path] = uigetfile('.tif','Reference SE Image');
    SEA=imread([path,file]);
    GB=imread([SubFolder '\GB+IQ.tif']);
    % set reference points for overlap
    MPOINTS = readPoints(SEA,3);
    POINTS = readPoints(GB,3);
    % transformation
    tform = fitgeotrans(MPOINTS,POINTS,'Similarity');
    Jregistered = imwarp(SEA,tform,'OutputView',imref2d(size(GB)));
    % compare
    figure
    imshowpair(GB,Jregistered, 'blend');
    pause(1)
    close
    % save croping
    save([SubFolder,'\alignment.mat']);
end
 addpath C:\Users\lukas\mtex-5.8.2
 startup_mtex
%%
 cs = crystalSymmetry('m-3m', [8.04 8.04 8.04], 'X||a', 'Y||b*','Z||c',...
    'mineral', 'Al2Ca', 'color', 'light blue');
% define the interested crystal plane
h=[Miller(1,1,1,cs),Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(1,1,2,cs)];
% define the burger vector of the corresponding slip planes
b=[Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw'),Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw')];
% define the name of each system
slip_name = ["111","100","110","112"];
% define colors for slip lines
col=['r','b','g','y']; % define color for each slip system
TA=5; % threshold angle fore slip system determination
Len =200; % the length of the theorectical lines in the right conner
% coordination convert from Euler aquiring to the SE
Rot=rotation.byAxisAngle(xvector-yvector,180*degree); %
%%
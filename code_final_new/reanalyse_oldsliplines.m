%% start mtex
% startTools(); % replace the path in startTools storing MTEX
% options
% define the crystal symmetry. Pay attention to the difference between HKL
% and EDAX
% % cs=loadCIF('Mg-Magnesium'); % directly read the CIF file
% cs = crystalSymmetry('6/mmm', [3.2 3.2 5.2], 'X||a', 'Y||b*',...
%     'Z||c', 'mineral', 'Magnesium', 'color', 'light blue'); % define the CS (Mg)
% cs = crystalSymmetry('321', [5 5 27], 'X||a', 'Y||b*',...
%     'Z||c', 'mineral', 'Co6Nb7', 'color', 'light blue'); % define the CS
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
Rot=rotation.byAxisAngle(xvector-yvector,180*degree); % EDAX system, Euler angle from OIM
% Rot=rotation.byAxisAngle(xvector,180*degree); % HKL





path='J:\Users\Berners_Lukas\von_Martina\testing_reanalysis'
file='reanalyse_slip.xlsx'
[file,path1] = uigetfile('.xlsx','old analysis file');
%%
output_old = readtable([path,'/',file])
%%
%             s_old=size(output_old)
for i=1:s_old(1)
%                 output_old.comb_index=
    output_old.comb_index(i)=string(sprintf('%s_%i',output_old.image_index{i},output_old.index(i)));
%                 output_old.comb_index=output_old.image_index+output_old.index
end
%%
[unique_lines,index,~]=unique(output_old.comb_index);
%%
output_old_unique=output_old(index,:)
oriI=orientation('Euler',output_old_unique.phi1*degree,output_old_unique.Phi*degree,output_old_unique.phi2*degree,cs);
line=

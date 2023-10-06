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
h=[Miller(1,1,1,cs),Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(1,1,2,cs),Miller(1,1,3,cs),Miller(1,1,4,cs),Miller(1,1,5,cs)];
% define the burger vector of the corresponding slip planes
b=[Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw'),Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw')];
% define the name of each system
slip_name = ["111","100","110","112","113","114","115"];
% define colors for slip lines
col=['r','b','g','y']; % define color for each slip system
TA=5; % threshold angle fore slip system determination
Len =200; % the length of the theorectical lines in the right conner
% coordination convert from Euler aquiring to the SE
Rot=rotation.byAxisAngle(xvector-yvector,180*degree); % EDAX system, Euler angle from OIM
% Rot=rotation.byAxisAngle(xvector,180*degree); % HKL





path='J:\Users\Berners_Lukas\von_Martina\testing_reanalysis'
% path='E:\RWTH_Aachen\Promo\von_Martina'
file='reanalyse_slip.xlsx'
% [file,path] = uigetfile('.xlsx','old analysis file');
%%
pathlist=dir([path '\**\reanalyse_slip*.xlsx'])
pathlist
%%

%%
% s_old=size(output_old)
% for i=1:s_old(1)
% %                 output_old.comb_index=
%     output_old.comb_index(i)=string(sprintf('%s_%i',output_old.image_index{i},output_old.index(i)));
% %                 output_old.comb_index=output_old.image_index+output_old.index
% end
%%
% [unique_lines,index,~]=unique(output_old.comb_index);
%%
% output_old_unique=output_old(index,:)
s_path=size(pathlist)

%%

for i=1:s_path(1)
    
    
    output_old = readtable([pathlist(i).folder,'/',pathlist(i).name]);
    unique_imgs=unique(output_old.image_index);

    for j=1:numel(unique_imgs)
        selection=output_old(strcmp(unique_imgs{j},output_old.image_index),:);
        oriI=orientation('Euler',selection.phi1(1)*degree,selection.Phi(1)*degree,selection.phi2(1)*degree,cs);
        line=[];
        [unique_lines,index,~]=unique(selection.index);
        for l=1:numel(unique_lines)
            line(l).point1=[selection.point1_x(index(l)) selection.point1_y(index(l))];
            line(l).point2=[selection.point2_y(index(l)) selection.point2_y_1(index(l))];
        end
          hSS={};
          for m=1:size(h,2)
            th=symmetrise(h(m)); % symmetrise the plane
            hSS{m}=normalize(oriI*th); % convert to the specimen symmetery
            if hSS{m}==vector3d.Z | hSS{m}==-vector3d.Z
                fprintf(['\n plane' char(h(m)), 'is parallel to Z plane \n']);
            else
                hSSt{m}=normalize(cross(hSS{m},vector3d.Z)); % traces on the observing plane
                hSSt{m}.antipodal=1;
            end
        end
    %% Compare deviation
          [ASS,devang,surfang]=compareInrange_auto(line,hSSt,hSS,col,TA,size(h,2));  
          
          %% A lot of unnecessary reshaping of the arrays
          
          ass_d=shiftdim(ASS,1);
          ass_temp=reshape(ass_d,[],1);
          devang_d=shiftdim(devang,1);
          devang_r=reshape(devang_d,[],1);
          surfang_d=shiftdim(surfang,1);
          surfang_r=reshape(surfang_d,[],1);
          ass_r=ass_temp(ass_temp~=0);
          devang_r=devang_r(ass_temp~=0);
          surfang_r=surfang_r(ass_temp~=0);
          line_test=struct2cell(line);
          line_test=shiftdim(line_test,2);
          line_test=repmat(line_test,1,1,size(slip_name,2));
          line_test=shiftdim(line_test,2);
          line_test=reshape(line_test,[],1,2);
          %%
          line_test=line_test(ass_temp~=0,:,:);
          img_ind=[1:(size(line,2))]';
          img_ind=repmat(img_ind,1,size(slip_name,2));
          img_ind=shiftdim(img_ind,1);
          img_ind=reshape(img_ind,[],1);
          img_ind=img_ind(ass_temp~=0);
           %%
        output_file='reanalyse_slip_automatic';
        write_statistic([pathlist(i).folder],selection.image_index(1),j,output_file,[oriI.phi1/degree,...
                oriI.Phi/degree,oriI.phi2/degree],ass_r,slip_name,devang_r,surfang_r,line_test,img_ind);
    end
end

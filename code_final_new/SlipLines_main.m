% Script for slip trace analysis around indentation impressions

% Input: symmetry group, interesting slip plane, corresponding plane color
%         and EBSD/orientation/texture 


%Instruction: 
% 1. replace the path in startTools (Line 17)
% 2. define crystal symmetry (Line 20-22). For the data from EDAX the
% reference frame should be X||a', 'Y||b*, 'Z//c';' for HKL, should be X||a*
% , 'Y||b', 'Z//c'
% 3. define the interesting slip plane (Line 26)
% 4. define the color of different slip trace (Line 28)
% 5. define the allowed deviation angle for determination
% 6. mode 1: in this mode for the first time, the author need to choose the
% ebsd document with .ang formate. And then the code will automatically
% analyze the ebsd and plot the iq map. Afterward, the code will need three
% reference points to align the ebsd and SE and automatically save a .mat
% file with the alignment file in the Analysis folder. The user can select
% and load it for the second time on. Then the user need to select intereted
% indenter and upload the corresponding SE/AFM. 
% image f
% 7. mode 2: In this mode, the user need to input the Euler angle of the
% interdenter.
% 8. mode 3: In this mode, the user need to upload the ebsd or txt file of the
% texture of the specimen, then the code will calculate the stress tensor 
% in the area around the indenter (This calculation is based on the theory of 
%Von Mises Stress Fields below a Cube Corner Indenter using the Equations 
%of Stress from "Introduction to Contact Mechanics" Fischer-Cripps pp.97-99, 
%2002, "Boussinesq's Problem for a Rigid Cone" Sneddon, 1948  for the Masters
%Thesis of Jared Hann University of Florida, 2012). Based on the calculated 
% stress tensor, the code will further calculate the schmid factor at each 
%grid. Eventually when the maximum schmid factor is larger than threshold 
%one (for example 0.4), this system will be considered as activated. 
%Finally the code will return a probility of each system for these 10000 orientations.
% 9.Mode4: in this mode, the code calculate the theorectical possibility
% for each system according to the slip planes inputed by the user.
% 10. Once the orientation information is known, the code will ask the
% users to mark the slip lines by clicking the starting and end points and
% simutaneously calculate the theoretical lines
% 11. eventually the comparison and determination will be done by the code
% automatically. An excel and image with marked lines will be generated in
% the analysis folder.
%% preclear
clc 
clear
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
h=[Miller(1,1,1,cs),Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(1,1,2,cs),Miller(1,1,3,cs),Miller(1,1,4,cs),Miller(1,1,5,cs),Miller(1,1,6,cs),Miller(1,1,11,cs)];% define the burger vector of the corresponding slip planes
% b=[Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw'),Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw')];
% h=[Miller(0,0,0,1,cs),Miller(1,0,-1,0,cs)]
% define the name of each system
slip_name = ["111","100","110","112","113","114","115","116","1111"];
% define colors for slip lines
col=["r",'b','g','y','c','m','k','w',"[0,0.5,0.5]","[0.5,0,0.5]",]; % define color for each slip system
TA=5; % threshold angle fore slip system determination
Len =200; % the length of the theorectical lines in the right conner
TAS=0; % threshold angle for slip systems between sample and surface, leave 0 if you want to account for all slip lines
% coordination convert from Euler aquiring to the SE
Rot=rotation.byAxisAngle(xvector-yvector,180*degree); % EDAX system, Euler angle from OIM
% Rot=rotation.byAxisAngle(xvector,180*degree); % HKL
output_num=2 %% the file name of the .xls is now automatically generated. Select the folder depth this generation is based on here
manual_output_name='n'
%% Setup of local path, to not newly select the input folder every time again 
localpath = which("SlipLines_main.m")
localpath=erase(localpath,"SlipLines_main.m")
localpath=[localpath '\pathfiles\']
localpath=fullfile(localpath)
% disp(sprintf("Your script is located int : localpath")
    


%% Mode selection and orientation selection or input
Mode= input('\n please select the mode (1 EBSD, 2 single, 3 Random with SF, 4 Random');
switch Mode
    case 1
        % alignment
            Alig=input('\nDid you finish the alignment before: ','s');
            if strcmp(Alig,'n')
                Alignment(cs);
            end
            [file,path1] = uigetfile('.mat','Alignment File');
            load([path1 '\' file]);
    case 2        
    case 3
        % load texture file
           [path,ori]=loadTex(cs);
          % calculate stress tensor
          info=str2double(inputdlg({'indentation depth:','Indenter angle:',...
            'Critical SF:','Resolution:','ScaleZ:','ScaleR:'},'Informations',[1 50]));
          [sigma_1,sigma_2,sigma_3]=StressTensor(info(1),info(2),...
              info(4),info(5),info(6));
          % calculate activity based on the SF law
           for i=1:ori.size(1)
               [Activity(:,i),~]=SFCalc(sigma_1,sigma_2,sigma_3,ori(i),h,b,info(3));
           end
           frequency=sum(Activity,2);
           fraction=frequency/sum(frequency);
           write_random1(slip_name,frequency,fraction,path)
           fprintf('\nDone :)\n')
           return
    case 4
            % get the different plane straces for each system
            for i=1:size(h,2)
                th=symmetrise(h(i),'antipodal'); % symmetrise the plane
                thU=unique(th,'noSymmetry'); % exclude the same miller
                frequency(i,1)=size(thU,1)/2; % exclude the difference between positive and negative
            end
            fraction=frequency./sum(frequency);
            write_random(slip_name,frequency,fraction)
            fprintf('\nDone :)\n')
            return
  
end
%% A different impression with same alignment
Rep='y';
Rep_counts=1;
%%
while (strcmp(Rep,'y'))
            if Rep_counts==1
            d=datetime('now')
            d.Format = 'yyyy_MM_dd_HH_mm_ss'
            output_file=[]
            path_withouthspace=erase(path,' ')
            sub_str_split=strsplit(path_withouthspace,'\')
            for i=0:output_num
                output_file=[(sub_str_split{end-i}),'_', output_file]
            end
%             d=datetime('now')
%             d.Format = 'yyyy_MM_dd_HH_mm_ss'
            output_file=[output_file, '_', char(d)]
            
%             output_file=[output_file, '_', char(d)]
            end
    %% select grain/orientation and upload the corresponding SE/AFM
        % rotation if re-aligned
    
          if Mode==1
      
            % selected interested grains
            reselect=input('\nDo you want to get a new orientation?? y/n: ','s');
            if strcmp(reselect,'y')
                oriI=GrainSelect(ebsdI,grainsI);
            end
%             [file,path] = uigetfile('.tif','Analyzing SE Image');
            load([localpath,'SEname']) % the last saved path is saved to ebsdname.mat
            [file,path] = uigetfile(SEname,'Reference SE Image (.tif)'); 
            if path~=0
                SEname=[path,file]
                save([localpath, 'SEname.mat'],"SEname");    
                clear SEname;
            end


            SE=imread([path,'\',file]);
            %SE=SE(:,:);
            tformN=tform;
            tformN.T(1,1)=1;
            tformN.T(2,2)=1;
            tformN.T(3,:)=[0 0 1]; % remove the shifts and blowing up
            SE=imwarp(SE,tformN,'OutputView',imref2d(size(SE)));
        elseif Mode==2
           if Rep_counts==1
                T = str2double(inputdlg({'phi1:','PHI:','phi2:'},'Eule Angle',[1 50])); 
                oriI=orientation('Euler',T(1)*degree,T(2)*degree,T(3)*degree,cs);
                oriI=Rot*oriI;
            end
            % loade SEM for the first time
            %%
            load([localpath,'SEname']) % the last saved path is saved to ebsdname.mat
            [file,path] = uigetfile(SEname,'Reference SE Image (.tif)'); 
            if path~=0
                SEname=[path,file]
                save([localpath, 'SEname.mat'],"SEname");    
                clear SEname;
            end
            SE=imread([path,file]);
          %%
            SE=rgb2gray(SE)
%             SE=SE(:,:);
            % creat an Analysis folder
            SubFolder = [path '\' 'Analysis'];
            if Rep_counts==1
              if ~exist(SubFolder, 'dir')
                    mkdir(SubFolder);
              end
            end
        end
  
    %% Mark the slip traces
       fi=figure;imshow(SE);axis equal
            line2=[];
            i=1;
            while isempty(get(fi,'CurrentCharacter'))
                hold on
                RPoints=readPoints2(2);
                if ~isempty(RPoints)
                line2(i).point1=[RPoints(1,:)];
                line2(i).point2=[RPoints(2,:)];
                end
%                 line2(i).point1=[RPoints(1,:)];
%                 line2(i).point2=[RPoints(2,:)];
                i=i+1;
                pause(0.05)
            end
            if size(line2(end).point2)<2
                line2=line2(1:end-1)
            end
    %% calculate the theoretical slip traces   
        hSS={};
       for m=1:size(h,2)
            th=symmetrise(h(m)); % symmetrise the plane
            hSS{m}=normalize(oriI*th); % convert to the specimen symmetery
            if hSS{m}==vector3d.Z | hSS{m}==-vector3d.Z
                fprintf(['\n plane' char(h(m)), 'is parallel to Z plane \n']);
                hSSt{m}=normalize(cross(hSS{m},vector3d(1,1,100)));
            else
                hSSt{m}=normalize(cross(hSS{m},vector3d.Z)); % traces on the observing plane
                hSSt{m}.antipodal=1;
            end
       end
        
     %% save the slip lines, image file and orientation to matlab variable
     save(sprintf('%s\\%s%s.mat',path1,output_file,file(1:end-4)),"oriI","line2")
%      savematrix(sprintf('%s\\%s%s.csv',path,output_file,file(1:end-4)))
     writetable(struct2table(line2), sprintf('%s\\%s%s.csv',path1,output_file,file(1:end-4)))
    %% Compare deviation
%         ASS=compare(SE,line2,hSSt,col,TA,size(h,2),slip_name);
          [ASS,devang,surfang]=compareInrange(SE,line2,hSSt,hSS,col,TA,TAS,size(h,2));
          %
           
% %      %%
%           line_t=table(horzcat(line.point1),horzcat(line.point2))
          %% A lot of unnecessary reshaping of the arrays
      [ass_r,devang_r,surfang_r,line_test,img_ind]=reshape_inputs(ASS,devang,surfang,line2,slip_name)

    %% quiver the theorectical traces
    quTSL(SE,hSSt,Len,col);
    %% plot and export
    fprintf ('\nDelete lines.')
        % check whether some lines need to be delect
%         Continue=input('\nDo you want to save the image??y/n: ','s');
%     if strcmp(Continue,'y')
        export_fig(fullfile([path1 '\' file(1:end-4) '_' num2str(Rep_counts)]),'-r100')
%         close 
%     end
    %% statistics
    if Rep_counts==1
        if strcmp(manual_output_name,'y')
            output_num=input('\n Please select the name of the excel ouput file: ',"s");
        else
            output_file=[]
            path_withouthspace=erase(path,' ')
            sub_str_split=strsplit(path_withouthspace,'\')
            for i=0:output_num
                output_file=[(sub_str_split{end-i}),'_', output_file]
            end
%             d=datetime('now')
%             d.Format = 'yyyy_MM_dd_HH_mm_ss'
            output_file=[output_file, '_', char(d)]
        end
    end
% % % % %     for n=1:numel(slip_name)
% % % % %         assignin('caller',slip_name(n),[]);
% % % % %     end

%%
    write_statistic_old([path1 '\'],file,Rep_counts,output_file,[oriI.phi1/degree,...
            oriI.Phi/degree,oriI.phi2/degree],ass_r,slip_name,devang_r,surfang_r,line_test,img_ind);
    Rep=input('\ncontinue to analyze new with same Alignment:','s');
    if strcmp(Rep,'y')
        Rep_counts=Rep_counts+1;
    end
    clear line2 hSSt
end
fprintf('\nDone :)\n');
return
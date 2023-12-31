%  addpath C:\Users\berners\mtex-5.7.0
 startup_mtex
%%
 cs = crystalSymmetry('m-3m', [8.04 8.04 8.04], 'X||a', 'Y||b*','Z||c',...
    'mineral', 'Al2Ca', 'color', 'light blue');
% define the interested crystal plane
h=[Miller(1,1,1,cs),Miller(1,0,0,cs),Miller(1,1,0,cs),Miller(1,1,2,cs),Miller(1,1,3,cs),Miller(1,1,4,cs),Miller(1,1,5,cs)];
% define the burger vector of the corresponding slip planes
b=[Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw'),Miller(1,1,2,cs,'uvw'),Miller(1,1,0,cs,'uvw')];
% define the name of each system
slip_name = ["111","100","110","112","113","114","115"];
% define colors for slip lines
col=["r",'b','g','y','cyan','magenta','white']; % define color for each slip system
TA=3; % threshold angle fore slip system determination
TA_surface=10;
Len =100; % the length of the theorectical lines in the right conner
% coordination convert from Euler aquiring to the SE
Rot=rotation.byAxisAngle(xvector-yvector,180*degree); %
%%
values=readtable('J:\Users\Berners_Lukas\von_Martina\Outcome_SlipLines\export_all_lines.csv')
% values=readtable('C:\Users\freund\Desktop\Stoichiometric\Analysis_0x0x714x551\export_all_lines.csv')
% eulers=readtable('J:\Users\Berners_Lukas\von_Martina\Outcome_SlipLines\Area1_Indents1\Analyse_Indents1.xlsx')
% path='C:\Promo\von+Martina\Outcome_SlipLines'
% path='C:\Users\freund\Desktop\Stoichiometric\Analysis_0x0x714x551'
path='J:\Users\Berners_Lukas\von_Martina\Outcome_SlipLines'
% values=readtable('C:\Promo\von+Martina\Outcome_SlipLines\export_all_lines.csv')
% eulers=readtable('C:\Promo\von+Martina\Outcome_SlipLines\Area1_Indents1\Analyse_Indents1.xlsx')
file_list=dir(fullfile([path '\\**\\*.png']))

%%

% strcmp(file_list.name,u_imgs(1))  
% eulers=readtable(
%%
folders=unique(values.folder)

%%
% folders(1)
% folders{1}
% selection=values(strcmp(folders{1},values.folder),:)
%% if you want to restart from the beginning run this line again.
% if not just run the loop again and the skript will start from the last
% image you used (if I did get it right)
control_i=1;
check_error=0;
control_j=1;
%%

for i=control_i:numel(folders)
%%
selection=values(strcmp(folders{i},values.folder),:);
% euler_t=table(u_imgs,eulers1,eulers2,eulers3);
%%
excels=dir([folders{i} '\\*.xlsx']);
o=1;
while contains(excels(o).name,'reanalyse') %this basically finds the first excel which does not contain reanalyse, i deleted the other wrong ones manually
    eulers=readtable(excels(o));
    o=o+1;
end
%%
eulers=readtable([folders{i} '\\' excels(o).name]);
if sum(strcmp('image_index',eulers.Properties.VariableNames))==0
% eulers=readtable([folders{i}Analyse_Indents1.xlsx')
    imgs=eulers.Var1;
    eulers1=eulers.Var3;
    eulers2=eulers.Var4;
    eulers3=eulers.Var5;
else
 imgs=eulers.image_index;
 eulers1=eulers.phi1;
 eulers2=eulers.Phi;
 eulers3=eulers.phi2;
end
[u_imgs,index,~]=unique(imgs);
eulers1=eulers1(index);
eulers2=eulers2(index);
eulers3=eulers3(index);
%%
euler_t=table(u_imgs,eulers1,eulers2,eulers3);
joined_tab=innerjoin(selection,euler_t,'LeftKeys','file','RightKeys','u_imgs');
%%
if check_error==1
control_j=1;
end
    for j=control_j:numel(u_imgs)
        check_error=0;
        
        %%
        selection=joined_tab(strcmp(u_imgs(j),joined_tab.file),:);
      
%%      %%
        SE=imread([selection.folder{1},'\' selection.file{1}, '.png']);
%         SE_marked=imread([selection.folder{1},'\' selection.file{1}, '_extract_lines.png']);
        % input the euler angle
%         T = str2double(inputdlg({'phi1:','PHI:','phi2:'},'Eule Angle',[1 50])); 
                 oriI=orientation('Euler',selection.eulers1(1)*degree,selection.eulers2(1)*degree,selection.eulers3(1)*degree,cs);
%          oriI=Rot*oriI; % i think we can drop this, as the eulers are
%         saved after this step
        % loade SEM for the first time
%         if Rep_counts==1
%             [file,path] = uigetfile('.tif','Analyzing SE Image');
%             SE=imread([path,file]);
%             SE=SE(:,:,1:3);
            % ceat an Analysis folder
%             SubFolder = [path '\' 'Analysis'];
%             if ~exist(SubFolder, 'dir')
%                      mkdir(SubFolder);
%             end
%         end
%         end

    %% Mark the slip traces
       fi=figure('units','normalized','outerposition',[0 0 1 1]);
       subplot(1,1,1)
       imshow(SE,'Border','tight')
       title('extracted line image, check for missing ones')
       for k=1:size(selection,1)
           hold on
%            disp(k)
           plot([selection.point1_x(k) selection.point2_x(k)],[selection.point1_y(k) selection.point2_y(k)],':','color','black','linewidth',2)
       end
       
%        subplot(1,2,2)
       
%        imshow(SE,'Border','tight');
%        title("original image for comparison")
%        axis equal
%             line2=[];
            line=[];

            for n=1:size(selection,1)
                
            line(n).point1=[selection.point1_x(n) selection.point1_y(n)];
            line(n).point2=[selection.point2_x(n) selection.point2_y(n)];
%             n=size(selection,1);
            end

            
            
            while isempty(get(fi,'CurrentCharacter'))
                hold on
                RPoints=readPoints2(2);
                if ~isempty(RPoints)
                line(n+1).point1=[RPoints(1,:)];
                line(n+1).point2=[RPoints(2,:)];
                end
                n=n+1;
                pause(0.05)
            end
            close all
            %%
            
            %%
            
%        subplot(1,2,1)
%        imshow(SE_marked,'Border','tight')
%        title('extracted_line_image')
    %% calculate the theoretical slip traces   
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
%         ASS=compare(SE,line2,hSSt,col,TA,size(h,2),slip_name);
          [ASS,devang,surfang]=compareInrange(SE,line,hSSt,hSS,col,TA,TA_surface,size(h,2));  
          %
         [ass_r,devang_r,surfang_r,line_test,img_ind]=reshape_inputs(ASS,devang,surfang,line,slip_name);
% %      %%
%           line_t=table(horzcat(line.point1),horzcat(line.point2))

    %% quiver the theorectical traces
        quTSL(SE,hSSt,Len,col);
    %% plot and export
%         fprintf ('\nDelete lines.')
        % check whether some lines need to be delect
%         Continue=input('\nContinue?y/n: ','s');
%         if strcmp(Continue,'y')
            export_fig(fullfile([folders{i} '\' u_imgs{j} '_reanalyse.png']),'-r100')
%             close 
%         end
    %% statistics
%     if Rep_counts==1
    output_file='reanalyse_slip';
%     end
%     for n=1:numel(slip_name)
%         assignin('caller',slip_name(n),[]);
%     end
    write_statistic_old([selection.folder{1}],selection.file(1),j,output_file,[oriI.phi1/degree,...
            oriI.Phi/degree,oriI.phi2/degree],ass_r,slip_name,devang_r,surfang_r,line_test,img_ind);
%     Rep=input('\ncontinue to analyze new with same Alignment:','s');
%     if strcmp(Rep,'y')
%         Rep_counts=Rep_counts+1;
%     end
%%
control_j=control_j+1;
check_error=1;
    end
    control_i=control_i+1;
end

path='C:\Users\freund\Desktop\Stoichiometric\Analysis_0x0x714x551'
%%
file_list=dir(fullfile([path '\\**\\*.png']))
%%
fullfile([path '\\**\\*.png'])
analysis=struct()
%%
% disp(asdfa)
c=1
 headline=["folder", "file","point1_x","point1_y","point2_x","point2_y"];
%         writematrix(headline,[subfolder{1},'\', output_file, '.xlsx'],'Sheet',1,'Range','A1');
         writematrix(headline,[path '\\export_all_lines.csv'],'Delimiter',';');

% writematrix(shiftdim(struct2cell(analysis_unstacked),2),'export_all_lines.csv','FileType','text','Delimiter',';')

for p=1:numel(file_list)
    %%
%     n=file_list(p).name
%     if(numel(n)+3>numel('_extract_lines'))
    if ~(contains(file_list(p).name,'_extract_lines') || contains(file_list(p).name,'_reanalyse'))
        disp(p)

analysis(c).folder=file_list(p).folder;
analysis(c).file=file_list(p).name;
img=imread([file_list(p).folder '\\' file_list(p).name]);
%%
img_gray=rgb2gray(img);
%imshow(img(:,:,1)-img())
% figure
% imshow(img(:,:,3)-img_gray)
img1=img(:,:,1)-img_gray;
img2=img(:,:,2)-img_gray;
img3=img(:,:,3)-img_gray;
%%
img_sum=img1+img2+img3;
%%
% figure
% imshow(img_sum)

%%
imsize=size(img_sum);
%%
slicing=uint32([0.2*imsize(2)-120,0.2*imsize(2)+120,0.8*imsize(2)-120,0.8*imsize(2)+120]);
img_sum(slicing(1):slicing(2),slicing(3):slicing(4))=0;
img_bin=img_sum>0;

% %%
% figure
% imshow(img_bin,'border','tight')
%%
% skel=bwskel(img_bin)
% figure
% imshow(skel);

%% I think we go with a labeling before, to find only one line
props=regionprops(img_bin,'Image','BoundingBox');
%%
% prop_img=props(p).Image;
% figure
% imshow(props(1).Image
% figure
% subplot(1,2,1)

%% Hough for loop
% figure
all_lines=[];


for i=1:numel(props)
%% %%
% subplot(1,3,1)  
prop_img=props(i).Image;
% imshow(prop_img)
% subplot(1,3,2)



    [H,theta,rho] = hough(prop_img,'RhoResolution',1);
%     imshow(imadjust(rescale(H)),[],...  
%        'XData',theta,...
%        'YData',rho,...
%        'InitialMagnification','fit');
%     xlabel('\theta (dregrees)')
%     ylabel('\rho')
%     axis onclclose all

%     axis normal 
%     hold on
    colormap(gca,hot)
  


%%

%%
    P = houghpeaks(H,1,'threshold',ceil(0.5*max(H(:))),'NHoodSize',uneven(size(H)/3) );
%%
    x = theta(P(:,2));
    y = rho(P(:,1));
%     plot(x,y,'s','color','green','LineWidth',2);
   
%%
    lines = houghlines(prop_img,theta,rho,P,'FillGap',5,'MinLength',3);
%     subplot(1,3,3)
%     imshow(prop_img)

%     for k = 1:length(lines)
%         xy = [lines(k).point1; lines(k).point2];
%         hold on
%          plot(xy(:,1),xy(:,2),'LineWidth',2);
%     end
%     hold off
%     imshow()

    for l =1:numel(lines)
        p1=lines(l).point1;
        p2=lines(l).point2;
        p1(1)=p1(1)+props(i).BoundingBox(1);
        p1(2)=p1(2)+props(i).BoundingBox(2);
        p2(1)=p2(1)+props(i).BoundingBox(1);
        p2(2)=p2(2)+props(i).BoundingBox(2);
        lines(l).point1=p1;
        lines(l).point2=p2;
    end

    all_lines=[all_lines lines];
%     pause(0.05)
%     cla
%     pause(0.3)
%      pause(0.2)
end
analysis(c).all_lines=all_lines;
c=c+1;
%%
% end
%     end
%     end
%%
% disp('stuff')
% %      h=figure
%      imshow(img,'Border','tight'), hold on
% %     max_len = 0;
%      for k = 1:length(all_lines)
%          xy = [all_lines(k).point1; all_lines(k).point2];
%           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% % 
%    % Plot beginnings and ends of lines
%         plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%         plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
% % %    % Determine the endpoints of the longest line segment
% % %         len = norm(all_lines(k).point1 - all_lines(k).point2);
% % %     if ( len > max_len)
% % %       max_len = len;
% % %       xy_long = xy;
% % %    end
% %     end
% % %     close all
% % % highlight the longest line segment
% % % plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
%  
%      end
%     exportgraphics(h,[file_list(p).folder ,'\' file_list(p).name(1:end-4) '_extract_lines.png'])
% close all
    end
end

analysis_unstacked=[];
c=1
for i =1:numel(analysis)
    
    disp(i)
    for j =1:numel(analysis(i).all_lines)
        analysis_unstacked(c).folder=analysis(i).folder;
        analysis_unstacked(c).file=analysis(i).file(1:end-4);
        analysis_unstacked(c).point1_x=analysis(i).all_lines(j).point1(1);
        analysis_unstacked(c).point1_y=analysis(i).all_lines(j).point1(2);
        analysis_unstacked(c).point2_x=analysis(i).all_lines(j).point2(1);
        analysis_unstacked(c).point2_y=analysis(i).all_lines(j).point2(2);
        c=c+1;
    end
end

writecell(shiftdim(struct2cell(analysis_unstacked),2),[path '\export_all_lines.csv'],'FileType','text','Delimiter',';','WriteMode','Append');
%%
% cellc=struct2cell(analysis_unstacked)
%cellc=struct2cell(analysis)
%%
%  d = reshape(cellc,2404,6,1)
%  %%
%  d=permute(cellc, [2404,6])
%  %%
% d=cellfun(@transpose,cellc,'UniformOutput',false)
% % analysis.all_lines
% 
% %%
% d=shiftdim(cellc,2)

    %%
function y=uneven(x)
y = 2*floor(x/2)+1;
end

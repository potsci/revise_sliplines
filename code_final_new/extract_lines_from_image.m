path='C:\\Promo\\von+Martina\\Outcome_SlipLines'
%%
file_list=dir(fullfile([path '\\**\\*.png']))
%%
fullfile([path '\\**\\*.png'])
analysis=struct()
%%
c=1
for p=1:numel(file_list)
    %%
%     n=file_list(p).name
%     if(numel(n)+3>numel('_extract_lines'))
    if ~contains(file_list(p).name,'_extract_lines')
        disp(p)

analysis(c).folder=file_list(p).folder;
analysis(c).file=file_list(p).name;
img=imread([file_list(p).folder '\' file_list(p).name]);
%%
img_gray=rgb2gray(img);
%imshow(img(:,:,1)-img())
figure
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

img_sum(180:310,790:920)=0;
img_bin=img_sum>0;
%%
% figure
% imshow(img_bin)
%%
% skel=bwskel(img_bin)
% figure
% imshow(skel);

%% I think we go with a labeling before, to find only one line
props=regionprops(img_bin,'Image','BoundingBox');
%%
prop_img=props(1).Image;
% figure
% imshow(props(1).Image
% figure
% subplot(1,2,1)

%% Hough for loop
% figure
all_lines=[];


for i=1:numel(props)
% 
% subplot(1,3,1)  
% prop_img=props(i).Image;
% imshow(prop_img)
% subplot(1,3,2)



    [H,theta,rho] = hough(prop_img,'RhoResolution',1);
%     imshow(imadjust(rescale(H)),[],...  
%        'XData',theta,...
%        'YData',rho,...
%        'InitialMagnification','fit');
%     xlabel('\theta (dregrees)')
%     ylabel('\rho')
%     axis onc
%     axis normal 
%     hold on
    colormap(gca,hot)
  


%%

%%
    P = houghpeaks(H,3,'threshold',ceil(0.3*max(H(:))),'NHoodSize',uneven(size(H)/3) );
%%
    x = theta(P(:,2));
    y = rho(P(:,1));
%     plot(x,y,'s','color','green','LineWidth',2);
   
%%
    lines = houghlines(prop_img,theta,rho,P,'FillGap',5,'MinLength',3);
%     subplot(1,3,3)
%     imshow(prop_img)
% 
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
    end
%%
% disp('stuff')
%     h=figure
%     imshow(img), hold on
%     max_len = 0;
%     for k = 1:length(all_lines)
%         xy = [all_lines(k).point1; all_lines(k).point2];
%          plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%         plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%         plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
% %    % Determine the endpoints of the longest line segment
% %         len = norm(all_lines(k).point1 - all_lines(k).point2);
% %     if ( len > max_len)
% %       max_len = len;
% %       xy_long = xy;
% %    end
%     end
% %     close all
% % highlight the longest line segment
% % plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
% exportgraphics(h,[file_list(p).folder ,'\' file_list(p).name(1:end-4) '_extract_lines.png'])

close all
end
    %%
function y=uneven(x)
y = 2*floor(x/2)+1;
end

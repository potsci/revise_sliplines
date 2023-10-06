% This function compare the minimum angle between the marked lines and 
% the theoretical slip traces. When the minimum angle is smaller than the 
% given threshold angle, the active slip system will be determined and
% marked with corresponding color.
function [Ss,devang,surfang]=compareInrange_auto(line2,hSSt,hSS,col,TA,num_slipsystem)
%     figure; 
%     imshow(SEI,'Border','tight')
    Ss=zeros(size(line2,2),num_slipsystem); 
    devang=zeros(size(line2,2),num_slipsystem);
    surfang=zeros(size(line2,2),num_slipsystem);
    for i=1:size(line2,2)
        minAn(i,1)=180;
         xy = [line2(i).point1; line2(i).point2];
%          show the mark line
%          hold on
%           plot(xy(:,1),xy(:,2),'--','LineWidth',2,'color','k');
%           text(xy(1,1),xy(1,2),['Line' num2str(i)],'FontSize',12);
         % get the vector of the marked lines
         xyi=xy(2,:)-xy(1,:);
         v = normalize(vector3d(xyi(1),xyi(2),0));
         % calculate the minimum angle betwwen the marked lines and the
         % theoretical lines
         for j=1:size(hSSt,2)
             An=angle(v,hSSt{j})/degree;
             [Anmin,an_ind]=min(An);
             sel=hSS{j};
             slip_sys_cur=sel(an_ind);
             slip_sys_cur.antipodal=1;
             surfang_min=90-angle(vector3d(0,0,1),slip_sys_cur)/degree;
             if Anmin<minAn(i,1)
                 minAn(i,1)=Anmin;           
                 SsM(i,1)=j;
             end
             if Anmin<TA &&surfang_min>10
                 Ss(i,j)=j;
                 surfang(i,j)=surfang_min;
                 devang(i,j)=Anmin;
             end

         end
         %% mark with the best matched line with corresponding color
%           if minAn(i,1)<TA 
%              hold on
%              for k=1:num_slipsystem
%                 switch SsM(i,1)
%                     case k
% %                        fprintf('line %d is %s \n', i, slip_name(k));
%                        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',col(k));
%                 end
%              end
%          end
    end
end
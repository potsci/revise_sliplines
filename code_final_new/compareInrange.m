% This function compare the minimum angle between the marked lines and 
% the theoretical slip traces. When the minimum angle is smaller than the 
% given threshold angle, the active slip system will be determined and
% marked with corresponding color.
function [Ss,devang,surfang]=compareInrange(SEI,line2,hSSt,hSS,col,TA,TAS,num_slipsystem)
    figure; 
    imshow(SEI,'Border','tight')
    Ss=zeros(size(line2,2),num_slipsystem,5); 
    devang=zeros(size(line2,2),num_slipsystem,5);
    surfang=zeros(size(line2,2),num_slipsystem,5);
    for i=1:size(line2,2)
        %%
%         i=7
        
         minAn(i,1)=180;
         xy = [line2(i).point1; line2(i).point2];
%          show the mark line
         hold on
          plot(xy(:,1),xy(:,2),'--','LineWidth',2,'color','k');
          text(xy(1,1),xy(1,2),['Line' num2str(i)],'FontSize',12);
         % get the vector of the marked lines
         xyi=xy(2,:)-xy(1,:);
         v = normalize(vector3d(xyi(1),xyi(2),0));
         % calculate the minimum angle betwwen the marked lines and the
         % theoretical lines
         for j=1:size(hSSt,2)
%              disp(j)
             An=angle(v,hSSt{j})/degree;
             An=round(An,4);
             [An_un,an_un_ind]=unique(An);
             min_ind=An_un<TA;
             an_ind=an_un_ind(min_ind);
             Anmin=An(an_ind);
             sel=hSS{j};
             slip_sys_cur=sel(an_ind);
             slip_sys_cur.antipodal=1;
             surfang_min=90-angle(vector3d(0,0,1),slip_sys_cur)/degree;
             if Anmin<minAn(i,1)
                 minAn(i,1)=min(Anmin);
                 SsM(i,1)=j;
             end
             s_A=size(Anmin);
             for k=1:s_A(2)
             if ~isempty(Anmin)
                 if surfang_min(k)>TAS
                 Ss(i,j,k)=j;
                 surfang(i,j,k)=surfang_min(k);
                 devang(i,j,k)=Anmin(k);
                 end
             end 
             end
         end
         %% mark with the best matched line with corresponding color
          if minAn(i,1)<TA 
             hold on
             for k=1:num_slipsystem
                switch SsM(i,1)
                    case k
%                        fprintf('line %d is %s \n', i, slip_name(k));
                       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',col(k));
                end
             end
         end
    end
end
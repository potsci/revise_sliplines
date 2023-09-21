% This function quiver the theoretical lines in the upper right coner with
% corresponding color
function quTSL(SEI,hSSt,Len,col)
    xy=[0.8*size(SEI,2),0.2*size(SEI,1)];
    xy = [xy;xy];
         for i=1:size(hSSt,2)
             for j=1:size(hSSt{i},2)
                    dir=Len*hSSt{i}(j);
                    % xy = [xy;xy];
                dir = [dir(:);-dir(:)];
                hold on
        %             quiver(grains(id),hSSt(j),'color',col(i));
                      quiver(xy(:,1),xy(:,2),dir.x,dir.y,'color',col(i),'MaxHeadSize',0);
             end
         end
end
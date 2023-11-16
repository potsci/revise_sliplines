% This function write the statistic in to a excel, which consist of the image
% number, slip lines index, euler angle and the active slip system
function write_statistic(subfolder,file,Rep_counts,output_file,T,Ss,slip_name,devang,line2,index)
% function write_statistic(subfolder,file,Rep_counts,output_file,T,Ss,slip_name,devang,line2)
    if ~isfile([subfolder, output_file, '.xlsx'])
        %%
        headline=["image_index","index", "phi1", 'Phi', 'phi2','slip_sys_no','slip_name','devang','point1_x','point1_x','point2_x','point2_y'];
        writematrix(headline,[subfolder, output_file, '.xlsx'],'Sheet',1,'Range','A1');
         writematrix(headline,[subfolder, output_file, '.csv'],'Delimiter',';');
    end
    %%
    disp(':)')
    % Import the data
    output_old = readtable([subfolder, output_file,'.xlsx'],'Sheet',1);
%%
    size_old=size(output_old,1);
    image_index=repmat([file(1:end-4) '_' num2str(Rep_counts)],size(Ss,1),1);
%     image_index=repmat([file(1:end-4) '_' num2str(Rep_counts)],size(Ss,1),1);
    for i=1:numel(Ss)
        slip_name_out(i)=slip_name(Ss(i))
    end
    slip_name_out=reshape(slip_name_out,[],1)
%     index =[1:(size(Ss,1))]';
    phi1 = repmat(T(1),size(Ss,1),1);
    Phi = repmat(T(2),size(Ss,1),1);
    phi2 = repmat(T(3),size(Ss,1),1);
%     slip
p1=vertcat(line2{:,:,1})
p2=vertcat(line2{:,:,2})
    output_current=table(image_index,index, phi1, Phi, phi2, Ss,slip_name_out,devang,p1(:,1),p1(:,2),p2(:,1),p2(:,2));
%%
    writetable(output_current,[subfolder , output_file, '.xlsx'],'Sheet',1,...
        'Range',['A',num2str(size_old+2)],'WriteVariableNames',0);
    writetable(output_current,[subfolder, output_file, '.csv'],'Delimiter',';','WriteMode','Append');
end

% This function write the statistic in to a excel, which consist of the image
% number, slip lines index, euler angle and the active slip system
function write_statistic(subfolder,file,Rep_counts,output_file,T,Ss,slip_name,devang,line2)
    if ~isfile([subfolder{1}, '\', output_file, '.xlsx'])
        %%
        headline=["image_index","index", "phi1", 'Phi', 'phi2','slip_name','devang','point1_x','point1_y','point2_y','point2_y'];
        writematrix(headline,[subfolder{1},'\', output_file, '.xlsx'],'Sheet',1,'Range','A1');
    end
    %%
    disp(':)')
    % Import the data
    output_old = readtable([subfolder{1},'\' output_file,'.xlsx'],'Sheet',1);
%%
    size_old=size(output_old,1);
    image_index=repmat([file(1:end-4) '_' num2str(Rep_counts)],size(Ss,1),1);
    index =[1:(size(Ss,1))]';
    phi1 = repmat(T(1),size(Ss,1),1);
    Phi = repmat(T(2),size(Ss,1),1);
    phi2 = repmat(T(3),size(Ss,1),1);
%     slip
    output_current=table(image_index,index, phi1, Phi, phi2, Ss,devang);
%%
    writetable(output_current,[subfolder{1},'\',output_file, '.xlsx'],'Sheet',1,...
        'Range',['A',num2str(size_old+2)],'WriteVariableNames',0);
end

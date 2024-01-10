function [ass_r,devang_r,surfang_r,line_test,img_ind]=reshape_inputs(ASS,devang,surfang,line2,slip_name)
    %% right now we assume, that there are no more than 5 duplicate slip traces detected, thus we use the 5 along the 2nd axis of repmat, as this is also used iin compareinrange
    ass_d=shiftdim(ASS,1);
    ass_temp=reshape(ass_d,[],1);
    ass_r=ass_temp(ass_temp~=0);
    
    
    devang_d=shiftdim(devang,1);
    devang_r=reshape(devang_d,[],1);
    devang_r=devang_r(ass_temp~=0);
    
    surfang_d=shiftdim(surfang,1);
    surfang_r=reshape(surfang_d,[],1);
    surfang_r=surfang_r(ass_temp~=0);
    %           [row,col]= find(ass_d~=0)
    
    %%
    line_test=struct2cell(line2);
    %%
    line_test=shiftdim(line_test,2);
    %%
    line_test_p1=repmat(line_test(:,1),1,5,size(slip_name,2));
    line_test_p2=repmat(line_test(:,2),1,5,size(slip_name,2));
    %%
    line_test_p1=shiftdim(line_test_p1,1);
    line_test_p2=shiftdim(line_test_p2,1);
    %%
    line_test_p1=reshape(line_test_p1,[],1,1);
    line_test_p2=reshape(line_test_p2,[],1,1);
    %%
    line_test_p1=line_test_p1(ass_temp~=0,:,:);
    line_test_p2=line_test_p2(ass_temp~=0,:,:);
    %%
    line_test=[line_test_p1,line_test_p2];
    %%
    
    img_ind=[1:(size(line2,2))]';
    img_ind=repmat(img_ind,1,5,size(slip_name,2));
    img_ind=shiftdim(img_ind,1);
    img_ind=reshape(img_ind,[],1);
    img_ind=img_ind(ass_temp~=0);
end
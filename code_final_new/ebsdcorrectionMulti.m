function [ebsd,grains] =  ebsdcorrectionMulti(ebsd,opts)
%% detect grains based on segangle
        %calculate grains
         [grains,ebsd.grainId] = calcGrains(ebsd,'angle',opts.segAngle*degree,'augmentation','convexhull','silent');   
         % keep large notIndexed area
         notIndexed = grains('notIndexed');
        % the "not indexed grains" we want to remove
        % toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<0.75);
         toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<0.75);
        % now we remove the corresponding EBSD measurements
         ebsd(toRemove) = [];
        fprintf('Calculating grains...');    
        [grains,ebsd.grainId,~] = calcGrains(ebsd('indexed'),'angle',...
               opts.segAngle*degree,'augmentation','convexhull','silent');  
        condition =grains.grainSize>= opts.nFilter;
        ebsd(grains(~condition))=[];
        grains=grains(condition);
        %% fill the missing data
        F = halfQuadraticFilter;
        F.alpha = 0.25;
        ebsd=smooth(ebsd,F,'fill',grains);
        %% Denoising
        F = meanFilter;
        F.numNeighbours = 1;
        % smooth the data
        ebsd = smooth(ebsd,F);
%% recalculate grains
        fprintf('\n recalculate grains...') 
        [grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',...
        opts.segAngle*degree,'augmentation','convexhull','silent');

%% smooth grains   
        if opts.sm > 0
            grains = smooth(grains,5);
        end
          indPercF = 100*ebsd('indexed').size(1)/(ebsd.size(1)*ebsd.size(2));
          fprintf('\nIndexed points after correction: %1.1f%%\n',indPercF);
          fprintf('done (%d grains)\n',grains.size(1));
end

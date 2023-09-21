% this function will plot out the iq map of the ebsd map, the user will be
% asked to choose a point near the interested impression to get the
% orientation of the grain.
function oriI=GrainSelect(ebsdI,grainsI)
    plotx2east
    plotzIntoPlane
    figure
    plot(ebsdI,ebsdI.imagequality); % plot iq map
    colormap gray
    hold on
    plot(grainsI.boundary)
    A=input('\n Did you select an interesting Point: ','s');
    if strcmp(A,'n')
        fprintf('\n Please select an interesting Point: ');
    else
        [xy,~,~,~] = getDataCursorPos(gcm);
        id = findByLocation(ebsdI,[xy(1) xy(2)]);
        grainsN=grainsI(ebsdI(id).grainId);
        oriI=grainsN.meanOrientation;
        close
    end
end
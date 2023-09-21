function [path,ori]=loadTex(CS)
    Type = input('\n which type of texture file do you have (EBSD/txt):', 's');
    switch Type
        case 'EBSD'
            [file,path] = uigetfile('.ang','EBSD File');
             ebsd= EBSD.load(file, 'convertEuler2SpatialReferenceFrame','setting 2');
             odf = calcODF(ebsd('indexed').orientations,'resolution',3.5*degree);
             export_VPSC(odf,[path '\texture.txt'])
             file2=[path '\texture.txt'];
        case 'txt'
            [file,path] = uigetfile('.txt','Texture File');
            file2=[path '\' file];
    end
            delimiterIn = ' ';
            headerlinesIn =4;
            tex= importdata(file2,delimiterIn,headerlinesIn);
            data=tex.data;
            ori = orientation('Euler',data(:,1)*degree,data(:,2)*degree,data(:,3)*degree,CS);
end

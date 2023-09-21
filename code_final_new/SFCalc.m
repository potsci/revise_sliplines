% This function firstly calculate the stress field around the cube conner
% Indenter and then based on the stress tentor, the schmid factor of each
% slip system at each point around the indenter (r/a=-5~5, z/a=-5~0). When
% the  maximum schmid factor of each slip system is larger than 0.4 (for example), 
% this slip system will be considered to be activated.
% Von Mises Stress Fields % Below a Cube Corner Indenter 
% Using the Equations of Stress from; 
% "Introduction to Contact Mechanics" Fischer-Cripps pp.97-99, 2002 
% "Boussinesq's Problem for a Rigid Cone" Sneddon, 1948 
% For the Masters Thesis of Jared Hann 
% University of Florida, 2012 

function [Activity,SFMaxM] = SFCalc(newsigma_1,newsigma_2,newsigma_3,oriI,h,b,SFC)
    %% calculate SF at each point for each slip system
    % acquiring the slip systems
    sS=slipSystem(b,h);
    sS=sS.symmetrise;
    sSLocal = oriI*sS; % coverting the sS to the orientation
    % calculate each SF for each point around indenter
    for j=1:size(newsigma_1,1)
        for k=1:(size(newsigma_1,2)-1)/2
            sigma=zeros(3,3);
            sigma(1,1)=newsigma_1(j,k);
            sigma(2,2)=newsigma_2(j,k);
            sigma(3,3)=newsigma_3(j,k);
            sigmaST=stressTensor(sigma);
            SF = sSLocal.SchmidFactor(sigmaST);
            SFMax(:,j*k) = SF';
        end
    end
        %%% distinguishment
        Activity=zeros(size(h,2),1);
    for i=1:size(h,2)
        condition=sS.n==h(i);
        SFMaxM(i,1)=max(SFMax(condition,:),[],'all');% get the maximum SF for each slip system
        if SFMaxM(i,1)>SFC
            Activity(i,1)=1;
        end
    end
end


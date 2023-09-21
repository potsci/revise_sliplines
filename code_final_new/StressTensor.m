function [newsigma_1,newsigma_2,newsigma_3]=StressTensor(hp,alpha,RS,scaleZ,scaleR)
%% stress field calculation
    a = hp*tan(alpha*degree);% Indentation radius   
    % Prepare the Meshgrid 
    r2=linspace(scaleR,0,RS); % linspace (r axis) 
    z2=linspace(scaleZ,0,RS); % linspace (Z axis) 
    p1=r2./a; % Normalized radial displacement 
    q1=z2./a; % Normalized z displacement 
    [p,q]=meshgrid(p1,q1);   

    % Inputs for Integrals 
    v=0.25;  % Poisson's ratio 
    R=((p.^2+q.^2-1).^2+4*q.^2).^0.25;  % Dimensionless factor 
    r=(1+q.^2).^0.5;                    % Dimensionless factor 
    theta=atan2(1,q);                   % Dimensionless factor 
    phi=0.5*atan2((2*q),(p.^2+q.^2-1)); % Dimensionless factor   

    % Integrals 
    J02=(p.^2+q.^2).^-0.5-(cos(phi)./R); 
    J11=(1./p).*((p.^2+q.^2).^0.5-(R.*cos(phi)));
    J12=(1./p).*((r./R).*cos(theta-phi)-q.*(p.^2+q.^2).^-0.5); 
    J01=0.5*(log(R.^2+2.*R.*r.*cos(theta-phi)+1+q.^2)-...
        log((q+(p.^2+q.^2).^0.5).^2)); 
    J10=0.5*(p.*J01+1./p.*(1-R.*sin(phi))-q.*J11); 

    % Polar Coordinate Stresses 
    sigma_z=-(J01+q.*J02); 
    sigma_t=-(2*v.*J01+(1./p).*((1-2*v).*J10-q.*J11)); 
    sigma_r=-(2*(1-v^2)*(1-v)^-1).*J01-sigma_z-sigma_t; 
    tau_rz=-(q.*J12); 
    z=-acosh(1./p);   

    % Principal Stresses 
    sigma_1=0.5*(sigma_r+sigma_z)+((0.5.*sigma_r-0.5.*sigma_z).^2+tau_rz.^2).^0.5; 
    sigma_3=0.5*(sigma_r+sigma_z)-((0.5.*sigma_r-0.5.*sigma_z).^2+tau_rz.^2).^0.5; 
    sigma_2=sigma_t; 
    tau_max=.5*(sigma_1-sigma_3);   

    % Removing NaNs 
    sigma_1(:,end)=sigma_1(:,end-1); 
    sigma_2(:,end)=sigma_2(:,end-1); 
    sigma_3(:,end)=sigma_3(:,end-1); 
    tau_max(:,end)=tau_max(:,end-1);   

    % Reflecting Stress Fields Along the Z Axis 
    fsigma_1=fliplr(sigma_1); 
    fsigma_2=fliplr(sigma_2); 
    fsigma_3=fliplr(sigma_3); 
    ftau_max=fliplr(tau_max); 
    fp=fliplr(p); 
    fp(:,1)=[]; 
    np=-p;   

    % Correcting Matrix Dimensions 
    fsigma_1(:,1)=[]; 
    fsigma_2(:,1)=[]; 
    fsigma_3(:,1)=[]; 
    ftau_max(:,1)=[];

    % Corrected Principal Stresses 
    newsigma_1=[sigma_1 fsigma_1]; 
    newsigma_2=[sigma_2 fsigma_2]; 
    newsigma_3=[sigma_3 fsigma_3]; 
    newtau_max=[tau_max ftau_max]; 
    new_p=[np fp]; 
    new_q=[q q(:,1:end-1)];   

    %% Von Mises Stresses 
    % sigma_v=(0.5*((newsigma_1-newsigma_2).^2+(newsigma_1-newsigma_3).^2+(newsigma_2-newsigma_3).^2)).^0.5;  
    % contourf(new_p,-new_q,sigma_v,20),xlabel('r/a'),ylabel('z/a'); title('\sigma_v');   
    % 
    % % Colorbar Settings 
    % B=colorbar('vert'); 
    % set(B, 'Position', [.91 .11 .05 .815])   

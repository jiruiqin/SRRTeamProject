clc;
clear all;

% import datafile
importfile('heatingoildata.csv');

% generate returns matrix
y = data;
n = length(y(1,:));
m = length(y(:,1));
Time = 1:m;
ret = log(y(2:end,:)./y(1:(end-1),:));
covpca = 252*cov(ret);
[s,v,d] = svd(covpca);
NumPC = 3; 

% find the factor loadings/eigen vectors for the top 3 PCs
factor_loading(:,1:2) = -s(:,1:2);
factor_loading(:,3) = s(:,3);

% make factor_loading*factor_score matrix
for i=1:n
    for k=1:NumPC
        sigma(i,k)=factor_loading(i,k)*v(k,k); 
    end
end

% create principal components - first three principal components
pcomp(1)=v(1,1)/sum(sum(v));
pcomp(2)=v(2,2)/sum(sum(v));
pcomp(3)=v(3,3)/sum(sum(v));

% simulate the forward curve
dt = 1/252;         % timestep
k = 1;
f(:,1) = data(1,:); % initialize the forward curve

% Apply the simulation formula based on the FEA paper
for i=k:(m-1)
    sigma1 = (sigma(:,1).^2+sigma(:,2).^2+sigma(:,3).^2)*dt;
    sigma2 = (sigma(:,1)*randn+sigma(:,2)*randn+sigma(:,3)*randn)*sqrt(dt);
    f(:,i+1) = f(:,i).*exp(-0.5*sigma1+sigma2);
end

% surf(meshgrid(f(:,1),f(:,2),f(:,3)));   
    
% Plot 3-D Forward Curve - Historical
T = length(Time);
matur = repmat([1:n]',1,T)';
Time0 = repmat([Time],n,1)';
figure()
surface(Time0,matur,data)
datetick('x','yy','keepticks')
axis('tight')
rotate3d on
grid on  
xlabel('Time')
ylabel('Maturity')
zlabel('Heating Oil Futures')
title('Historical - Heating Oil Future Prices Across Time')

% Plot 3-D Forward Curve - Model Implied
figure()
surface(Time0,matur,f')
datetick('x','yy','keepticks')
axis('tight')
rotate3d on
grid on  
xlabel('Time')
ylabel('Maturity')
zlabel('Heating Oil Futures')
title('Model Implied - Heating Oil Future Prices Across Time')

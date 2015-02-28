clear all

%This program computes the volatility functions to calculate the principal
%components for each month of the year by loading the historical daily forward
%curve data associated with each month.

month=['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'];

for j=1:length(month)

name=[month(j,:) '.txt'];
importfile(name)

y=data;
n=length(y(1,:));                   % 48 forward contracts
ret=log(y(2:end,:)./y(1:end-1,:));  % generate log returns
covpca=252*cov(ret);                % annualize by 252 trading days
[s,v,d]=svd(covpca);                % singular value decomposition

for i=1:n
    for k=1:n
        sigma(i,k)=s(i,k)*sqrt(v(k,k)); % find empirical volatilities
    end
end

[ms,ns]=size(sigma);
msigma(j,:)=reshape(sigma,1,ns*ms);     % combine each month into a giant matrix

% find the proportion of total variance accounted for the first three principal components
pcomp(1,j)=v(1,1)/sum(sum(v));
pcomp(2,j)=v(2,2)/sum(sum(v));
pcomp(3,j)=v(3,3)/sum(sum(v));

end

save msigma
save pcomp


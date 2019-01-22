%totalrate=xlsread('totalrate.xlsx','sheet1');%loading stock price
%selectnumber=xlsread('Book1.xlsx','number1');%loading situation of limit
%up and limit down

loss=-0.15;
times=1000;
begin=246+243;
Portfolio=zeros(20,size(selectnumber,2));%Portfolio matrix
asset=zeros(size(Portfolio,1),size(Portfolio,2));% net assets without stoploss for each period
asset1=zeros(size(Portfolio,1),size(Portfolio,2));% net assets with stoploss for each period
totalasset=zeros(times,size(selectnumber,2));% total assets without stoploss for each period
totalasset1=zeros(times,size(selectnumber,2));%return total assets with stoploss for each period
difference=zeros(times,size(selectnumber,2));%difference between two strategies
change=zeros(times,1);%times of Warehouse adjustment

for m=1:times

% Generating initial index of stock 
n=selectnumber(:,1+begin)';%change initial date
n(n==0)=[];
random1=randsrc(20,1,n);

%Generating Portfolio Matrix
for i=1:20
    Portfolio(i,1+begin)=random1(i,1);%change initial date
end

%Without stoploss
asset(:,1+begin)=1000/20*ones(20,1);%change initial date
for i=1:size(asset,1)
    for j=2+begin:size(asset,2)%change initial date
    asset(i,j)=asset(i,j-1)*(totalrate(random1(i,1),j)+1);
    end
end

for i=1+begin:size(asset,2)%change initial date
    totalasset(m,i)=sum(asset(1:20,i));
end

%Change shares when the return of portfolio is under 10%
a=random1;
asset1(:,1+begin)=1000/20*ones(20,1);%change initial date
c=asset1(:,1+begin);
for j=2+begin:size(selectnumber,2)
for i=1:20
    Portfolio(i,j)=a(i);
    asset1(i,j)=asset1(i,j-1)*(totalrate(Portfolio(i,j),j)+1);%Compute net assets
    if (asset1(i,j)-c(i))/c(i)<loss
        n=selectnumber(:,j)';
        n(n==0)=[];
        a(i)=randsrc(1,1,n);
        c(i)=asset1(i,j);
    end
end
end

%Compute the total asset after share adjustment
for j=1+begin:size(asset1,2)%change initial date
    totalasset1(m,j)=sum(asset1(1:20,j));
end

%times of Warehouse adjustment
b=zeros(size(selectnumber,1),size(selectnumber,2));
for i=1:20
    for j=1+begin:729%change initial date
        if Portfolio(i,j)==Portfolio(i,j+1)
        b(i,j+1)=0;
        else
        b(i,j)=Portfolio(i,j);
        end
    end
end
change(m)=sum(sum(b~=0));

for j=1+begin:size(selectnumber,2)%change initial date
    difference(m,j)=(totalasset1(m,j)-totalasset(m,j))/1000;
end

%Find outliers
if difference(m,730)<-0.8
    mindifference=difference(m,730);
    minrandom1=random1;
    minPortfolio=Portfolio;
    minchang=change(m);
    minasset=asset;
    minasset1=asset1;
end
end

% Plot
[counts,centers] = hist(difference(:,730), 100);
figure
bar(centers, counts / sum(counts))
legend('收益率差','频数');
title('2015年5月-2018年5月');








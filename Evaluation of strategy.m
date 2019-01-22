netasset=xlsread('data.xlsx','netasset');% Loading data from Excel
N=25;% Input parameters of time span
Return=zeros(size(netasset,1),1);
for i=1:size(netasset)-N
    Return(i,1)=(netasset(i+N,1)-netasset(i,1))/netasset(i,1);
end
Return(Return==0)=[];
MAX=max(Return);
MIN=min(Return);
Average=mean(Return);
M=sum(sum(Return>0));
N=sum(sum(Return<0));
Win=M/(M+N);
a=[MAX,Average,MIN,Win];% Result of vector:£¨MAX£¬Mean£¬MIN£¬Winning Probability£©
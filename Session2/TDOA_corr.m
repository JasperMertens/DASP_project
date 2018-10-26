load('Computed_RIRs.mat')

create_micsigs
seg_length=10000;
index=zeros(1,m);
D_est=zeros(1,m);
D=zeros(1,m);
error=zeros(1,m);
for j=1:m
    [~,~, D(j)] = alignsignals(RIR_sources(:,1,j),RIR_sources(:,2,j));
index(j) = find(mic(:,1,j)> 10^-5,1);


segment1=mic(index(j):seg_length+index(j)-1,1,j);
N = length(mic(:,2,j));
corr=zeros(N,1);
for i=1:N-seg_length
    segment2=mic(i:seg_length+i-1,2,j);
    corr(i)=segment1'*segment2;
end
[corr_max, D_est(j)] = max(corr);
D_est(j) = D_est(j) - index(j);
% figure
% plot(-index+1:length(corr)-index,corr)
% hold on
% stem(D,corr_max)
error(j) = D(j)-D_est(j);
end
load('Computed_RIRs.mat')
[~,~, D] = alignsignals(RIR_sources(:,1),RIR_sources(:,2));
create_micsigs
index = find(mic(:,1)> 10^-5,1);
seg_length=80000;

segment1=mic(index:seg_length+index-1,1);
N = length(mic(:,2));
corr=zeros(N,1);
for i=1:N-seg_length
    segment2=mic(i:seg_length+i-1,2);
    corr(i)=segment1'*segment2;
end
[corr_max, D_est] = max(corr)
D_est = D_est - index
figure
plot(-index+1:length(corr)-index,corr)
hold on
stem(D,corr_max)
error = D-D_est
filename{1}= 'White_noise1.wav';
filename{2}= 'speech2.wav';
load('Computed_RIRs.mat')
m_length=10;
mic_samples=m_length*fs_RIR;
[~, n, m]=size(RIR_sources); % number of microphones: n, number of sources: m
[audio1_samples, fs_audio1] = audioread(filename{1});
[audio2_samples, fs_audio2] = audioread(filename{2});
audio1_samples = resample(audio1_samples,fs_RIR, fs_audio1);
audio2_samples = resample(audio2_samples,fs_RIR, fs_audio2);

% only for independent white noise
audio1_samples = audio1_samples(1:500000);
audio2_samples = audio2_samples(500001:end);


mic_audio_mat = zeros(mic_samples, n);
index_vec = zeros(1,m);
for i=1:n
    for j=1:m
        mic_audio= conv(RIR_sources(:,i,j),audio1_samples);
        index_vec(j) = find(mic_audio > 10^-5,1);
        mic_audio_mat(:,i)= mic_audio_mat(:,i) + mic_audio(1:mic_samples);
    end
end

mic = mic_audio_mat;
index = max(index_vec);
seg_length=80000;

segment1=mic(index:seg_length+index-1,1);
N = length(mic(:,2));
cross_corr=zeros(N-seg_length,1);
for i=1:N-seg_length
    segment2=mic(i:seg_length+i-1,2);
    cross_corr(i)=segment1'*segment2;
end
[cross_corr_max, D_est] = max(cross_corr);
D_est = D_est - index;


figure
plot(-index+1:length(cross_corr)-index,cross_corr)
hold on
stem(D_est,cross_corr_max)

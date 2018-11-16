speechfilename{1}= 'speech1.wav';
speechfilename{2}= 'speech2.wav';
noisefilename{1}= 'Babble_noise1.wav';
noisefilename{2}= 'White_noise1.wav';
m_length=10;




load('Computed_RIRs.mat')
[~, n, m]=size(RIR_sources);
RIR_noise=zeros(1,n,m);
mic_samples=m_length*fs_RIR;
[speech1_samples, fs_speech1] = audioread(speechfilename{1});
[speech2_samples, fs_speech2] = audioread(speechfilename{2});
[noise1_samples, fs_noise1] = audioread(noisefilename{1});
%[noise2_samples, fs_noise2] = audioread(noisefilename{2});

speech1_samples = resample(speech1_samples,fs_RIR, fs_speech1);
speech2_samples = resample(speech2_samples,fs_RIR, fs_speech2);
noise1_samples = resample(noise1_samples,fs_RIR, fs_noise1);
%noise2_samples = resample(noise2_samples,fs_RIR, fs_noise2);


mic_speech_mat = zeros(mic_samples,n,m);
mic_noise_mat = zeros(mic_samples,n,m);
for i=1:n
    for j=1:m
        mic_speech=fftfilt(RIR_sources(:,i,j), speech1_samples);
        mic_speech_mat(:,i,j)=mic_speech(1:mic_samples);
        mic_noise=fftfilt(RIR_noise(:,i,j), noise1_samples);
        mic_noise_mat(:,i,j)=mic_noise(1:mic_samples);
    end
end

mic=mic_speech_mat+mic_noise_mat;
save('mic','mic', 'fs_RIR');

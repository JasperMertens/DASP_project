% Group 5, Sergio Malo Torreiro, Jasper Mertens 

filename{1}= 'speech1.wav';
filename{2}= 'speech2.wav';
load('Computed_RIRs.mat')
m_length=10;
mic_samples=m_length*fs_RIR;
[~, n, m]=size(RIR_sources); % number of microphones: n, number of sources: m
[audio1_samples, fs_audio1] = audioread(filename{1});
[audio2_samples, fs_audio2] = audioread(filename{2});
audio1_samples = resample(audio1_samples,fs_RIR, fs_audio1);
audio2_samples = resample(audio2_samples,fs_RIR, fs_audio2);

mic_audio_mat = zeros(mic_samples, n);
for i=1:n
    for j=1:m
        mic_audio= fftfilt(RIR_sources(:,i,j),audio1_samples);
        mic_audio_mat(:,i)= mic_audio_mat(:,i) + mic_audio(1:mic_samples);
    end
end

mic = mic_audio_mat;
save('mic','mic', 'fs_RIR');

filename{1}= 'speech1.wav';
filename{2}= 'speech2.wav';
load('Computed_RIRs.mat')
if (fs_RIR ~= 44100)
    warning('Invalid sample rate')
end
m_length=1;
mic_samples=m_length*fs_RIR;
[~, n, ma]=size(RIR_sources); % number of microphones: n, number of speech sources: ma
[~, ~, mb]=size(RIR_noise); % number of noise sources: mb

[audio1_samples, fs_audio1] = audioread(filename{1});
[audio2_samples, fs_audio2] = audioread(filename{2});
audio1_samples = resample(audio1_samples,fs_RIR, fs_audio1);
audio2_samples = resample(audio2_samples,fs_RIR, fs_audio2);

speech = zeros(mic_samples, n);
babble = zeros(mic_samples, n);
for i=1:n
    for j=1:ma
        mic_speech= fftfilt(RIR_sources(:,i,j),audio1_samples);
        speech(:,i)= speech(:,i) + mic_speech(1:mic_samples);
    end
    if (~isempty(RIR_noise))
        for j=1:mb
            mic_noise= fftfilt(RIR_noise(:,i,j),audio2_samples);
            babble(:,i)= babble(:,i) + mic_noise(1:mic_samples);
        end
    end
end

VAD=abs(speech(:,1))>std(speech(:,1))*1e-3;
pow_mic1 = var(speech(VAD==1,1));
noise = wgn(mic_samples, n, 10*log10(0.1*pow_mic1));

SNR_in = 10*log10(pow_mic1./(var(babble(:,1)) + var(noise(:,1))));

mic = speech + babble + noise;
save('mic', 'speech', 'noise', 'SNR_in', 'mic');

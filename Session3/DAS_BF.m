MUSIC_wideband
[~, index] = min(abs(DOA_est - 90));
DOA_target = DOA_est(index);


d = m_pos(1,2) - m_pos(:,2);
c = 340;
theta=DOA_target*pi/180;
D_est = round(cos(theta)*(fs_RIR*d)/c);
shifted_mic = zeros(size(mic));
shifted_speech = zeros(size(mic));
shifted_babble = zeros(size(mic));
DAS_out=zeros(mic_samples,1);
DAS_speech=zeros(mic_samples,1);
DAS_babble=zeros(mic_samples,1);
for i=1:n
    shift = max(D_est)-D_est(i)+1;
    shifted_mic(:,i) = [mic(shift:end,i)' zeros(1,shift-1)]';
    DAS_out = DAS_out + shifted_mic(:,i);
    shifted_speech(:,i) = [speech(shift:end,i)' zeros(1,shift-1)]';
    DAS_speech = DAS_speech + shifted_speech(:,i);
    shifted_babble(:,i) = [babble(shift:end,i)' zeros(1,shift-1)]';
    DAS_babble = DAS_babble + shifted_babble(:,i);
end
error=max(abs(DAS_out-(DAS_speech+DAS_babble)));
DAS_out=DAS_out/n;
DAS_speech=DAS_speech/n;
DAS_babble=DAS_babble/n;
VAD1=abs(DAS_speech)>std(DAS_speech)*1e-3;
pow_DAS_speech = var(DAS_speech(VAD1==1,1));
SNR_out_DAS=10*log10(pow_DAS_speech./var(DAS_babble));
figure
plot(mic(:,1),'b')
hold on
plot(DAS_out,'r')
hold off

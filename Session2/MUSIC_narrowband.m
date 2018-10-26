%create_micsigs
[M, ~] = size(m_pos);
L = 1024;
F = 1000;

s = zeros(M,ceil(F/2)+1, ceil(length(mic)/L*2)-2);
for i=1:M
    temp = spectrogram(mic(:,i),L,L/2,F);
    s(i,:,:) = temp;
end
figure
spectrogram(mic(:,1),L,L/2,F);

s_power = abs(s).^2;
s_avg_pow = mean(mean(s_power,3),1);
[mx, index] = max(s_avg_pow);



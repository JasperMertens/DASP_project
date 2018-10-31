create_micsigs_add
[M, ~] = size(m_pos);
[Q, ~] = size(s_pos);
L = 1024;
F = 1024;

% Generate the spectrogram
% s dimensions: [microphones x frequency x time]
s = zeros(M,ceil((F+1)/2), ceil(length(mic)/L*2)-2);
for i=1:M
    temp = spectrogram(mic(:,i),L,L/2,F);
    s(i,:,:) = temp;
end
figure
spectrogram(mic(:,1),L,L/2,F);

% Average over time and microphones and select the maximum energy bin
s_power = abs(s).^2;
s_avg_pow = mean(mean(s_power,3),1);
[mx, index] = max(s_avg_pow);
rad_freq = (index-1)*pi/(length(s_avg_pow)-1);
% freq=(index/(pi*length(s_avg_pow)))*fs_RIR/2;
% rad_freq = 2*pi*freq;

% Calculate the steering vector
angles = (0:0.5:180)./180*pi;
d = m_pos(1,2)*ones(M,1) - m_pos(1:M,2);
c = 340;
tau=d*cos(angles)*(fs_RIR/c);
G = exp(-1j*rad_freq*tau);

% Autocorrelation matrix and eigenvectors
s_freq = squeeze(s(:,index,:));
R = s_freq*s_freq';
[V,D] = eig(R);
E = V(:,1:M-Q);
p = 1./diag(G'*E*E'*G);

% DOA estimation
figure
plot(0:0.5:180,abs(p))
% hold on
% stem([DOA_est DOA_est],[0 500],'r')

[pks,locs] = findpeaks(abs(p),0:0.5:180);
[sorted_pks, index_vec] = sort(pks,'descend');
sorted_locs = locs(index_vec);
DOA_est = sorted_locs(1:Q);
save('DOA_est.mat', 'DOA_est');


create_micsigs_add
[M, ~] = size(m_pos);
[Q, ~] = size(s_pos);
L = 1024;
F = 1000;

% Generate the spectrogram
s = zeros(M,ceil(L/2)+1, ceil(length(mic)/L*2)-2);
for i=1:M
    temp = spectrogram(mic(:,i),hann(L),L/2,L);
    s(i,:,:) = temp;
end
figure
spectrogram(mic(:,1),L,L/2,L);

% freq = (2:L/2)*pi/(L/2);
index = 2:L/2;
rad_freq = (index-1)*pi/(size(s,2)-1);
% Calculate the steering vector
angles = (0:0.5:180)./180*pi;
d = m_pos(1,2)*ones(M,1) - m_pos(1:M,2);
c = 340;
tau=d*cos(angles)*(fs_RIR/c);

p=zeros(length(angles),length(rad_freq));
% Autocorrelation matrix and eigenvectors
s_freq = s(:,2:L/2,:);
p_avg = zeros(length(angles),1);
for f=1:length(rad_freq)
G = exp(-1j*rad_freq(f)*tau);
s_aux = squeeze(s_freq(:,f,:));
R = s_aux*s_aux';
[V,D] = eig(R);
E = V(:,1:M-Q);
p(:,f) = 1./diag(G'*E*E'*G);
p_avg = p_avg + log(1./diag(G'*E*E'*G));
end

p_avg = exp(p_avg./(L/2-1));
% DOA estimation
[pks,locs] = findpeaks(abs(p_avg),0:0.5:180);
[sorted_pks, index_vec] = sort(pks,'descend');
sorted_locs = locs(index_vec);
DOA_est = sorted_locs(1:Q);
save('DOA_est.mat', 'DOA_est');

figure
plot(0:0.5:180,abs(p_avg))

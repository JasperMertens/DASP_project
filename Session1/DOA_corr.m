TDOA_corr 
d = m_pos(1,2) - m_pos(2,2);
c = 340;
theta=acos(D_est*c/(fs_RIR*d));
DOA_est = theta*180/pi;
hor_d = m_pos(1,1) - s_pos(1);
ver_d = m_pos(1,2) - s_pos(2);
DOA_true = atan(hor_d/ver_d)*180/pi+90;
save('DOA_est.mat', 'DOA_est');
function [bitrate_baseStation_mps] = ParetoDistribution(People_to_cover,alfa, taxa_min_mbps,taxa_real_mbps)

% %calcular o melhor fit do alfa ! 
% alfa = 1:1:3;
% taxa_min = 1:1:5; % bitrate min por user mbps
% 
% taxa_real = 250;
% 
% for i=1:length(alfa)
%     u = (alfa(i) .* (taxa_min).^alfa(i))./ (taxa_min .^(alfa(i)+1));
%     plot(taxa_min,u);
%     hold on;
% end

% calcular a largura total para aquele bitrate que queremos 

mean = (alfa*taxa_min_mbps)/(alfa-1); 
bitrate_baseStation_mps  = People_to_cover * mean;




% % 20% são user pesados 
% % 80% são lever 
% 
% tmp_20 = 0.2 * Antenna5G * taxa_real
% tmp_80 = 0.8 * Antenna5G * taxa_min
% 
% largura_band_total = tmp_80 + tmp_20
% 
% 
% num_max_user = largura_band_total / mean




end
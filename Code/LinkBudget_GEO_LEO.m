%**************************************************************************
% PAPER: Network Simulation of 5G Non-Terrestrial Networks
% AUTHOR: Marco Araújo, Adriano Goes
% CREATE: dez-2023
% LAST UPDATE: 2023-12-13
% VERSION: 1.0
% RELEASE: 1A
%**************************************************************************

%**************************************************************************
% Startup system  
%**************************************************************************
clear;
close all;
warning('off', 'all');

%**************************************************************************
% Specifc Parameters
%**************************************************************************
c = physconst('LightSpeed'); %Light speed in m/s

% Load the table
load('Link_NTN_Table.mat');

d = 32700-600; % Satellite altitude in Km

%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************

% Load Band variables
KBand = Link_NTN_Table(strcmp(Link_NTN_Table.Band, 'K'), :);
KaBand = Link_NTN_Table(strcmp(Link_NTN_Table.Band, 'Ka'), :);

Selected_Bands = { 'K: 19GHz', 'Ka: 28GHz' };

fc = KBand.Frequency_GHz*1e9;
lambda = c/fc;
L = fspl(d,lambda);

K_LP = 20*log10(KBand.Frequency_GHz) + 20*log10(d) + 92.45; 
Ka_LP = 20*log10(KaBand.Frequency_GHz) + 20*log10(d) + 92.45; 

%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0 - KBand.F;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0 - KaBand.F;  

K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );

K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

K_Throughtput = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

%**************************************************************************
% Plot results
%**************************************************************************
% figure();
% plot(RainFall, K_LP, '--xk', RainFall, Ka_LP, '-.sk');
% legend(Selected_Bands, 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
% set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
% set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
% set(gca, 'FontSize', 12); % Set the font size for the axes
% xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
% ylabel('Pathloss [dB]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
% title(['Pathloss over Rainfalls for different Bands in (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
% grid on
% 
% figure();
% plot(RainFall, K_Throughtput/1e9, '--xk', RainFall, Ka_Throughtput/1e9, '-.sk');
% legend(Selected_Bands, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
% set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
% set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
% set(gca, 'FontSize', 12); % Set the font size for the axes
% xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
% ylabel('Upperbound Throughput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
% title(['Upperbound Throughput over Rainfalls and Bands for (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
% grid on




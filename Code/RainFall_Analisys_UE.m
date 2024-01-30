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

% Load the table
load('FrequenciesTable.mat');

RainFall = 0:5:50; % RainFall in mm/h
el_angle = 30; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 1200; % Satellite altitude in Km

%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************
h0 = 3; %Freezing level altitude in Km for Europe

TypeLink = 'UL';

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);

% Study for all bands in UL/DL
% Selected_Bands_UL = { 'S: 30MHz - UL', 'K: 2.1GHz - UL', 'Ka: 2.1GHz - UL' };
% Selected_Bands_DL = { 'S: 30MHz - DL', 'K: 2.5GHz - DL', 'Ka: 2.5GHz - DL' };


% Study for bands in the scenarios (a) and (b) in Fig4 of paper 
Selected_Bands_UL = { 'S: 30MHz - UL','Ka: 2.1GHz - UL' };
Selected_Bands_DL = { 'S: 30MHz - DL', 'K: 2.5GHz - DL' };

S_LP = zeros(1,length(RainFall));
K_LP = zeros(1,length(RainFall));
Ka_LP = zeros(1,length(RainFall));

for i=1:length(RainFall)

    A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    S_LP(i) = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle) - A;

    A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    K_LP(i) = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle) - A;   

    A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    Ka_LP(i) = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle) - A; 

end

%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
S_N0 = ReceiveNoisePower(SBand.Bandwidth, SBand.T, SBand.F);
S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP) - S_N0;

K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T, KBand.F);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T, KaBand.F);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0; 

S_CI =  10 * log10(power(10, -SBand.CI_int/10) + power(10, -SBand.CI_ext/10) );
K_CI =  10 * log10(power(10, -KBand.CI_int/10) + power(10, -KBand.CI_ext/10) );
Ka_CI =  10 * log10(power(10, -KaBand.CI_int/10) + power(10, -KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

%**************************************************************************
% Plot results
%**************************************************************************
% figure();
% plot(RainFall, S_LP, '-dk', RainFall, K_LP, '--xk', RainFall, Ka_LP, '-.sk');
% legend(Selected_Bands, 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
% set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
% set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
% set(gca, 'FontSize', 12); % Set the font size for the axes
% xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
% ylabel('Pathloss [dB]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
% %title(['Pathloss over Rainfalls for different Bands in (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
% grid on


% % Study for all bands in UL/DL
% figure();
% plot(RainFall, S_Throughtput/1e9, '-dk', RainFall, K_Throughtput/1e9, '--xk', RainFall, Ka_Throughtput/1e9, '-.sk');
% lgd = legend(Selected_Bands_UL, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
% set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
% set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
% set(gca, 'FontSize', 12); % Set the font size for the axes
% xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
% ylabel('Upperbound Throughput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
% grid on

% Study for bands in the scenarios (a) and (b) in Fig4 of paper 
figure();
plot(RainFall, S_Throughtput/1e9, '-dk', RainFall, Ka_Throughtput/1e9, '-.sk');
lgd = legend(Selected_Bands_UL, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Upperbound Throughput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
grid on

title(lgd, 'Bandwidth');

hold on

TypeLink = 'DL';

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);

S_LP = zeros(1,length(RainFall));
K_LP = zeros(1,length(RainFall));
Ka_LP = zeros(1,length(RainFall));

for i=1:length(RainFall)

    A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    S_LP(i) = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle) - A;

    A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    K_LP(i) = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle) - A;   

    A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    Ka_LP(i) = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle) - A; 

end

%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
S_N0 = ReceiveNoisePower(SBand.Bandwidth, SBand.T, SBand.F);
S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP) - S_N0;

K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T, KBand.F);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T, KaBand.F);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0;  

S_CI =  10 * log10(power(10, -SBand.CI_int/10) + power(10, -SBand.CI_ext/10) );
K_CI =  10 * log10(power(10, -KBand.CI_int/10) + power(10, -KBand.CI_ext/10) );
Ka_CI =  10 * log10(power(10, -KaBand.CI_int/10) + power(10, -KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

%**************************************************************************
% Plot results
%**************************************************************************
% % Study for all bands in UL/DL
% plot(RainFall, S_Throughtput/1e9, '-dr', RainFall, K_Throughtput/1e9, '--xr', RainFall, Ka_Throughtput/1e9, '-.sr');
% legend([Selected_Bands_UL, Selected_Bands_DL], 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size


% Study for bands in the scenarios (a) and (b) in Fig4 of paper 
plot(RainFall, S_Throughtput/1e9, '-dr', RainFall, K_Throughtput/1e9, '--xr');
legend([Selected_Bands_UL, Selected_Bands_DL], 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size






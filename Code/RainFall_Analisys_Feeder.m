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
TypeLink = 'UL/DL';

% Load the table
load('FrequenciesTable.mat');

RainFall = 0:5:50; % RainFall in mm/h
el_angle = 30; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 32780; % Satellite altitude in Km

%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************
h0 = 3; %Freezing level altitude in Km for Europe

% Load Band variables
QBandUL = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Q') & strcmp(FrequenciesTable.Direction, 'UL'), :);
QBandDL = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Q') & strcmp(FrequenciesTable.Direction, 'DL'), :);

Selected_Bands = { 'Q - UL: 50GHz', 'Q - DL: 40GHz' };

Q_LP_UL = zeros(1,length(RainFall));
Q_LP_DL = zeros(1,length(RainFall));

for i=1:length(RainFall)

    A = Calculate_A_Factor(QBandUL.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    Q_LP_UL(i) = SatelliteFreePathloss(QBandUL.Frequency_GHz , h, el_angle) - A;

    A = Calculate_A_Factor(QBandDL.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
    Q_LP_DL(i) = SatelliteFreePathloss(QBandDL.Frequency_GHz , h, el_angle) - A;

end

%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
Q_N0_UL = ReceiveNoisePower(QBandUL.Bandwidth, QBandUL.T, QBandUL.F);
Q_CN_UL = (QBandUL.Pt + QBandUL.Gt + QBandUL.Gr + Q_LP_UL) - Q_N0_UL;

Q_N0_DL = ReceiveNoisePower(QBandDL.Bandwidth, QBandDL.T, QBandDL.F);
Q_CN_DL = (QBandDL.Pt + QBandDL.Gt + QBandDL.Gr + Q_LP_DL) - Q_N0_DL;

Q_CI_UL = 10 * log10(power(10, QBandUL.CI_int/10) + power(10, QBandUL.CI_ext/10) );
Q_CNI_UL = Q_CN_UL - Q_CI_UL;
Q_Throughtput_UL = QBandUL.Bandwidth * log2(1 + dBm_to_mW(Q_CNI_UL));

Q_CI_DL = 10 * log10(power(10, QBandDL.CI_int/10) + power(10, QBandDL.CI_ext/10) );
Q_CNI_DL = Q_CN_DL - Q_CI_DL;
Q_Throughtput_DL = QBandDL.Bandwidth * log2(1 + dBm_to_mW(Q_CNI_DL));

%**************************************************************************
% Plot results
%**************************************************************************
% figure();
% plot(RainFall, Q_LP_UL, '-dk');
% legend(Selected_Bands, 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
% set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
% set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
% set(gca, 'FontSize', 12); % Set the font size for the axes
% xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
% ylabel('Feeder Pathloss [dB]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
% %title(['Feeder Pathloss over Rainfalls for different Bands in (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
% grid on

figure();
plot(RainFall, Q_Throughtput_UL/1e9, '--dk', RainFall, Q_Throughtput_DL/1e9, '-sk');
legend(Selected_Bands, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Feeder Upperbound Throughput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
%title(['Feeder Upperbound Throughput over Rainfalls and Bands for (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on




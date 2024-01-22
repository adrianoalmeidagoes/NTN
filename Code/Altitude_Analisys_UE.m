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
TypeLink = 'UL';

% Load the table
load('FrequenciesTable.mat');

RainFall = 0; % RainFall in mm/h
el_angle = 30; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 300:100:1500; % Satellite altitude in Km

%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************
h0 = 3; %Freezing level altitude in Km

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);

Selected_Bands = { 'S: 2.1GHz', 'K: 19GHz', 'Ka: 28GHz' };

S_LP = zeros(1,length(h));
K_LP = zeros(1,length(h));
Ka_LP = zeros(1,length(h));

for i=1:length(h)

    A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
    S_LP(i) = SatelliteFreePathloss(SBand.Frequency_GHz , h(i), el_angle) - A;

    A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
    K_LP(i) = SatelliteFreePathloss(KBand.Frequency_GHz , h(i), el_angle) - A;   

    A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
    Ka_LP(i) = SatelliteFreePathloss(KaBand.Frequency_GHz , h(i), el_angle) - A; 

end

%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
S_N0 = ReceiveNoisePower(SBand.Bandwitdh, SBand.T);
S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP) - S_N0 - SBand.F;

K_N0 = ReceiveNoisePower(KBand.Bandwitdh, KBand.T);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0 - KBand.F;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwitdh, KaBand.T);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0 - KaBand.F;  

S_CI = 10 * log10(power(10, SBand.CI_int/10) + power(10, SBand.CI_ext/10) );
K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput = SBand.Bandwitdh * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput = KBand.Bandwitdh * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput = KaBand.Bandwitdh * log2(1 + dBm_to_mW(Ka_CNI));

%**************************************************************************
% Plot results
%**************************************************************************
figure();
plot(h, S_LP, '-dk', h, K_LP, '--xk', h, Ka_LP, '-.sk');
legend(Selected_Bands, 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Satellite Altitude [km]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Pathloss [dB]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
%title(['Pathloss over Altitudes for different Bands in (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on
hold off

figure();
plot(h, S_Throughtput/1e9, '-dk', h, K_Throughtput/1e9, '--xk', h, Ka_Throughtput/1e9, '-.sk');
legend(Selected_Bands, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Satellite Altitude [km]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Upperbound Throughput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
%title(['Upperbound Throughput over Altitudes and Bands for (', TypeLink, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on
hold off



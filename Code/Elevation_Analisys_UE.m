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
el_angle = 10:5:80; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 600; % Satellite altitude in Km

%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************
h0 = 3; %Freezing level altitude in Km

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);

Selected_Bands_UL = { 'S: 30MHz - UL', 'K: 2.1GHz - UL', 'Ka: 2.1GHz - UL' };
Selected_Bands_DL = { 'S: 30MHz - DL', 'K: 2.5GHz - DL', 'Ka: 2.5GHz - DL' };

S_LP = zeros(1,length(el_angle));
K_LP = zeros(1,length(el_angle));
Ka_LP = zeros(1,length(el_angle));

for i=1:length(el_angle)

    A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall, h0, el_angle(i), tilt_angle);
    S_LP(i) = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle(i)) - A;

    A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall, h0, el_angle(i), tilt_angle);
    K_LP(i) = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle(i)) - A;   

    A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall, h0, el_angle(i), tilt_angle);
    Ka_LP(i) = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle(i)) - A; 

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

S_CI = 10 * log10(power(10, SBand.CI_int/10) + power(10, SBand.CI_ext/10) );
K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

%**************************************************************************
% Plot results
%**************************************************************************

figure();
plot(el_angle, S_Throughtput/1e9, '-dk', el_angle, K_Throughtput/1e9, '--xk', el_angle, Ka_Throughtput/1e9, '-.sk');
legend(Selected_Bands_UL, 'Location', 'southeast', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Satellite Elevation Angle [degree]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Upperbound Throughput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
grid on

hold on

%**************************************************************************
% NTN parameters Downlink
%**************************************************************************
TypeLink = 'DL';

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);

S_LP = zeros(1,length(el_angle));
K_LP = zeros(1,length(el_angle));
Ka_LP = zeros(1,length(el_angle));

for i=1:length(el_angle)

    A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall, h0, el_angle(i), tilt_angle);
    S_LP(i) = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle(i)) - A;

    A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall, h0, el_angle(i), tilt_angle);
    K_LP(i) = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle(i)) - A;   

    A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall, h0, el_angle(i), tilt_angle);
    Ka_LP(i) = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle(i)) - A; 

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

S_CI = 10 * log10(power(10, SBand.CI_int/10) + power(10, SBand.CI_ext/10) );
K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

%**************************************************************************
% Plot results
%**************************************************************************
plot(el_angle, S_Throughtput/1e9, '-dr', el_angle, K_Throughtput/1e9, '--xr', el_angle, Ka_Throughtput/1e9, '-.sr');
legend([Selected_Bands_UL, Selected_Bands_DL], 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size




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
TypeLink = {'UL', 'DL'};

% Load the table
load('FrequenciesTable.mat');

RainFall = 0:5:50; % RainFall in mm/h
el_angle = 30; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 600; % Satellite altitude in Km

%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************
h0 = 3; %Freezing level altitude in Km

Selected_Bands = { 'S', 'K', 'Ka' };

S_LP = zeros(1,length(RainFall));
K_LP = zeros(1,length(RainFall));
Ka_LP = zeros(1,length(RainFall));

S_Throughtput = zeros(1,length(RainFall));
K_Throughtput = zeros(1,length(RainFall));
Ka_Throughtput = zeros(1,length(RainFall));

for iTypeLink=1:2

    % Load Band variables
    SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink{iTypeLink}), :);
    KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink{iTypeLink}), :);
    KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink{iTypeLink}), :);
    
    for i=1:length(RainFall)
    
        A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
        S_LP(iTypeLink, i) = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle) - A;
    
        A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
        K_LP(iTypeLink, i) = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle) - A;   
    
        A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall(i), h0, el_angle, tilt_angle);
        Ka_LP(iTypeLink, i) = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle) - A; 
    
    end
    
    %**************************************************************************
    % Calculate carrier (C) to noise (N) ratio
    %**************************************************************************
    S_N0 = ReceiveNoisePower(SBand.Bandwidth, SBand.T);
    S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP(iTypeLink, :)) - S_N0 - SBand.F;
    
    K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T);
    K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP(iTypeLink, :)) - K_N0 - KBand.F;  
    
    Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T);
    Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP(iTypeLink, :)) - Ka_N0 - KaBand.F;  
    
    S_CI = 10 * log10(power(10, SBand.CI_int/10) + power(10, SBand.CI_ext/10) );
    K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
    Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );
    
    S_CNI = S_CN - S_CI;
    K_CNI = K_CN - K_CI;
    Ka_CNI = Ka_CN - Ka_CI;
    
    S_Throughtput(iTypeLink, :) = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
    K_Throughtput(iTypeLink, :) = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
    Ka_Throughtput(iTypeLink,:) = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));
end

%**************************************************************************
% Plot results
%**************************************************************************
figure();
subplot(1,2,1);
plot(RainFall, S_LP(1,:), '-dk', RainFall, K_LP(1,:), '-xk', RainFall, Ka_LP(1,:), '-sk');
legend(Selected_Bands, 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Pathloss [dB]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
title(['Pathloss over Rainfalls for different Bands in (', TypeLink{1}, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on

subplot(1,2,2);
plot(RainFall, S_LP(2,:), '-.dk', RainFall, K_LP(2,:), '-.xk', RainFall, Ka_LP(2,:), '-.sk');
legend(Selected_Bands, 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Pathloss [dB]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
title(['Pathloss over Rainfalls for different Bands in (', TypeLink{2}, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on

figure();
subplot(1,2,1);
plot(RainFall, S_Throughtput(1,:)/1e9, '-dk', RainFall, K_Throughtput(1,:)/1e9, '-xk', RainFall, Ka_Throughtput(1,:)/1e9, '-sk');
legend(Selected_Bands, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Upperbound Throughtput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
title(['Upperbound Throughtput over Rainfalls and Bands for (', TypeLink{1}, ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on

subplot(1,2,2);
plot(RainFall, S_Throughtput(2,:)/1e9, '-.dk', RainFall, K_Throughtput(2,:)/1e9, '-.xk', RainFall, Ka_Throughtput(2,:)/1e9, '-.sk');
legend(Selected_Bands, 'Location', 'southwest', 'FontName', 'Times New Roman', 'FontSize', 12); % Legend with font and size
set(gca, 'GridLineStyle', '--'); % Set the grid line style to dashed
set(gca, 'FontName', 'Times New Roman'); % Set the font type for the axes
set(gca, 'FontSize', 12); % Set the font size for the axes
xlabel('Rainfall [mm/h]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the x-axis
ylabel('Upperbound Throughtput [Gbps]', 'FontName', 'Times New Roman', 'FontSize', 14); % Label for the y-axis
title(['Upperbound Throughtput over Rainfalls and Bands for (', TypeLink{2} , ')'], 'FontName', 'Times New Roman', 'FontSize', 14); % Title of the graph
grid on



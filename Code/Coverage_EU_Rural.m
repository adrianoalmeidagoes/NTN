%**************************************************************************
% PAPER: Network Simulation of 5G Non-Terrestrial Networks
% AUTHOR: Marco Araújo, Adriano Goes, Bruno Mendes
% CREATE: Jan-2024
% LAST UPDATE: 2024-01-22
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

c = physconst("LightSpeed");
Boltz = physconst("Boltzmann");
RainFall = 40; % RainFall in mm/h
el_angle = 30; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 1557; % Satellite altitude in Km
Re = 6371; % Earth Radius  in km


%**************************************************************************
% NTN parameters Uplink/Downlink
%**************************************************************************
h0 = 3; %Freezing level altitude in Km for Europe

TypeLink = 'UL';

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);

Selected_Bands_UL = { 'S: 2.1GHz - UL', 'K: 19GHz - UL', 'Ka: 28GHz - UL' };
Selected_Bands_DL = { 'S: 2.1GHz - DL', 'K: 19GHz - DL', 'Ka: 28GHz - DL' };





A = Calculate_A_Factor(SBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
S_LP = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle) - A;

A = Calculate_A_Factor(KBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
K_LP = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle) - A;   

A = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
Ka_LP = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle) - A; 


%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
S_N0 = ReceiveNoisePower(SBand.Bandwidth, SBand.T);
S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP) - S_N0 - SBand.F;

K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0 - KBand.F;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0 - KaBand.F;  

S_CI = 10 * log10(power(10, SBand.CI_int/10) + power(10, SBand.CI_ext/10) );
K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput_UL = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput_UL = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput_UL = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));




TypeLink = 'DL';

% Load Band variables
SBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'S') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'K') & strcmp(FrequenciesTable.Direction, TypeLink), :);
KaBand = FrequenciesTable(strcmp(FrequenciesTable.Band, 'Ka') & strcmp(FrequenciesTable.Direction, TypeLink), :);




A_S = Calculate_A_Factor(SBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
S_LP = SatelliteFreePathloss(SBand.Frequency_GHz , h, el_angle) - A_S;

A_K = Calculate_A_Factor(KBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
K_LP = SatelliteFreePathloss(KBand.Frequency_GHz , h, el_angle) - A_K;   

A_Ka = Calculate_A_Factor(KaBand.Frequency_GHz, RainFall, h0, el_angle, tilt_angle);
Ka_LP = SatelliteFreePathloss(KaBand.Frequency_GHz , h, el_angle) - A_Ka; 



%**************************************************************************
% Calculate carrier (C) to noise (N) ratio
%**************************************************************************
S_N0 = ReceiveNoisePower(SBand.Bandwidth, SBand.T);
S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP) - (S_N0 - SBand.F);

K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0 - KBand.F;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0 - KaBand.F;  

S_CI = 10 * log10(power(10, SBand.CI_int/10) + power(10, SBand.CI_ext/10) );
K_CI = 10 * log10(power(10, KBand.CI_int/10) + power(10, KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, KaBand.CI_int/10) + power(10, KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput_DL = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput_DL = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput_DL = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));


%**************************************************************************
% Calculate Number of beans nb
% Gt    =   % Assign the value for transmitter antenna gain 54 dBi 36.9 dB;
% Re    =   % Assign the value for the earth radius;
% theta =   % Assign the value for elevation angle;
% h     =   % Assign the value for high of the satellite;
% 
% % Formula for Nb
% Nb = (Gt * Re^2 * (1 - cosd(theta))) / (2 * h^2);
%**************************************************************************
% perguntar se é para usar em radianos ----- 
Nb_S_DL = (SBand.Gt * Re^2 * (1 - cosd(el_angle))) / (2 * h^2);

Nb_K_DL = (KBand.Gt * Re^2 * (1 - cosd(el_angle))) / (2 * h^2);

%**************************************************************************
% Calculate Number of frequencies used
% optimal value would be 4
%**************************************************************************
Nf_S_DL = 4 ;

Nf_K_DL = 4;




%**************************************************************************
% Calculate Number of number of bits M transmitted per symbol
% SNR =   % Assign the value for SNR;
% M = log10(10^((SNR - 10 * log10(3/2))/10))/2;
%**************************************************************************

%snr 

% Lp = 20 * log10((4 * pi * SBand.Frequency_GHz * 1e9) / c ) + 20 * log10(h);
% Pr = 60 + 54 + 0 - Lp - A_S;
% n0 = 10 * log10(Boltz * 290 ) + 10 * log10(SBand.Bandwidth) + 8 + 30;
% 
% Snr_S = Pr - n0;

% Perguntar se é o snr ... 
M_S = (log2(10^((S_CNI - 10 * log10(3/2))/10)))/2;

M_K = (log2(10^((K_CNI - 10 * log10(3/2))/10)))/2;




%**************************************************************************
% Calculate capacity bits/s
% phi =  % Assign the value for  frequency non-overlap factor;
% Nb =   % Assign the value for number of beans;
% Nf =   % Assign the value for numer of frequencies;
% M =    % Assign the value for number of bits M transmitted in a symbol;
% B =    % Assign the value for bandwith used;
%
% C = phi * (Nb / Nf) * M * B;
%**************************************************************************

phi = 2/3; % overlap in about 25% to 50% 

C_S = (phi * (Nb_S_DL / Nf_S_DL) * M_S * SBand.Bandwidth)/1e9;

C_K = phi * (Nb_K_DL / Nf_K_DL) * M_K * KBand.Bandwidth/1e9;


%**************************************************************************
% Calculate the coverage angle of the satellites
% A =       % Assign the value for the coverage Area;
% Re =      % Assign the value for the earth radius;
% theta =   % Assign the value for elevation angle;
% P =       % Assign the value for number of passages needed to cover a given region;
% 
%  A / (2 * pi * Re^2 * (1 - cos(acos(cosd(theta) / cosd(180 / P))))) <= 1;
% 
% 
%**************************************************************************

A = 10530000; % km² area da europa

A = 10530000 * 0.05;


P = 180/(acos(cosd(el_angle)/(cosd(acosd(1-(A/(2*pi*(Re^2))))))));

% A / (2 * pi * Re^2 * (1 - cos(acos(cosd(el_angle) / cosd(180 / P))))) <= 1;

%**************************************************************************
% Calculate the total number of satellites in the constellation
% N =   % Assign the number of satellites in the constellation
% n =   % Assign the number of satellites in each circumference
% H =   % Assign the value of subscrivers; 
% C =   % Assign the bitrate Capacity;
% R =   % Assign the Individual bitrate - 250mbps
% P =   % Assign the value for number of passages needed to cover a given region;
% 
%
% n = H*R / C;
%
% N = n * P;
%**************************************************************************

R = 0.100; % 100 mbps per house
% 109 persons per $km^2$ in the EU in 2022
% 449 * 10^6 pessoas na EU
% 2.3 persons per household
H = (449*10^6 * 0.05) / 2.3; % media de numero de casas na Europa



n_S =  H * R / C_S;

n_K =  H * R / C_K;


N_S = n_S * P;

N_K = n_K * P;



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
el_angle = 36.5; % Elevation angle of the satellite in degrees
tilt_angle = 45; % Tilt angle of the antenna in degrees
h = 1200; % Satellite altitude in Km
Re = physconst("EarthRadius")/1e3; % Earth Radius  in km
A = 10530000; % km² area da europa
%Houses_covered = (((449*10^6 * 0.05)/400) / 2.3); % media de numero de 5% de casas na Europa servidas por antenas 5G que combrem no minimo 400 UE
max_bandwidth = 100; % 100 mbps per user


Antenna5G_radius = 4; % 4km de raio de cobertura
Antenna5G_coverage = pi * Antenna5G_radius^2; % area de cobertura
People_Rural_Zones = 102 * 0.05; % people on rural zones per km2
People_per_Antenna5G = ceil(Antenna5G_coverage * People_Rural_Zones); 
Houses_covered = (((449*10^6 * 0.05)/People_per_Antenna5G) / 2.3);
% bits per base station 5G
min_bitrate = 10; % min bitrate per user
max_bitrate = 100; % max bitrate per user 
alfa = 3;
R = ParetoDistribution(People_per_Antenna5G,alfa,min_bitrate,max_bitrate);



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
S_N0 = ReceiveNoisePower(SBand.Bandwidth, SBand.T, SBand.F);
S_CN = (SBand.Pt + SBand.Gt + SBand.Gr + S_LP) - S_N0;

K_N0 = ReceiveNoisePower(KBand.Bandwidth, KBand.T, KBand.F);
K_CN = (KBand.Pt + KBand.Gt + KBand.Gr + K_LP) - K_N0;  

Ka_N0 = ReceiveNoisePower(KaBand.Bandwidth, KaBand.T, KaBand.F);
Ka_CN = (KaBand.Pt + KaBand.Gt + KaBand.Gr + Ka_LP) - Ka_N0;  

S_CI = 10 * log10(power(10, -SBand.CI_int/10) + power(10, -SBand.CI_ext/10) );
K_CI = 10 * log10(power(10, -KBand.CI_int/10) + power(10, -KBand.CI_ext/10) );
Ka_CI = 10 * log10(power(10, -KaBand.CI_int/10) + power(10, -KaBand.CI_ext/10) );

S_CNI = S_CN - S_CI;
K_CNI = K_CN - K_CI;
Ka_CNI = Ka_CN - Ka_CI;

S_Throughtput_UL = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput_UL = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput_UL = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

% [N_k_UL,n_k_UL] = CalculateSatelites_Circunference_Belt(KBand.Gt,el_angle,h,K_CNI,KBand.Bandwidth,A,Houses_covered,max_bandwidth,"UL_K",R);
[N_ka_UL,n_ka_UL] = CalculateSatelites_Circunference_Belt(KaBand.Gt,el_angle,h,Ka_CNI,KaBand.Bandwidth,Ka_Throughtput_UL,A,Houses_covered,max_bandwidth,"UL_Ka",R);

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

S_Throughtput_DL = SBand.Bandwidth * log2(1 + dBm_to_mW(S_CNI));
K_Throughtput_DL = KBand.Bandwidth * log2(1 + dBm_to_mW(K_CNI));
Ka_Throughtput_DL = KaBand.Bandwidth * log2(1 + dBm_to_mW(Ka_CNI));

[N_k_DL,n_k_DL] = CalculateSatelites_Circunference_Belt(KBand.Gt,el_angle,h,K_CNI,KBand.Bandwidth,K_Throughtput_DL,A,Houses_covered,max_bandwidth, "DL_K",R);
% [N_ka_DL,n_ka_DL] = CalculateSatelites_Circunference_Belt(KaBand.Gt,el_angle,h,K_CNI,KaBand.Bandwidth,A,Houses_covered,max_bandwidth, "DL_Ka",R);



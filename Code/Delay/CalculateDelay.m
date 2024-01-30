%**************************************************************************
% PAPER: Network Simulation of 5G Non-Terrestrial Networks
% AUTHOR: Bruno Mendes
% CREATE: Jan-2024
% LAST UPDATE: 2024-01-30
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
load('../FrequenciesTable.mat');
load('ResourceBlock.mat');
load('UECapability.mat');

% PDSCH mapping type A
% FDD of type DUDUDU (one downlink slot after a uplink slot)
% Grant-free schduling delay
f0 = 15; % 15khz subcarrier spacing minimo
delta_f = 30;
h_sat = 600; % in km
L = 14; %number of symbols 


u = (delta_f/f0)-1;
u_capability = UECapability(UECapability.u == u, :);
slot_lenth = (L/14)*(1/(2^u)); % in ms 
TTi = slot_lenth; % approximaly the value of slot length

t_proc1 = time_procedure(u_capability.UE2_N1,u); % in seconds
t_proc2 = time_procedure(u_capability.UE2_N2,u); % in seconds


t_proc_gNB_rx = t_proc1/2;% in seconds
t_procUE_rx = t_proc1/2;% in seconds

t_proc_gNB_tx = t_proc2/2;% in seconds
t_procUE_tx = t_proc2/2;% in seconds


t_propag_UL = CalculateTimePropagation(h_sat); % in seconds
t_propag_DL = CalculateTimePropagation(h_sat); % in seconds


% Tfa = TFA + twait 
twait = ((L-4) * (((L/14) * (1 /2^u)) / L) + ((L/14) * ( 1  / 2^u))) * 10e-3; % in seconds 
% twait = 0;
%scenario (a) in seconds

t_UL_a = t_procUE_tx + t_propag_UL + twait + t_proc_gNB_rx;
t_DL_a = t_proc_gNB_tx + t_propag_DL + twait + t_procUE_rx;


%scenario (b) in seconds

t_UL_b = t_procUE_tx + t_propag_UL + twait ; 
t_DL_b = t_propag_DL + twait + t_procUE_rx;


fprintf('Scenario A \n');
fprintf('Latency for UL: %.6f\n', t_UL_a);
fprintf('Latency for DL: %.6f\n', t_DL_a);
fprintf('Scenario B \n');
fprintf('Latency for UL: %.6f\n', t_UL_b);
fprintf('Latency for DL: %.6f\n', t_DL_b);


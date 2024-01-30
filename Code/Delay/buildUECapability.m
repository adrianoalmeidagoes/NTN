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
UECapabilityStructure(1).u = 0;
UECapabilityStructure(1).UE1_N1 = 8;
UECapabilityStructure(1).UE1_N2 = 10;
UECapabilityStructure(1).UE2_N1 = 3;
UECapabilityStructure(1).UE2_N2 = 5; 

UECapabilityStructure(2).u = 1;
UECapabilityStructure(2).UE1_N1 = 10;
UECapabilityStructure(2).UE1_N2 = 12;
UECapabilityStructure(2).UE2_N1 = 4.5;
UECapabilityStructure(2).UE2_N2 = 5.5; 

UECapabilityStructure(3).u = 2;
UECapabilityStructure(3).UE1_N1 = 17;
UECapabilityStructure(3).UE1_N2 = 23;
UECapabilityStructure(3).UE2_N1 = 9;
UECapabilityStructure(3).UE2_N2 = 11; 

UECapabilityStructure(4).u = 3;
UECapabilityStructure(4).UE1_N1 = 20;
UECapabilityStructure(4).UE1_N2 = 36;
UECapabilityStructure(4).UE2_N1 = 0;
UECapabilityStructure(4).UE2_N2 = 0; 



UECapability = struct2table(UECapabilityStructure);

save('UECapability.mat', "UECapability");
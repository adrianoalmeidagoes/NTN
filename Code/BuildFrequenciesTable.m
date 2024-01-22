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
% Update table with new column  
%**************************************************************************

% % Load the table from the .mat file
% load('data.mat');  % Assumes the table in the file is named T
% 
% % Add a new column
% newColumnData = [100; 101; 102];  % Example data, adjust the length as needed
% T.NewColumn = newColumnData;  % 'NewColumn' is the name of the new column
% 
% % Display the updated table
% disp(T);
% 
% % Save the updated table to a .mat file
% save('updated_data.mat', 'T');

%**************************************************************************
% Specifc Parameters
%**************************************************************************
FrequenciesStructure(1).Band = 'L';
FrequenciesStructure(1).Direction = 'UL';
FrequenciesStructure(1).Frequency_GHz = 1.6;
FrequenciesStructure(1).Pt = 30; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(1).Gt = 3; % UE Antenna Gain TX in dBi
FrequenciesStructure(1).Gr = 54; % Antenna Gain TX in dBi
FrequenciesStructure(1).F = 8; % Receiver noise figure
FrequenciesStructure(1).T = 290; %Receiver antenna temperature in Kelvin
FrequenciesStructure(1).CI_int = 3; % internal interference
FrequenciesStructure(1).CI_ext = 8; % external interference
FrequenciesStructure(1).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(2).Band = 'L';
FrequenciesStructure(2).Direction = 'DL';
FrequenciesStructure(2).Frequency_GHz = 1.6;
FrequenciesStructure(2).Pt = 53; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(2).Gt = 54; % UE Antenna Gain TX in dBi
FrequenciesStructure(2).Gr = 3; % Antenna Gain TX in dBi
FrequenciesStructure(2).F = 3; % Receiver noise figure
FrequenciesStructure(2).T = 50; %Receiver antenna temperature in Kelvin
FrequenciesStructure(2).CI_int = 3; % internal interference
FrequenciesStructure(2).CI_ext = 8; % external interference
FrequenciesStructure(2).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(3).Band = 'S';
FrequenciesStructure(3).Direction = 'UL';
FrequenciesStructure(3).Frequency_GHz = 2.1;
FrequenciesStructure(3).Pt = 30; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(3).Gt = 3; % UE Antenna Gain TX in dBi
FrequenciesStructure(3).Gr = 54; % Antenna Gain TX in dBi
FrequenciesStructure(3).F = 8; % Receiver noise figure
FrequenciesStructure(3).T = 290; %Receiver antenna temperature in Kelvin
FrequenciesStructure(3).CI_int = 3; % internal interference
FrequenciesStructure(3).CI_ext = 8; % external interference
FrequenciesStructure(3).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(4).Band = 'S';
FrequenciesStructure(4).Direction = 'DL';
FrequenciesStructure(4).Frequency_GHz = 2.1;
FrequenciesStructure(4).Pt = 53; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(4).Gt = 54; % UE Antenna Gain TX in dBi
FrequenciesStructure(4).Gr = 3; % Antenna Gain TX in dBi
FrequenciesStructure(4).F = 3; % Receiver noise figure
FrequenciesStructure(4).T = 50; %Receiver antenna temperature in Kelvin
FrequenciesStructure(4).CI_int = 3; % internal interference
FrequenciesStructure(4).CI_ext = 8; % external interference
FrequenciesStructure(4).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(5).Band = 'K';
FrequenciesStructure(5).Direction = 'UL';
FrequenciesStructure(5).Frequency_GHz = 19;
FrequenciesStructure(5).Pt = 30; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(5).Gt = 3; % UE Antenna Gain TX in dBi
FrequenciesStructure(5).Gr = 54; % Antenna Gain TX in dBi
FrequenciesStructure(5).F = 8; % Receiver noise figure
FrequenciesStructure(5).T = 290; %Receiver antenna temperature in Kelvin
FrequenciesStructure(5).CI_int = 3; % internal interference
FrequenciesStructure(5).CI_ext = 8; % external interference
FrequenciesStructure(5).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(6).Band = 'K';
FrequenciesStructure(6).Direction = 'DL';
FrequenciesStructure(6).Frequency_GHz = 19;
FrequenciesStructure(6).Pt = 53; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(6).Gt = 54; % UE Antenna Gain TX in dBi
FrequenciesStructure(6).Gr = 3; % Antenna Gain TX in dBi
FrequenciesStructure(6).F = 3; % Receiver noise figure
FrequenciesStructure(6).T = 50; %Receiver antenna temperature in Kelvin
FrequenciesStructure(6).CI_int = 3; % internal interference
FrequenciesStructure(6).CI_ext = 8; % external interference
FrequenciesStructure(6).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(7).Band = 'Ka';
FrequenciesStructure(7).Direction = 'UL';
FrequenciesStructure(7).Frequency_GHz = 28;
FrequenciesStructure(7).Pt = 30; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(7).Gt = 3; % UE Antenna Gain TX in dBi
FrequenciesStructure(7).Gr = 54; % Antenna Gain TX in dBi
FrequenciesStructure(7).F = 8; % Receiver noise figure
FrequenciesStructure(7).T = 290; %Receiver antenna temperature in Kelvin
FrequenciesStructure(7).CI_int = 3; % internal interference
FrequenciesStructure(7).CI_ext = 8; % external interference
FrequenciesStructure(7).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(8).Band = 'Ka';
FrequenciesStructure(8).Direction = 'DL';
FrequenciesStructure(8).Frequency_GHz = 28;
FrequenciesStructure(8).Pt = 53; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(8).Gt = 54; % UE Antenna Gain TX in dBi
FrequenciesStructure(8).Gr = 3; % Antenna Gain TX in dBi
FrequenciesStructure(8).F = 3; % Receiver noise figure
FrequenciesStructure(8).T = 50; %Receiver antenna temperature in Kelvin
FrequenciesStructure(8).CI_int = 3; % internal interference
FrequenciesStructure(8).CI_ext = 8; % external interference
FrequenciesStructure(8).Bandwitdh = 500e6; % Bandwidth in Hz

FrequenciesStructure(9).Band = 'Q';
FrequenciesStructure(9).Direction = 'UL';
FrequenciesStructure(9).Frequency_GHz = 40;
FrequenciesStructure(9).Pt = 30; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(9).Gt = 4.5; % UE Antenna Gain TX in dBi
FrequenciesStructure(9).Gr = 54; % Antenna Gain TX in dBi
FrequenciesStructure(9).F = 3; % Receiver noise figure
FrequenciesStructure(9).T = 290; %Receiver antenna temperature in Kelvin
FrequenciesStructure(9).CI_int = 3; % internal interference
FrequenciesStructure(9).CI_ext = 8; % external interference
FrequenciesStructure(9).Bandwitdh = 2e9; % Bandwidth in Hz

FrequenciesStructure(10).Band = 'Q';
FrequenciesStructure(10).Direction = 'DL';
FrequenciesStructure(10).Frequency_GHz = 40;
FrequenciesStructure(10).Pt = 30; % Equivalent isotropic radiated power in dBm
FrequenciesStructure(10).Gt = 4.5; % UE Antenna Gain TX in dBi
FrequenciesStructure(10).Gr = 54; % Antenna Gain TX in dBi
FrequenciesStructure(10).F = 3; % Receiver noise figure
FrequenciesStructure(10).T = 290; %Receiver antenna temperature in Kelvin
FrequenciesStructure(10).CI_int = 3; % internal interference
FrequenciesStructure(10).CI_ext = 8; % external interference
FrequenciesStructure(10).Bandwitdh = 2e9; % Bandwidth in Hz

FrequenciesTable = struct2table(FrequenciesStructure);

save('FrequenciesTable.mat', "FrequenciesTable");
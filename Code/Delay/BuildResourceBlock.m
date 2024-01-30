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
ResourceBlockStructure(1).SCS = 15;
ResourceBlockStructure(1).MHZ_5 = 25;
ResourceBlockStructure(1).MHZ_10 = 52;
ResourceBlockStructure(1).MHZ_15 = 79; 
ResourceBlockStructure(1).MHZ_20 = 106; 


ResourceBlockStructure(2).SCS = 30;
ResourceBlockStructure(2).MHZ_5 = 11;
ResourceBlockStructure(2).MHZ_10 = 24;
ResourceBlockStructure(2).MHZ_15 = 38; 
ResourceBlockStructure(2).MHZ_20 = 51; 


ResourceBlockStructure(3).SCS = 60;
ResourceBlockStructure(3).MHZ_5 = 0;
ResourceBlockStructure(3).MHZ_10 = 11;
ResourceBlockStructure(3).MHZ_15 = 18; 
ResourceBlockStructure(3).MHZ_20 = 24; 


ResourceBlock = struct2table(ResourceBlockStructure);

save('ResourceBlock.mat', "ResourceBlock");

%**************************************************************************
% Startup system  
%**************************************************************************
clear;
close all;
warning('off', 'all');

% Data from Table 1 Rec. ITU-R P.838-3
index = 1:4;
aj = [-5.33980; -0.35351; -0.35351; -0.94158];
bj = [-0.10008; 1.26970; 0.86036; 0.64552];
cj = [1.13098; 0.45400; 0.15354; 0.16817];

j = index';

% Create a Table
Gamma_H = table(j, aj, bj, cj);

save("Gamma_H.mat", "Gamma_H");

%==========================================================================

% Data from Table 2 Rec. ITU-R P.838-3
aj = [-3.80595; -3.44965; -0.39902; 0.50167];
bj = [0.56934; -0.22911; 0.73042; 1.07319];
cj = [0.81061; 0.51059; 0.11899; 0.27195];

% Create a Table
Gamma_V = table(j, aj, bj, cj);

save("Gamma_V.mat", "Gamma_V");

%==========================================================================

% Data from Table 3 Rec. ITU-R P.838-3
index = 1:5;
aj = [-0.14318; 0.29591; 0.32177; -5.37610; 16.1721];
bj = [1.82442; 0.77564; 0.63773; -0.96230; -3.29980];
cj = [-0.55187; 0.19822; 0.13164; 1.47828; 3.43990];

j = index';

% Create a Table
Beta_H = table(j, aj, bj, cj);

save("Beta_H.mat", "Beta_H");

%==========================================================================

% Data from Table 4 Rec. ITU-R P.838-3
aj = [-0.07771; 0.56727; -0.20238; -48.2991; 48.5833];
bj = [2.33840; 0.95545; 1.14520; 0.791669; 0.791459];
cj = [-0.76284; 0.54039; 0.26809; 0.116226; 0.116479];

j = index';

% Create a Table
Beta_V = table(j, aj, bj, cj);

save("Beta_V.mat", "Beta_V");



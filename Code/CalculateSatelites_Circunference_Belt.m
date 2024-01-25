function [N,n] = CalculateSatelites_Circunference_Belt(Gt,el_angle,h,SNR,Bandwith_hz,Area, Houses,maxBandwidth_User_mbps)

Re = physconst("EarthRadius")/1e3; % Earth Radius  in km

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

Nb = (Gt * Re^2 * (1 - cosd(el_angle))) / (2 * h^2);



%**************************************************************************
% Calculate Number of frequencies used
% optimal value would be 4
%**************************************************************************
Nf = 4 ;



%**************************************************************************
% Calculate Number of number of bits M transmitted per symbol
% SNR =   % Assign the value for SNR;
% M = log10(10^((SNR - 10 * log10(3/2))/10))/2;
%**************************************************************************

M = (log2(10^((SNR - 10 * log10(3/2))/10)))/2;



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

C = (phi * (Nb / Nf) * M * Bandwith_hz)/1e6;




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


P = Satellite_Passages(h);


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



R = Calculate_MeanR(Houses,maxBandwidth_User_mbps); % return the mean usage of network by user 



n =  Houses * R / C;



N = n * P;

fprintf('Number of satellites with band S per circunference %.2f\n', n);
fprintf('Number of satellites with band S per belt %.2f\n', N);


end
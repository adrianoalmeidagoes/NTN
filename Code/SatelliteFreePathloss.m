
%**************************************************************************
% Calculate Free Space Pathloss from Satellite to UE 
% Parameters:
%       fc: Frequency in GHz
%       h: Satellite altitude in km
%       el_angle: Elevation angle in degree 
% Results:
%       LP: Signal Loss in dBs
%**************************************************************************

function LP = SatelliteFreePathloss(fc, h, el_angle)

    EarthRadiusInMeters = physconst('EarthRadius'); %Earth Radius in meters;
    EarthRadiusInKm = EarthRadiusInMeters / 1000;
    %c = physconst('LightSpeed'); %Light speed in m/s
    %lambda = (fc*1e9) / c;
    
    % tmp1 = (4*pi*fc*EarthRadiusInKm);
    % 
    % tmp2 = sqrt(power((EarthRadiusInKm+h)/EarthRadiusInKm,2) - power(cos(deg2rad(el_angle)),2)) - sin(deg2rad(el_angle));
    % 
    % tmp3 = tmp1 * tmp2;
    % 
    % tmp4 = tmp3/3e-4;
    % 
    % tmp5 = -20 * log10(tmp4);


    LP = -20 * log10( (((4*pi*fc*EarthRadiusInKm) * (sqrt(power((EarthRadiusInKm+h)/EarthRadiusInKm, 2) - power(cosd(el_angle), 2)) - sind(el_angle))))/3e-4);

    %LP = - (20 * log10((4*pi*fc*1e9)/c) + 20*log10(h*1e3));

end


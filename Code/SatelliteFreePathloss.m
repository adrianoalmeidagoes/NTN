
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
    c = physconst('LightSpeed'); %Light speed in m/s
    lambda = (fc * 1e9) / c;

    LP = -20 * log10( ((4*pi*lambda*EarthRadiusInMeters) * (sqrt(power((EarthRadiusInKm+h)/EarthRadiusInKm, 2) - power(cos(deg2rad(el_angle)), 2)) - sin(deg2rad(el_angle)))));

end


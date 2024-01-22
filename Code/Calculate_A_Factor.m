%**************************************************************************
% Calculate A attenuation value for rain intensity 
% Parameters:
%       fc: Frequency in GHz
%       R: Rain intensity in mm/h
%       h0: is the freezing level altitude
%       el_angle: Elevation angle of satellite
%       tilt_angle: Tilt angle of antenna (45º for circular polarization)
% Results:
%       A: A attenuation value in dB
%**************************************************************************

function A = Calculate_A_Factor(fc, R, h0, el_angle, tilt_angle)

    Gamma_H = Calculate_Gamma(fc, 'H');
    Gamma_V = Calculate_Gamma(fc, 'V');

    Beta_H = Calculate_Beta(fc, 'H');
    Beta_V = Calculate_Beta(fc, 'V');  

    el_angle = deg2rad(el_angle);
    tilt_angle = deg2rad(tilt_angle);

    Gamma = ( Gamma_H + Gamma_V + ( (Gamma_H - Gamma_V)*power(cos(el_angle),2)*cos(2*tilt_angle)) ) / 2;

    Beta = ((Gamma_H*Beta_H) + (Gamma_V*Beta_V) + ( ((Gamma_H*Beta_H) - (Gamma_V*Beta_V)) * power(cos(el_angle),2)*cos(2*tilt_angle) )) / (2*Gamma);
    hr = (h0 + 0.36);
    
    A = hr*(Gamma*power(R, Beta));

end
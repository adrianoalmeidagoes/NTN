function P = Satellite_Passages(AltitudeInKm)

    earthRotation = (23*3600) + (56*60) + 4.1; %86164.1 seconds; 
    earthRadius = physconst("EarthRadius");

    G= 6.67430e-11; % gravitational constant
    M = 5.972e24; % mass of the Earth

    h = AltitudeInKm * 1000; %meters
    r = earthRadius + h;
    T = 2*pi/sqrt(G*M/(r^3)); % orbital period

    P = earthRotation/T;  

end
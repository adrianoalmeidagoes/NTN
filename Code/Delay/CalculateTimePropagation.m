function [propag_time] = CalculateTimePropagation(h_sat)

earth_radius = physconst("EarthRadius"); % in meters
ligth_speed = physconst("LightSpeed"); % in m/s

distance = earth_radius + h_sat*10^3;

propag_time = distance/ligth_speed;


end


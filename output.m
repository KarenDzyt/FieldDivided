function [P_latlon] = output(p_log,p_lat)
% Converts radians to degrees.
 DegToRad = @(x)(x / pi * 180.0);
 
 P_lat = DegToRad(p_lat);
 P_lon = DegToRad(p_log);
 P_latlon = [P_lon ,P_lat];
end
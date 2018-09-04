function [P_latlon] = UTMtoWGS84(x,y,UTMCentralMeridian_result,s_or_n)
    S_unit = ones(1,1);
    UTMCentralMeridian_S = UTMCentralMeridian_result * S_unit; 
    [x1,y1] = UTMXYToLatLon(x,y,s_or_n);
    [lon,lat] = MapXYToLatLon(x1,y1,UTMCentralMeridian_S);
    [P_latlon] = output(lon,lat);
end


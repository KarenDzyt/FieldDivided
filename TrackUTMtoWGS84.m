function [Track] = TrackUTMtoWGS84(x,y,UTMCentralMeridian_result,s_or_n)
    n = length(x);
    S_unit = ones(n,1);
    UTMCentralMeridian_S = UTMCentralMeridian_result * S_unit; 
    [x1,y1] = UTMXYToLatLon(x,y,s_or_n);
    [s_log,s_lat] = MapXYToLatLon(x1,y1,UTMCentralMeridian_S);
    [Track] = output(s_log,s_lat);
end


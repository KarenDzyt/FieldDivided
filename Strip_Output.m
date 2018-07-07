    %UTMתWGS84
    R_unit = ones(4,1);
    Strip_unit = ones(numOfstrip,1);
    UTMCentralMeridian_R = UTMCentralMeridian_result * R_unit; 
    UTMCentralMeridian_Strip = UTMCentralMeridian_result * Strip_unit;

    [xr,yr] = UTMXYToLatLon(rectx,recty,s_or_n);
    [xs1,ys1] = UTMXYToLatLon(sx1,sy1,s_or_n);
    [xs2,ys2] = UTMXYToLatLon(sx2,sy2,s_or_n);
    [xs3,ys3] = UTMXYToLatLon(sx3,sy3,s_or_n);
    [xs4,ys4] = UTMXYToLatLon(sx4,sy4,s_or_n);

    [r_log,r_lat] = MapXYToLatLon(xr,yr,UTMCentralMeridian_R);
    [sp1_log,sp1_lat] = MapXYToLatLon(xs1,ys1,UTMCentralMeridian_Strip); 
    [sp2_log,sp2_lat] = MapXYToLatLon(xs2,ys2,UTMCentralMeridian_Strip); 
    [sp3_log,sp3_lat] = MapXYToLatLon(xs3,ys3,UTMCentralMeridian_Strip); 
    [sp4_log,sp4_lat] = MapXYToLatLon(xs4,ys4,UTMCentralMeridian_Strip); 

    Rect_latlon = output(r_log,r_lat);
    p1_latlon = output(sp1_log,sp1_lat);
    p2_latlon = output(sp2_log,sp2_lat);
    p3_latlon = output(sp3_log,sp3_lat);
    p4_latlon = output(sp4_log,sp4_lat);
    Strip_latlon = [p1_latlon,p2_latlon,p3_latlon,p4_latlon];
%轨迹点UTM转为WGS84

Track_LatLon = cell(1,n1);
for i=1:n1
    nt1 = length(px{i});
    S_unit = ones(nt1,1);
    UTMCentralMeridian_S = UTMCentralMeridian_result * S_unit; 
    [px1,py1] = UTMXYToLatLon(px{i},py{i},s_or_n);
    [s_log,s_lat] = MapXYToLatLon(px1,py1,UTMCentralMeridian_S);
    Track_LatLon{i} = output(s_log,s_lat);
end


%WGS84轨迹点输出
    m = 0;
for i=1:n1
    n2(i) =length(Track_LatLon{i});
    for j=1:n2(i)
        m = m+1;
        output1(m,1)= Track_LatLon{i}(i,1);
        output1(m,2)= Track_LatLon{i}(i,2);
    end
end  
xlswrite('output1.xlsx',output1);



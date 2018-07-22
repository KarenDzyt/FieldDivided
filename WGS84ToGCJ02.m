function[track2] = WGS84ToGCJ02(track1)
nn = length(track1);
track2 = zeros(nn,2);
    for i=1:nn
        [track2(i,1),track2(i,2)] = Single_WGS84ToGCJ02(track1(i,1),track1(i,2));
    end
end

function[glon,glat] = Single_WGS84ToGCJ02(wlon,wlat)
    a = 6378245.0;
    ee = 0.00669342162296594323;
    dLat = transformLat(wlon - 105.0, wlat - 35.0);
    dLon = transformLon(wlon - 105.0, wlat - 35.0);
    radLat = wlat / 180.0 * pi;
    magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    glat = wlat + dLat;
    glon = wlon + dLon;
end

function[ret] = transformLat(x,y)
    ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret = ret + (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret = ret + (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret = ret + (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
end

function[ret] = transformLon(x,y)
        ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
        ret = ret + (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
        ret = ret + (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
        ret = ret + (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
end
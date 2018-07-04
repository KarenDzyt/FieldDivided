
clear all;

 %从excel中读取数据 
 data='003';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1); %[num, txt]= xlsread(filename, ...)
 lon=a(:,2);
 lat=a(:,1);
 
 %划分条带幅宽
 width = 8;
 %基准线来源工序幅宽
 width0 = 0;
 
 global numOfPoints;
 numOfPoints = length(lon);
 
% % Ellipsoid model constants (actual values here are for WGS84)
 global sm_a;
 global sm_b;
 global sm_EccSquared;
 global UTMScaleFactor;
 sm_a = 6378137.0;
 sm_b = 6356752.314;
 sm_EccSquared = 6.69437999013e-03;
 UTMScaleFactor = 0.9996;

% Converts degrees to radians
DegToRad = @(x)(x / 180 * pi);
lon_radian=DegToRad(lon);
lat_radian=DegToRad(lat);

% Calculate the zone of the point
zone = fix((lon + 180)/ 6) + 1;

% Determines the central meridian for the given UTM zone.
% The central meridian for the given UTM zone, in radians, or zero
% if the UTM zone parameter is outside the range [1,60].
% Range of the central meridian is the radian equivalent of [-177,+177].
UTMCentralMeridian =(-183 + (zone * 6)) / 180 * pi; 
    
[x1,y1] = MapLatLonToXY(lon_radian,lat_radian,UTMCentralMeridian);

[x,y,southhemi] = LatLonToUTMXY(x1,y1);

%农田内的点默认在同一个半球，公用中央经线
s_or_n = southhemi(1);
UTMCentralMeridian_result = UTMCentralMeridian(1);

%对农田顶点进行排序
Field1 = [x(1),y(1)];
Field2 = [x(2),y(2)];
Field3 = [x(3),y(3)];
Field4 = [x(4),y(4)];
Field =[Field1;Field2;Field3;Field4];

A0 = [x(5),y(5)];
B0 = [x(6),y(6)];
[r1,r3] = nearorfar_Point(A0(1),A0(2),Field(:,1),Field(:,2));
[r2,r4] = nearorfar_Point(B0(1),B0(2),Field(:,1),Field(:,2));
Field = [Field(r1,:);Field(r2,:);Field(r3,:);Field(r4,:)];

%这个方法匹配不上
% if(r1==1)
% else if(r1==2)
%         Field = [Field(2,:);Field(3,:);Field(4,:);Field(1,:)];
%     else if(r1==3)
%             Field = [Field(3,:);Field(4,:);Field(1,:);Field(2,:)];
%         else
%             Field = [Field(4,:);Field(1,:);Field(2,:);Field(3,:)];
%         end
%     end
% end


%AB线平移到基准线
angle = atan2(y(5)-y(6),x(5)-x(6))- pi/2;
ax1 = x(5)+width0*cos(angle)/2;
ay1 = y(5)+width0*sin(angle)/2;
bx1 = x(6)+width0*cos(angle)/2;
by1 = y(6)+width0*sin(angle)/2;

ax2 = x(5)-width0*cos(angle)/2;
ay2 = y(5)-width0*sin(angle)/2;
bx2 = x(6)-width0*cos(angle)/2;
by2 = y(6)-width0*sin(angle)/2;

da1 = distance(ax1,ay1,Field(1,1),Field(1,2));
da2 = distance(ax2,ay2,Field(1,1),Field(1,2));
if(da1>da2)
    A = [ax2,ay2];
    B = [bx2,by2];
else
    A = [ax1,ay1];
    B = [bx1,by1]; 
end

%AB线与农田边界构成的新四边形
Polygon = [A;B;Field(3,:);Field(4,:)];
xp = Polygon(:,1);
yp = Polygon(:,2);

%农田条带划分
[rectx,recty,strip,p,Px,Py] = Strip(xp,yp,width);
%农田包络矩形
Rect =[rectx,recty];



%绘制外接矩形
plot(rectx,recty,'r');
hold on;
scatter(Px,Py,1);
hold on;


sx1 = strip(:,1);sx2 = strip(:,3);
sx3 = strip(:,5);sx4 = strip(:,7);
sy1 = strip(:,2);sy2 = strip(:,4);
sy3 = strip(:,6);sy4 = strip(:,8);       

numOfstrip = length(sx1);
R_unit = ones(4,1);
Strip_unit = ones(numOfstrip,1);
UTMCentralMeridian_R = UTMCentralMeridian_result * R_unit; 
UTMCentralMeridian_Strip = UTMCentralMeridian_result * Strip_unit;
X = zeros(5,numOfstrip);
Y = zeros(5,numOfstrip);

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

%绘图
for i=1:numOfstrip
    X(:,i) = [sx1(i);sx2(i);sx3(i);sx4(i);sx1(i)];
    Y(:,i) = [sy1(i);sy2(i);sy3(i);sy4(i);sy1(i)];
    plot(X(:,i),Y(:,i),'b');
    hold on;
end
field = [Field(1,:);Field(2,:);Field(3,:);Field(4,:);Field(1,:)];
plot(rectx,recty,'r');
hold on;
plot(field(:,1),field(:,2),'k');
hold on;
scatter(A(1),A(2));
hold on;
scatter(B(1),B(2));
hold on;
scatter(A0(1),A0(2));
hold on;
scatter(B0(1),B0(2));
hold on;




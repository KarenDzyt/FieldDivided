
clear all;

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
 
 %从excel中读取数据 
 data='001';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1); %[num, txt]= xlsread(filename, ...)
 lon=a(:,2);
 lat=a(:,1);
 
 width =2.8; %划分条带幅宽
 width0 = 0; %基准线来源工序幅宽
 
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
FieldSort;
%AB线平移到基准线
AB_move;

%AB线与农田边界构成的新四边形
Polygon = [A;B;Field(3,:);Field(4,:)];
xp = Polygon(:,1);
yp = Polygon(:,2);

%农田条带划分
[rectx,recty,strip,px,py,Px,Py] = Strip(xp,yp,width);
%农田包络矩形
Rect =[rectx,recty];

%筛除不在农田内的轨迹点

%整体筛除
% xv = [x(1),x(2),x(3),x(4),x(1)];
% yv = [y(1),y(2),y(3),y(4),y(1)];
% in=inpolygon(Px,Py,xv,yv);

%绘制外接矩形
% plot(rectx,recty,'r');
% hold on;
% scatter(Px,Py,1,in);
% hold on;

%分段筛除
xv = [x(1),x(2),x(3),x(4),x(1)];
yv = [y(1),y(2),y(3),y(4),y(1)];
n1 = length(px);
n2 = length(px{1});
in=cell(1,n1);

for i=1:n1
    in{i}=inpolygon(px{i},py{i},xv,yv);
    no_track(i) = i; %记录轨迹编号
    z = 0; %防止删除元素造成索引混乱
    for j=1:n2
       if in{i}(j)==0
           px{i}(j-z)=[];
           py{i}(j-z)=[];
           z = z+1;
       end
    end
end

%刨除10S的轨迹点用来生成调头点
for i=1:n1
    for j=1:10
         nt = length(px{i});
         px{i}(1)=[];
         py{i}(1)=[];
         px{i}(nt-1)=[];
         py{i}(nt-1)=[];
    end
end

ux1 = {};ux2 = {};uy1 = {};uy2 = {};
for i=1:2:n1-2
    L1 = length(px{i});  
    L2 = length(px{i+1}); 
    [ux2{i},uy2{i}] = U_turnup(px{i}(L1),py{i}(L1),px{i+1}(L2),py{i+1}(L2),3,width,20);
    [ux1{i},uy1{i}] = U_turndown(px{i+1}(1),py{i+1}(1),px{i+2}(1),py{i+2}(1),3,width,20);
    scatter(ux1{i},uy1{i},1,'black');
    scatter(ux2{i},uy2{i},1,'black');
    hold on;
end
%取实部
% ux_r = real(ux);
% uy_r = real(uy);

for i=1:n1
    scatter(px{i},py{i},1,'g');
    hold on;
end

%绘图
Draw_Strips;

%WGS84轨迹点输出
%Track_Output;

%条带UTM转为WGS84
% Strip_Output;

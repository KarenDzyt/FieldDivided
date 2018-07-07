
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
 
 %��excel�ж�ȡ���� 
 data='001';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1); %[num, txt]= xlsread(filename, ...)
 lon=a(:,2);
 lat=a(:,1);
 
 width =2.8; %������������
 width0 = 0; %��׼����Դ�������
 
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
%ũ���ڵĵ�Ĭ����ͬһ�����򣬹������뾭��
s_or_n = southhemi(1);
UTMCentralMeridian_result = UTMCentralMeridian(1);

%��ũ�ﶥ���������
FieldSort;
%AB��ƽ�Ƶ���׼��
AB_move;

%AB����ũ��߽繹�ɵ����ı���
Polygon = [A;B;Field(3,:);Field(4,:)];
xp = Polygon(:,1);
yp = Polygon(:,2);

%ũ����������
[rectx,recty,strip,px,py,Px,Py] = Strip(xp,yp,width);
%ũ��������
Rect =[rectx,recty];

%ɸ������ũ���ڵĹ켣��

%����ɸ��
% xv = [x(1),x(2),x(3),x(4),x(1)];
% yv = [y(1),y(2),y(3),y(4),y(1)];
% in=inpolygon(Px,Py,xv,yv);

%������Ӿ���
% plot(rectx,recty,'r');
% hold on;
% scatter(Px,Py,1,in);
% hold on;

%�ֶ�ɸ��
xv = [x(1),x(2),x(3),x(4),x(1)];
yv = [y(1),y(2),y(3),y(4),y(1)];
n1 = length(px);
n2 = length(px{1});
in=cell(1,n1);

for i=1:n1
    in{i}=inpolygon(px{i},py{i},xv,yv);
    no_track(i) = i; %��¼�켣���
    z = 0; %��ֹɾ��Ԫ�������������
    for j=1:n2
       if in{i}(j)==0
           px{i}(j-z)=[];
           py{i}(j-z)=[];
           z = z+1;
       end
    end
end

%�ٳ�10S�Ĺ켣���������ɵ�ͷ��
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
%ȡʵ��
% ux_r = real(ux);
% uy_r = real(uy);

for i=1:n1
    scatter(px{i},py{i},1,'g');
    hold on;
end

%��ͼ
Draw_Strips;

%WGS84�켣�����
%Track_Output;

%����UTMתΪWGS84
% Strip_Output;

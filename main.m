
clear all;
 
%��excel�ж�ȡ���� 
 data='001';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1); %[num, txt]= xlsread(filename, ...)
 lon=a(:,2);
 lat=a(:,1);
 
 width =3.25; %������������
 width0 = 0.0; %��׼����Դ�������
 r = 3;%��ͷ�뾶
 n0 = 2; %�����ڳ�����
 frequency =1;%�ϴ�Ƶ��
 v = 3;%��ҵ�ٶ�
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
[rectx,recty,strip,px,py,Px,Py] = Strip(xp,yp,width,v,frequency);
%ũ��������
Rect =[rectx,recty];

%ɸ������ũ���ڵĹ켣��

%����ɸ��
% xv = [x(1),x(2),x(3),x(4),x(1)];
% yv = [y(1),y(2),y(3),y(4),y(1)];
% in=inpolygon(Px,Py,xv,yv);

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

%�ٳ�ʱ��Ϊt_turn�Ĺ켣���������ɵ�ͷ��
t_turn = fix(10.0/frequency);
for i=1:n1
    for j=1:t_turn
         nt = length(px{i});
         px{i}(1)=[];
         py{i}(1)=[];
         px{i}(nt-1)=[];
         py{i}(nt-1)=[];
    end
end
track=[];
head=cell(1,2);
head{1,1}='lon';
head{1,2}='lat';
for i=1:n0
[track{i}(:,1),track{i}(:,2)] = Track(n0,i,px,py,width,r,t_turn,'r');
[track{i}] = TrackUTMtoWGS84(track{i}(:,1),track{i}(:,2),UTMCentralMeridian_result,s_or_n);
[track{i}] = WGS84ToGCJ02(track{i});
data=['track',num2str(i),'.xlsx'];
xlswrite(data,head(1,1),1,'A1');
xlswrite(data,head(1,2),1,'B1');
xlswrite(data,track{i},1,'A2');
end


%��ͼ
Draw_Strips;

%WGS84�켣�����
%Track_Output;

% ����UTMתΪWGS84
Strip_Output;

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

%基准线平移后得到的AB线转WGS84
[A_latlon] = UTMtoWGS84(A(1),A(2),UTMCentralMeridian_result,s_or_n);
[B_latlon] = UTMtoWGS84(B(1),B(2),UTMCentralMeridian_result,s_or_n);

%写入excel
xlswrite(data1,A_latlon,'A7:B7');
xlswrite(data1,B_latlon,'A8:B8');
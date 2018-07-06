function [ux,uy] = U_turn(x1,y1,x2,y2,r,width,n)
%计算圆的参数方程
d_12 = distance(x1,y1,x2,y2);
k_12 = (y2-y1)/(x2-x1);
%12的中心垂线方程
x12 = (x2+x1)/2;
y12 = (y2+y1)/2;
%圆心角(第一象限)
theta = 2*asind(d_12/2/r);
% 调头半径过小时
if width<3
theta = 360 - theta;
end
% %圆半径过大时
% if r>width/2
%     r = width/2;
% end
%圆心坐标
   if k_12 == 0
      x0 = x12;
      y0 = y12 - r*cosd(theta/2);
   else
       b12 = y12 - x12 * (-1/k_12);
       x0 = x12 + r*cosd(theta/2)*cosd(atand(-1/k_12));
       y0 = -1/k_12*x0 + b12;
   end
%1，2对应参数方程的横坐标
theta1 = acosd((x1-x0)/r);
theta11 = 360 - theta1;
theta2 = acosd((x2-x0)/r);
theta21 = 360 - theta2;
theta0 = theta/(n+1);
flag = 1;
if theta1>theta2
    flag=0;
else
    flag=1;
end
ux = zeros(n,1);
uy = zeros(n,1);
% d1= distance(x0,y0,x1,y1);
% d2= distance(x0,y0,x2,y2);
scatter(x0,y0,20,'r');
hold on;
scatter(x1,y1,20,'g');
hold on;
scatter(x2,y2,20,'b');
hold on;
for i=1:n
    if (flag==1)
        ux(i)= x0 + r * cosd(theta1+theta0*i);
        uy(i)= y0 + r * sind(theta1+theta0*i);
    else
        ux(i)= x0 + r * cosd(theta11+theta0*i);
        uy(i)= y0 + r * sind(theta11+theta0*i);
    end
%     dt(i)= distance(x0,y0,ux(i),uy(i));
%     scatter(ux(i),uy(i),1,'black');
%     hold on;
end
end

function [d]=distance(x1,y1,x2,y2)
         d = sqrt((x1-x2).^2 + (y1-y2).^2);
end
function [ux,uy] = U_turnup(x1,y1,x2,y2,r,width,n)
%圆半径过小时
if r<width/2
    r = width/2;
end

%计算圆的参数方程
d_12 = distance(x1,y1,x2,y2);
k_12 = (y2-y1)/(x2-x1);
b_12 = y1 - k_12 * x1;
k_ = -1/k_12;
ak = atand(k_);
%12的中心垂线方程
x12 = (x2+x1)/2;
y12 = (y2+y1)/2;
%圆心角(第一象限)
theta = 2*asind(d_12/2/r);
% 调头半径过小时
flag1 =0;
if width<3
theta = 360 - theta;
flag1 =1;
end
%圆心坐标
   if k_12 == 0
      x0up = x12;
      x0down = x12;
      y0down = y12 - abs(r*cosd(theta/2));
      y0up= y12 + abs(r*cosd(theta/2));
   else
       b12 = y12 - x12 * (-1/k_12);
       x0up = x12 + abs(r*cosd(theta/2)*cosd(ak));
       x0down = x12 - abs(r*cosd(theta/2)*cosd(ak));
       y0up = -1/k_12*x0up + b12;
       y0down = -1/k_12*x0down + b12;
   end
%判断原点的位置

if y0up<y12
    t1 = x0up;
    t2 = y0up;
    y0up = y0down;
    x0up = x0down;
    x0down = t1;
    y0down = t2;
end

  if theta>180
    x0 = x0up;
    y0 = y0up;
  else
    x0 = x0down;
    y0 = y0down;
  end

%1，2对应参数方程的横坐标
theta1 = acosd((x1-x0)/r);
theta11 = 360 - theta1;
theta2 = acosd((x2-x0)/r);
theta21 = 360 - theta2;
theta0 = theta/(n+1);
flag = 1;
if flag1 ==0
    if theta1>theta2
         flag=1;
    else
         flag=0;
    end
else
    if theta1>theta2
        flag=0;
    else
        flag=1;
    end
end

ux = zeros(n,1);
uy = zeros(n,1);
scatter(x0,y0,20,'r');
hold on;
scatter(x1,y1,20,'g');
hold on;
scatter(x2,y2,20,'b');
hold on;

for i=1:n
    if (flag==1)
        ux(i)= x0 + r * cosd(theta2+theta0*i);
        uy(i)= y0 + r * sind(theta2+theta0*i);
    else
        ux(i)= x0 + r * cosd(theta21+theta0*i);
        uy(i)= y0 + r * sind(theta21+theta0*i);
    end
%     dt(i)= distance(x0,y0,ux(i),uy(i));
%     scatter(ux(i),uy(i),1,'black');
%     hold on;
end
end

function [d]=distance(x1,y1,x2,y2)
         d = sqrt((x1-x2).^2 + (y1-y2).^2);
end
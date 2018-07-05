function [rectx,recty,strip,px,py,Px,Py] = Strip(x,y,width)

% will need a 2x2 rotation matrix through an angle theta
Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];

% AB线X轴的方向角
edgeangles = atan2(y(2) - y(1),x(2) - x(1));
ab_angle = edgeangles ;
% move the angle into the first quadrant.
edgeangles = unique(mod(edgeangles,pi/2));

% now just check each edge of the hull
  xy = [x,y];
  rot = Rmat(-edgeangles);
  xyr = xy*rot;
  xymin = min(xyr,[],1);
  xymax = max(xyr,[],1);
  
  rect = [xymin;[xymax(1),xymin(2)];xymax;[xymin(1),xymax(2)]];
  rect = rect*rot';
  rectx = rect(:,1);
  recty = rect(:,2);
  
  %外接矩形的端点与A点最近的点
  [r1,~] = nearorfar_Point(x(1),y(1),rectx,recty);
  [r2,~] = nearorfar_Point(x(2),y(2),rectx,recty); 
  [r3,~] = nearorfar_Point(x(3),y(3),rectx,recty);
  [r4,~] = nearorfar_Point(x(4),y(4),rectx,recty);
  
  rectx = [rectx(r1);rectx(r2);rectx(r3);rectx(r4)];
  recty = [recty(r1);recty(r2);recty(r3);recty(r4)];
  rect = [rectx,recty];
        
        L = width;
        BC = distance(rectx(2),recty(2),rectx(3),recty(3));

        laststrip = mod(BC,L);
        numOfStrips = fix(BC/L);
        
        %计算DA与x轴正方向的夹角
        a = recty(4) - recty(1);
        b = rectx(4) - rectx(1);
        angle = atan2(a,b);

        %标记是否有最后一条不完整的条带
        if(laststrip<0.5)
        flag = 0;
        else
        flag = 1;
        numOfStrips = numOfStrips + 1;
        end
        
        x1 = zeros(numOfStrips,1);x2 = zeros(numOfStrips,1);
        x3 = zeros(numOfStrips,1);x4 = zeros(numOfStrips,1);
        y1 = zeros(numOfStrips,1);y2 = zeros(numOfStrips,1);
        y3 = zeros(numOfStrips,1);y4 = zeros(numOfStrips,1);
        rx1 = rect(1,1);
        ry1 = rect(1,2);
        rx2 = rect(2,1);
        ry2 = rect(2,2);       

        if(flag==1)
        for i=1:numOfStrips-1
            x1(i) = rx1;
            y1(i) = ry1;
            x2(i) = rx2;
            y2(i) = ry2;
            x3(i) = x2(i)+L*cos(angle);
            y3(i) = y2(i)+L*sin(angle);
            x4(i) = x1(i)+L*cos(angle);
            y4(i) = y1(i)+L*sin(angle);
            rx1 = x4(i);
            ry1 = y4(i);
            rx2 = x3(i);
            ry2 = y3(i);
        end       
            x1(numOfStrips) = rx1;
            y1(numOfStrips) = ry1;
            x2(numOfStrips) = rx2;
            y2(numOfStrips) = ry2;
            x3(numOfStrips) = rect(3,1);
            y3(numOfStrips) = rect(3,2);
            x4(numOfStrips) = rect(4,1);
            y4(numOfStrips) = rect(4,2);
        else     
       for i=1:numOfStrips
            x1(i) = rx1;
            y1(i) = ry1;
            x2(i) = rx2;
            y2(i) = ry2;
            x3(i) = x2(i)+L*cos(angle);
            y3(i) = y2(i)+L*sin(angle);
            x4(i) = x1(i)+L*cos(angle);
            y4(i) = y1(i)+L*sin(angle);
            rx1 = x4(i);
            ry1 = y4(i);
            rx2 = x3(i);
            ry2 = y3(i);
       end
        end

      p1 = [x1,y1];  
      p2 = [x2,y2];
      p3 = [x3,y3];  
      p4 = [x4,y4];  
      strip = [p1,p2,p3,p4];
 
      %生成轨迹点
      v = 2.0;
      frequency = 1.0;
      d0 = frequency * v;
      numOfTrackP = fix(distance(rectx(2),recty(2),rectx(1),recty(1))/v) ;
      
      if(flag==1)
          N = numOfStrips-1;
      else     
          N = numOfStrips;
      end
      
      %存储轨迹点
      m = 1;
      %元细胞组存储
      px = cell(1,N);
      py = cell(1,N);
      x0 = zeros(1,N);
      y0 = zeros(1,N);
      %矩阵存储
      Px=zeros(1,N * numOfTrackP);
      Py=zeros(1,N * numOfTrackP);
        for i=1:N
              x0(i)= (x1(i)+x4(i))/2 ;
              y0(i)= (y1(i)+y4(i))/2 ;
          for j=1:numOfTrackP
              px{i}(j)= x0(i)+ d0 * cos(ab_angle) * (j-1);
              py{i}(j)= y0(i)+ d0 * sin(ab_angle) * (j-1);
              Px(m)=px{i}(j);
              Py(m)=py{i}(j);
              m = m+1;
          end
        end
        
end

function [d]=distance(x1,y1,x2,y2)
         d = sqrt((x1-x2).^2 + (y1-y2).^2);
end

%外接矩形的端点与农田点最近和最远的点
function[rmin,rmax] = nearorfar_Point(x0,y0,rectx,recty)
        P = [x0,y0;x0,y0;x0,y0;x0,y0];
        d_P = distance(P(:,1),P(:,2),rectx,recty);
        d1 = min(d_P);
        d2 = max(d_P);
        for i=1:4
            if(d_P(i)==d1)
                rmin=i;
            end
            if(d_P(i)==d2)
                rmax=i;
            end
        end
end


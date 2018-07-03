
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

function [d]=distance(x1,y1,x2,y2)
         d = sqrt((x1-x2).^2 + (y1-y2).^2);
end
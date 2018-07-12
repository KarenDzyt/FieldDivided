% 调头轨迹生成, n0为工序内车辆数,no为车辆开始的条带编号
function[track_x,track_y] = Track(n0,no,px,py,width,r,t_turn,color)

if r<n0*width/2
    r=n0*width/2;
end
% a1 = mod(n1-no,n0);
n1 = length(px);
a2 = mod(n1-no,n0*2);
n_up = (n1-no-a2)/2/n0;
n_down = (n1-no-a2)/2/n0;

if a2 >= n0
    n_up = n_up +1;
end


for i=1:n_up
    L1 = length(px{no+2*(i-1)*n0});  
    L2 = length(px{no+(2*i-1)*n0}); 
    [ux{i},uy{i}] = U_turnup(px{no+2*(i-1)*n0}(L1),py{no+2*(i-1)*n0}(L1),px{no+(2*i-1)*n0}(L2),py{no+(2*i-1)*n0}(L2),r,width,2*t_turn);
    %取实部
    ux_r{2*i-1} = real(ux{i}).';
    uy_r{2*i-1} = real(uy{i}).';
end

for i=1:n_down
    [ux{i},uy{i}] = U_turndown(px{no+n0*(2*i-1)}(1),py{no+n0*(2*i-1)}(1),px{no+n0*2*i}(1),py{no+n0*2*i}(1),r,width,2*t_turn);
    %取实部
    ux_r{2*i} = real(ux{i}).';
    uy_r{2*i} = real(uy{i}).';
end

%调头轨迹与耕作轨迹连接
track_x =[];
track_y =[];
a3 = length(ux_r);
for i=1:a3
    track_x = [track_x px{no+n0*(i-1)} ux_r{i}];
    track_y = [track_y py{no+n0*(i-1)} uy_r{i}];
end
track_x = [track_x px{no+n0*a3}];
track_y = [track_y py{no+n0*a3}];

scatter(track_x,track_y,5,color,'filled');
hold on;

end
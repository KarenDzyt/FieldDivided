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

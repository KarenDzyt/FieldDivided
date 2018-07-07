sx1 = strip(:,1);sx2 = strip(:,3);
sx3 = strip(:,5);sx4 = strip(:,7);
sy1 = strip(:,2);sy2 = strip(:,4);
sy3 = strip(:,6);sy4 = strip(:,8);       

numOfstrip = length(sx1);
X = zeros(5,numOfstrip);
Y = zeros(5,numOfstrip);   
%»æÍ¼
for i=1:numOfstrip
    X(:,i) = [sx1(i);sx2(i);sx3(i);sx4(i);sx1(i)];
    Y(:,i) = [sy1(i);sy2(i);sy3(i);sy4(i);sy1(i)];
    plot(X(:,i),Y(:,i),'b');
    hold on;
end
field = [Field(1,:);Field(2,:);Field(3,:);Field(4,:);Field(1,:)];
plot(rectx,recty,'r');
hold on;
plot(field(:,1),field(:,2),'k');
hold on;
scatter(A(1),A(2));
hold on;
scatter(B(1),B(2));
hold on;
scatter(A0(1),A0(2));
hold on;
scatter(B0(1),B0(2));
hold on;
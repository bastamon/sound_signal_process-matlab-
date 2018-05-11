function sum=bpnn(trainsample,testsample,class)
%输入参数：trainsample是训练样本,testsample是测试样本,class表示训练样本的类别，与trainsample中数据对应
%sum：五种基本情感的识别率
for i=1:140
    feature(:,i)= trainsample(:,i);
end
%特征值归一化
[input,minI,maxI] = premnmx( feature')  ;

%构造输出矩阵
s = length( class ) ;
output = zeros( s , 5  ) ;
for i = 1 : s 
   output( i , class( i )  ) = 1 ;
end

%创建神经网络
net = newff( minmax(input) , [10 5] , { 'logsig' 'purelin' } , 'traingdx' ) ;   %创建前馈神经网络

%设置训练参数
net.trainparam.show = 50 ;
net.trainparam.epochs = 150 ;
net.trainparam.goal = 0.1 ;
net.trainParam.lr = 0.05 ;

%开始训练
net = train( net, input , output' ) ;

%读取测试数据
for i=1:140
    featuretest(:,i)= testsample(:,i);
end
 c=testsample(:,141);
%测试数据归一化
testInput = tramnmx(featuretest' , minI, maxI ) ;

%仿真
Y = sim( net , testInput ) 
sum=[0 0 0 0 0]; %每类情感正确识别个数
%统计识别正确样本数 
for i=1:20
    if Y(1,i)>Y(2,i)&&Y(1,i)>Y(3,i)&&Y(1,i)>Y(4,i)&&Y(1,i)>Y(5,i)
        sum(1)=sum(1)+1;
    end
end
for i=21:40
    if Y(2,i)>Y(1,i)&&Y(2,i)>Y(3,i)&&Y(2,i)>Y(4,i)&&Y(2,i)>Y(5,i)
         sum(2)=sum(2)+1;
    end
end
for i=41:60
    if Y(3,i)>Y(1,i)&&Y(3,i)>Y(2,i)&&Y(3,i)>Y(4,i)&&Y(3,i)>Y(5,i)
       sum(3)=sum(3)+1;
    end
end
for i=61:80
    if Y(4,i)>Y(1,i)&&Y(4,i)>Y(2,i)&&Y(4,i)>Y(3,i)&&Y(4,i)>Y(5,i)
       sum(4)=sum(4)+1;
    end
end
for i=81:100
    if Y(5,i)>Y(1,i)&&Y(5,i)>Y(2,i)&&Y(5,i)>Y(3,i)&&Y(5,i)>Y(4,i)
       sum(5)=sum(5)+1;
    end
end
sum=sum./20;
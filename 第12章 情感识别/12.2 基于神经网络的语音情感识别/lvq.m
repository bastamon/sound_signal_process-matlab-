function sumlvq=lvq(trainsample,testsample,class)
P=trainsample(:,1:140)';
C=class';
T=ind2vec(C);
net=newlvq(minmax(P),20,[0.2 0.2 0.2 0.2 0.2],0.1); %创建lvq网络
w1=net.IW{1};
net.trainParam.epochs=100;
net=train(net,P,T);
y=sim(net,testsample(:,1:140)');
y3c=vec2ind(y);
sumlvq=[0 0 0 0 0]; %每类情感正确识别个数
%统计识别正确样本数 
for i=1:20
    if y3c(i)==1
        sumlvq(1)=sumlvq(1)+1;
    end
end
for i=21:40
    if y3c(i)==2
        sumlvq(2)=sumlvq(2)+1;
    end
end
for i=41:60
    if y3c(i)==3
        sumlvq(3)=sumlvq(3)+1;
    end
end
for i=61:80
    if y3c(i)==4
        sumlvq(4)=sumlvq(4)+1;
    end
end
for i=81:100
    if y3c(i)==5
        sumlvq(5)=sumlvq(5)+1;
    end
end
sumlvq=sumlvq./20;
%短时过零率计算函数
function zcr=STZcr(x,win,inc)
    X=enframe(x,win,inc)';        % 分帧
    fn=size(X,2);                       % 求出帧数
    if length(win)==1
        wlen=win;               % 求出帧长
    else
        wlen=length(win);
    end
    zcr=zeros(1,fn);                 % 初始化
    delta=0.01;                                % 设置一个很小的阈值
    for i=1:fn
        z=X(:,i);                           % 取得一帧数据
    for k=1 : wlen                         % 中心截幅处理
        if z(k)>=delta
            ym(k)=z(k)-delta;
        elseif z(k)<-delta
            ym(k)=z(k)+delta;
        else
            ym(k)=0;
        end
    end
    zcr(i)=sum(ym(1:end-1).*ym(2:end)<0);  % 取得处理后的一帧数据寻找过零率
    end

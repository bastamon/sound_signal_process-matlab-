%**************************************************************************
%逐浈帧求取语音信号的共振峰
%所得s为一个矩阵,存储了每帧语音信号所对应的共振峰值
%**************************************************************************
function [s,s_bw,s_amp]=pick_peak(sound,samplerate)

%sex：1--男声，2--女声
% sex=1;
%对语音信号进行预处理，得到分帧后的信号
Sw=pre(sound,samplerate);
[frame_number,point]=size(Sw);

%逐帧修正,EST的初始值为每帧初始值的平均
for t=1:1:frame_number
    [ppp,bw,amp]=find_peak(Sw(t,:),samplerate,1);
    pp(t,:)=[ppp,zeros(1,4-length(ppp))];
end
for t=1:1:4
    a=find(pp(:,t)==0);
    if isempty(a)
        l=0;
    else
        l=length(a);
    end
    EST(t)=sum(pp(:,t)/(frame_number-l));
end
%     if sex==1
%         EST(1)=320;
%         EST(2)=1440;
%         EST(3)=2760;
%         EST(4)=3200;
%     elseif sex==2
%         EST(1)=480;
%         EST(2)=1760;
%         EST(3)=3200;
%         EST(4)=3520;
%     end

% EST=mean(p,1);
%s用来记录当前帧的共振峰估计值
s=zeros(frame_number,4);
s_bw=zeros(frame_number,4);
s_amp=zeros(frame_number,4);
%开始逐帧处理
for t=1:1:frame_number
    r=1;
    while(s(t,1)==0 || s(t,2)==0 || s(t,3)==0)
         [p,bw,amp]=find_peak(Sw(t,:),samplerate,r);
         if r>0.88
             r=r-0.02;
         else
             break;
         end
         peak_number=length(p);
        %p_mark用来标注被分配的峰值，已经分配的为0，未被分配的为1；
        p_mark=ones(1,peak_number);
        
        %e用来存放峰值与预测值的差
        e=zeros(1,peak_number);
        %将提取出的峰值对应的填到每个共振峰的位置上，要使得对应的共振峰值与EST值最为接近
         for x=1:1:4
             for y=1:1:peak_number
                 e(y)=abs(p(y)-EST(x));
             end
            [a,b]=min(e);
            s(t,x)=p(b);
            s_bw(t,x)=bw(b);
            s_amp(t,x)=amp(b);
            p_mark(b)=0;
         end
         %如果两个共振峰填入的峰值相同，则将该值保留在与EST值差距最小的位置，而将另外一个共振峰值除去
         for x=1:1:3
             for y=(x+1):1:4
                 if s(t,x)==s(t,y)
                     e(x)=abs(s(t,x)-EST(x));
                     e(y)=abs(s(t,y)-EST(y));
                     if e(x)>e(y)
                         s(t,x)=0;
                     else 
                         s(t,y)=0;
                     end
                 end
             end
         end
    
        %处理没有分配的峰值
        for k=1:1:peak_number
            if p_mark(k)~=0
                if s(t,k)==0
                    s(t,k)=p(k);
                    p_mark(k)=0;
                elseif ((amp(k)>=s_amp(t,k)*0.5) && k~=4)
                    if (s(t,k+1)==0)
                        s(t,k+1)=s(t,k);
                        s_bw(t,k+1)=s_bw(t,k);
                        s_amp(t,k+1)=s_amp(t,k);
                        s(t,k)=p(k);
                        s_bw(t,k)=bw(k);
                        s_amp(t,k)=amp(k);
                        p_mark(k)=0;
                    end
                elseif (amp(k)>=s_amp(t,k)*0.5) && (k~=1)
                    if (s(t,k-1)==0)
                        s(t,k-1)=s(t,k);
                        s_bw(t,k-1)=s_bw(t,k);
                        s_amp(t,k-1)=s_amp(t,k);
                        s(t,k)=p(k);
                        s_bw(t,k)=bw(k);
                        s_amp(t,k)=amp(k);
                        p_mark(k)=0;
                    end
                end
            end
        end
        for k=1:1:4
            if (s(t,k)~=0)
                EST(k)=s(t,k);
            end
        end
    end
end
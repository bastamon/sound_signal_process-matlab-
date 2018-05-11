%**************************************************************************
%对每帧的共振峰值进行平滑
%**************************************************************************
function [f,bw]=smoothing(s,s_bw)
[frame_number,peak_number]=size(s);
f=zeros(frame_number,peak_number);
for t=1:1:peak_number
    ss=s(:,t);
    ss_bw=s_bw(:,t);
    a=find(ss==0);     %判断有没有帧漏掉第t个共振峰
    l=length(a);
    if l~=0
        ss(a)=sum(ss)/(frame_number-l);
        ss_bw(a)=sum(ss_bw)/(frame_number-l);
    end
% %     %判断漏掉的帧是单独帧还是连续帧
% %     %如果漏掉的是单独帧，则用其他各帧的平均值代替该帧的值
% %     if l==1
% %         ss(a)=sum(ss)/(frame_number-l);
% %     elseif l>1
% %         for j=1:1:l-1
% %             b(j)=a(j+1)-a(j);
% %         end
% %         %第一帧和最后一帧单独处理
% %         if b(1)~=1
% %             ss(a(1))=sum(ss)/(frame_number-l);
% %             ss_amp(a(1))=sum(ss_amp)/(frame_number-l);
% %         end
% %         if b(l-1)~=1
% %             ss(a(l))=sum(ss)/(frame_number-l);
% %             ss_amp(a(l))=sum(ss_amp)/(frame_number-l);
% %         end
% %     
% %         %中间各帧需两头判断，都不连续时，才为独立帧
% %         for j=2:1:l-2
% %             if b(j)~=1 && b(j+1)~=1
% %                 ss(a(j))=sum(ss)/(frame_number-l);
% %                 ss_amp(a(j))=sum(ss_amp)/(frame_number-l);
% %             end
% %         end
% %     end
% %     clear b;        
    %判断是否有帧出现突变值
    %d为相邻帧共振峰间的距离，d(j)=ss(j+1)-ss(j);
    d=zeros(1,frame_number-1);
    for j=1:1:frame_number-1
    %      if ss(j+1)~=0 && ss(j)~=0
            d(j)=ss(j+1)-ss(j);
%         end
    end
    
    %theta为门限值，设为240hz
    theta=240;
    %一帧出现突变的情况
    for j=3:1:frame_number-5
        if abs(d(j))>theta
            if abs(d(j-1))<theta && abs(d(j+1)+d(j-1))<theta && abs(d(j+2))<theta
                ss(j+1)=(ss(j+2)+ss(j))/2;
                ss_bw(j+1)=(ss_bw(j+2)+ss_bw(j))/2;
            elseif abs(d(j-1))<theta && abs(d(j+2)+d(j+1)+d(j))<theta && abs(d(j+3))<theta
                ss(j+1)=(ss(j+3)+ss(j))/2;
                ss_bw(j+1)=(ss_bw(j+3)+ss_bw(j))/2;
            elseif abs(d(j-1))<theta && abs(d(j+3)+d(j+2)+d(j+1)+d(j))<theta && abs(d(j+4))<theta
                ss(j+1)=(ss(j+4)+ss(j))/2;
                ss_bw(j+1)=(ss_bw(j+4)+ss_bw(j))/2;
            end
        end
    end

    %最后做两次平滑    
    for j=2:1:frame_number-1
        ss(j)=0.25*ss(j-1)+0.5*ss(j)+0.25*ss(j+1);
        ss_bw(j)=0.25*ss_bw(j-1)+0.5*ss_bw(j)+0.25*ss_bw(j+1);
    end

    for j=2:1:frame_number-1
        ss(j)=0.25*ss(j-1)+0.5*ss(j)+0.25*ss(j+1);
        ss_bw(j)=0.25*ss_bw(j-1)+0.5*ss_bw(j)+0.25*ss_bw(j+1);
    end

    f(:,t)=ss;
    bw(:,t)=ss_bw;
end
         
    
    
     
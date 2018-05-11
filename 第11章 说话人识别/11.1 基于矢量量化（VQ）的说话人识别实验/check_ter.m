function sf=check_ter(sig,f_len,f_inc,len_noise)
%CHECK_TER :check the terminal of the speech
%sig:输入信号   f_len:帧长  f_inc：帧移
%len_noise:噪音帧数
%sf：语音段标记
f=div_frame(sig,f_len,f_inc);%分帧(矩形窗）
%f=enframe(sig,f_len,f_inc);
row=size(f,1);
sf=zeros(row,1);%信号帧标记
lmin=3;%语音间最小距离
%加hamming窗
for i=1:row
    f(i,:)=add_win(f(i,:),'hamming');
end
%f2=f(1:len_noise,:);
th_ey=(st_energy(f));
th_pz=(zero_pass(f));
%前导噪音段平均能量和过零率
n_ey=mean(th_ey(1:len_noise));
n_pz=mean(th_pz(1:len_noise));
th2=105*n_ey;%低门限值T2
th1=108*n_ey;%高门限值T1
%plot(find(th_ey>th1))
%figure

%二级门限
th3=25*n_pz;%门限T3
%端点检测
%flag=0;%flag=1,表示段开始，flag=0，表示段结束
for i=1:row
    %j=i-1;
    if th_ey(i)>th1%肯定是语音帧
        sf(i)=1;
        j=i-1;
        %语音段前th2判断
        while (j>=1)&&(sf(j)~=1)&&(th_ey(j)>th2)
            sf(j)=1;
            j=j-1;
        end            
        %flag=1;
    elseif th_ey(i)>th2
         %语音段后th2判断
        %j=i;
        if (i-1>=1)&&(sf(i-1)==1)
            sf(i)=1;
            %j=j+1;
        end    
        %while (j-1>=1)&&(j<=row)&&(sf(j-1)==1)
         %   sf(j)=1;
          %  j=j+1;
        %end        
    end
end
%二级判断
for i=1:row
    if th_pz(i)>th3
            %过零率判断
       j=i;
       while (j>0)&&(sf(j)~=1)&&(sf(j+1)==1)&&(th_pz(j)>th3)
             sf(j)=1;
             j=j-1;
       end    
       j=i;
       while (j<=row)&&(sf(j)~=1)&&(sf(j-1)==1)&&(th_pz(j)>th3)
            sf(j)=1;
            j=j+1;
       end        
   end
end     
index=find(sf);
len=length(index);
flag=0;
for i=1:len-1
    if index(i+1)-index(i)<lmin
        sf(index(i)+1:index(i+1)-1)=1;
    end
end
        
    
        
    

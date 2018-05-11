% -- 识别 ---
clear all;
load rec_data.mat;  % 载入待识别语音
load speaker.mat;   % 载入训练好的模型
Spk_num=6; %说话人个数
Tes_num=2;  %每个说话人待识别的语音数目
fs=16000; %采样频率
ncentres=16; %混合成分数目

for spk_cyc=1:Spk_num    % 遍历说话人
  for sph_cyc=1:Tes_num  % 遍历语音
     fprintf('开始识别第%i个说话人第%i条语音\n',spk_cyc,sph_cyc); 
     speech = rdata{spk_cyc}{sph_cyc};
     
     %---预处理,特征提取--
     pre_sph=filter([1 -0.97],1,speech);
     win_type='M'; %汉明窗
     cof_num=20; %倒谱系数个数
     frm_len=fs*0.02; %帧长：20ms
     fil_num=20; %滤波器组个数
     frm_off=fs*0.01; %帧移：10ms
     c=melcepst(pre_sph,fs,win_type,cof_num,fil_num,frm_len,frm_off); %(帧数)*(cof_num)
     cof=c(:,1:end-1); %N*D维矢量
     
     %----识别---
     MLval=zeros(size(cof,1),Spk_num);
     for b=1:Spk_num %说话人循环
     pai=speaker{b}.pai;
     for k=1:ncentres 
       mu=speaker{b}.mu(k,:);
       sigma=speaker{b}.sigma(:,:,k);
       pdf=mvnpdf(cof,mu,sigma);
       MLval(:,b)=MLval(:,b)+pdf*pai(k); %计算似然值
     end
    end
    logMLval=log((MLval)+eps);
    sumlog=sum(logMLval,1);
    [maxsl,idx]=max(sumlog); % 判决，将最大似然值对应的序号idx作为识别结果
    fprintf('识别结果：第%i个说话人\n',idx);     
     
  end
end
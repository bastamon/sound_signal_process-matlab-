function [mix,post,errlog]=gmm_em(mix,x,emiter)

[dim,data_sz]=size(x');
init_covars=mix.covars; 
MIN_COVAR=0.001;

for cnt=1:emiter
  %--- E step: 计算充分统计量 ---
  [post,act]=calcpost(mix,x);
  prob=act*(mix.priors)';
  errlog(cnt)=-sum(log(prob));
  
  %--- M step:重估三组参数 ---
  new_pr=sum(post,1);
  new_c=post'*x;
  mix.priors=new_pr./data_sz; %pai 
  mix.centres=new_c./(new_pr'*ones(1,dim)+eps); %miu
  switch mix.covar_type
  case 'diag'
    for j=1:mix.ncentres
     diffs=x-(ones(data_sz,1)*mix.centres(j,:));
     mix.covars(j,:)=sum((diffs.*diffs).*(post(:,j)*ones(1,dim)),1)./new_pr(j);
     if min(mix.covars(j,:)) < MIN_COVAR
       mix.covars(j,:) = init_covars(j,:);
     end
    end  
  case 'full'
    for j=1:mix.ncentres
     diffs=x-(ones(data_sz,1)*mix.centres(j,:));
     diffs=diffs.*(sqrt(post(:,j))*ones(1,dim));
     mix.covars(:,:,j)=(diffs'*diffs)/(new_pr(j)+eps);
     if min(svd(mix.covars(:,:,j)))<MIN_COVAR
       a=svd(mix.covars(:,:,j));
       mix.covars(:,:,j)=init_covars(:,:,j);
     end
    end
  otherwise
    error(['Unknown covariance type ', mix.covar_type]);               
  end    

end 

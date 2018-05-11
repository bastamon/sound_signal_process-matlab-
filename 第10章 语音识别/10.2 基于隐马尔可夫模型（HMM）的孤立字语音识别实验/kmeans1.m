function [x,esq,j] = kmeans1(d,k,x0)
%KMEANS Vector quantisation using K-means algorithm [X,ESQ,J]=(D,K,X0)
%Inputs:
% D contains data vectors (one per row)
% K is number of centres required
% X0 are the initial centres (optional)
%
%Outputs:
% X is output row vectors (K rows)
% ESQ is mean square error
% J indicates which centre each data vector belongs to

%  Based on a routine by Chuck Anderson, anderson@cs.colostate.edu, 1996


%      Copyright (C) Mike Brookes 1998
%
%      Last modified Mon Jul 27 15:48:23 1998
%
%   VOICEBOX home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You can obtain a copy of the GNU General Public License from
%   ftp://prep.ai.mit.edu/pub/gnu/COPYING-2.0 or by writing to
%   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n,p] = size(d); %输入矩阵d的行(n)和列(p)
if nargin<3
   x = d(ceil(rand(1,k)*n),:); %从输入矩阵中任意取出k个行矢量
else
   x=x0;
end
y = x+1;

while any(x(:) ~= y(:))
   z = disteusq(d,x,'x');%计算d(62*24)与x(3*24)之间的最小值z(62*3)
   [m,j] = min(z,[],2); %找出z中每一行中3个值中的最小值和对应的序列号
   y = x;
   for i=1:k
      s = j==i;
      if any(s)
         x(i,:) = mean(d(s,:),1);  %将该类i中的所有矢量对行求均值
      else
         q=find(m~=0);
         if isempty(q) break; end
         r=q(ceil(rand*length(q)));
         x(i,:) = d(r,:);
         m(r)=0;
         y=x+1;
      end
   end
end
esq=mean(m,1);

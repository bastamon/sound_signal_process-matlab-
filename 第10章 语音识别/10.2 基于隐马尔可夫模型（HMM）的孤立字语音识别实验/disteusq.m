function d=disteusq(x,y,mode,w)
%DISTEUSQ calculate euclidean, squared euclidean or mahanalobis distance D=(X,Y,MODE,W)
%
% Inputs: X,Y         Vector sets to be compared. Each row contains a data vector.
%                     X and Y must have the same number of columns.
%
%         MODE        Character string selecting the following options:
%                         'x'  Calculate the full distance matrix from every row of X to every row of Y
%                         'd'  Calculate only the distance between corresponding rows of X and Y
%                              The default is 'd' if X and Y have the same number of rows otherwise 'x'.
%                         's'  take the square-root of the result to give the euclidean distance.
%
%         W           Optional weighting matrix: the distance calculated is (x-y)*W*(x-y)'
%                     If W is a vector, then the matrix diag(W) is used.
%           
% Output: D           If MODE='d' then D is a column vector with the same number of rows as the shorter of X and Y.
%                     If MODE='x' then D is a matrix with the same number of rows as X and the same number of columns as Y'.
%

[nx,p]=size(x); ny=size(y,1);
if nargin<3 | isempty(mode) mode='0'; end
if any(mode=='d') | (mode~='x' & nx==ny)
   nx=min(nx,ny);
   z=x(1:nx,:)-y(1:nx,:);
   if nargin<4
      d=sum(z.*conj(z),2);
   elseif min(size(w))==1
      wv=w(:).';
      d=sum(z.*wv(ones(size(z,1),1),:).*conj(z),2);
   else
      d=sum(z*w.*conj(z),2);
   end
else
   if p>1
      if nargin<4
         z=permute(x(:,:,ones(1,ny)),[1 3 2])-permute(y(:,:,ones(1,nx)),[3 1 2]);
         d=sum(z.*conj(z),3);
      else
         nxy=nx*ny;
         z=reshape(permute(x(:,:,ones(1,ny)),[1 3 2])-permute(y(:,:,ones(1,nx)),[3 1 2]),nxy,p);
         if min(size(w))==1
            wv=w(:).';
            d=reshape(sum(z.*wv(ones(nxy,1),:).*conj(z),2),nx,ny);
         else
            d=reshape(sum(z*w.*conj(z),2),nx,ny);
         end
      end
   else
      z=x(:,ones(1,ny))-y(:,ones(1,nx)).';
      if nargin<4
         d=z.*conj(z);
      else
         d=w*z.*conj(z);
      end
   end
end
if any(mode=='s')
   d=sqrt(d);
end


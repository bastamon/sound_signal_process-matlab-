function y=rdct(x,n)
%RDCT     Discrete cosine transform of real data Y=(X,N)
% Data is truncated/padded to length N.
%
% This routine is equivalent to multiplying by the matrix
%
%   rdct(eye(n)) = diag([sqrt(2) 2*ones(1,n-1)]) * cos((0:n-1)'*(0.5:n)*pi/n)
%
% The rows and columns of the matrix are orthogonal but not unit modulus.
% Various versions of the DCT are obtained by pre-multiplying the above
% matrix by diag([b/a ones(1,n-1)/a]) and post-multiplying the
% inverse transform matrix by its inverse. A common choice is a=n and/or b=sqrt(2).
% Choose a=sqrt(2n) and b=1 to make the matrix orthogonal.
% If b~=1 then the columns are no longer orthogonal.
%
% see IRDCT for the inverse transform




%      Copyright (C) Mike Brookes 1998
%
%      Last modified Tue Apr 13 15:56:48 1999
%
%   VOICEBOX is a MATLAB toolbox for speech processing. Home page is at
%   http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
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

fl=size(x,1)==1;
if fl x=x(:); end
[m,k]=size(x);
if nargin<2 n=m;
elseif n>m x=[x; zeros(n-m,k)];
elseif n<m x(n+1:m,:)=[];
end

x=[x(1:2:n,:); x(2*fix(n/2):-2:2,:)];
z=[sqrt(2) 2*exp((-0.5i*pi/n)*(1:n-1))].';
y=real(fft(x).*z(:,ones(1,k)));

if fl y=y.'; end

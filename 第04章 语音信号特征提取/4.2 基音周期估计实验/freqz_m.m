function [db, mag, pha, grd,w]=freqz_m(b,a);

[H,w]=freqz(b,a,1000,'whole');
H=(H(1:501))'; w=(w(1:501))';
mag=abs(H);
db=20*log10((mag+eps)/max(mag));
pha=angle(H);
grd=grpdelay(b,a,w);

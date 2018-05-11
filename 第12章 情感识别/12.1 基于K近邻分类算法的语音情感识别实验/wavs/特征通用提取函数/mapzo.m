function m=mapzo(x)
xmin=min(x);xmax=max(x);
for i=1:length(x)
    m(i)=(x(i)-xmin)/(xmax-xmin);
end
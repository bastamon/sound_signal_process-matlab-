function y=multimidfilter(x,m)
a=x;
for k=1 : m
    b=medfilt1(a, 5); 
    a=b;
end
y=b;
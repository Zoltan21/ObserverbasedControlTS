function [xn,timen] = getrd(x,time,eps)
N = length(x);
x1 = x(:,1);
x2 = x(:,2);
%eps = 1e-3;
Nr = N-max(find(abs(x1(end:-1:1,1))>eps,1),find(abs(x1(end:-1:1,1))>eps,1));
xn = x(1:Nr,:);
timen = time(1:Nr);
end
function model = getp(pcfg,x1lim,sigm)
global visual
x1 = -x1lim:0.01:x1lim;
%% nonlinear function check
alpha = (pcfg.J+pcfg.m*pcfg.l^2)-pcfg.a*pcfg.m^2*pcfg.l^2*cos(x1).^2;
rho1 = (-pcfg.d+2*sigm*pcfg.a*pcfg.m*pcfg.l*cos(x1).*sin(x1))./alpha;
rho2 = (-pcfg.a*pcfg.m*pcfg.l*cos(x1))./alpha;
rho3 = pcfg.m*pcfg.l*sin(x1);
if (visual)
    close all
    plot(x1,rho1);
    figure;
    plot(x1,rho2);
    figure;
    plot(x1,rho3);
    figure;
    plot(x1,alpha);
end
% defining the limits for the nonlinearities:
lims = [min(rho1)     max(rho1)
      min(rho2)     max(rho2)
      min(rho3)     max(rho3)];
clear x1
nl.alpha = @(x1)(pcfg.J+pcfg.m*pcfg.l^2)-pcfg.a*pcfg.m^2*pcfg.l^2*cos(x1).^2;
nl.rho1 = @(x1)(-pcfg.d+2*sigm*pcfg.a*pcfg.m*pcfg.l*cos(x1).*sin(x1))./nl.alpha(x1);
nl.rho2 = @(x1)(-pcfg.a*pcfg.m*pcfg.l*cos(x1))./nl.alpha(x1);
nl.rho3 = @(x1)pcfg.m*pcfg.l*sin(x1);
% getting the membership function
m{1,1} = @(x1)(lims(1,2)-nl.rho1(x1))/(lims(1,2)-lims(1,1));
m{1,2} = @(x1)1-m{1,1}(x1);
m{2,1} = @(x1)(lims(2,2)-nl.rho2(x1))/(lims(2,2)-lims(2,1));
m{2,2} = @(x1)1-m{2,1}(x1);
m{3,1} = @(x1)(lims(3,2)-nl.rho3(x1))/(lims(3,2)-lims(3,1));
m{3,2} = @(x1)1-m{3,1}(x1);
n=length(lims);
r = 2^n;
for i=1:r
    %get the binary representation of the i-1 value
    bin=de2bi(i-1,n);
    %get the weighting function for all the 8 rules
    w{i}=@(x1)m{1,bin(n)+1}(x1)*m{2,bin(n-1)+1}(x1)*m{3,bin(n-2)+1}(x1);    
    A{i} =[ 0 1
            0 lims(1, bin(n)+1)];
    B{i} = [0
            lims(2, bin(n-1)+1)];
    G{i} = [lims(3,bin(n-2)+1)];
end
model.A =A;
model.B =B;
model.G =G;
model.m =w;
model.C =[1 0];
model.H =[0 1];
% the nonlinearity
model.psi = @(x2) x2^2+ 2*sigm*x2;
model.b = 4*sigm;
end
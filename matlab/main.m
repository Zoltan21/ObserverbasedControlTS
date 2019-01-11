%% TS fuzzy example for the theoretic approach
clear
close all
clc
%simulation parameters
global visual 
visual=0;
% pendulum parameters
pcfg.g = 9.8;
pcfg.m = 0.3;
pcfg.M = 15;
pcfg.d = 0.007;
pcfg.l = 0.3;
pcfg.J = 0.005;
pcfg.a = 1/(pcfg.M+pcfg.m);
% simulation params
x1lim = pi/3;           % radian
sigm = 4;               % radian/s
%% get model
fmodel = getp(pcfg,x1lim,sigm);
%% get observer
[Li,P1,~,Lpsi,~] = getobs(fmodel);
%% get controller
[Ki,P2] = getcont(fmodel);
%% verify LMI
%res = getverif(fmodel,Li,Ki,P1,P2);
%% generating simulink functions
Lz = getZ(fmodel,Li);
Kz = getZ(fmodel,Ki);
Az = getZ(fmodel,fmodel.A);
Bz = getZ(fmodel,fmodel.B);
Gz = getZ(fmodel,fmodel.G);
global dx dxh cont
dx = @(x1,x2,u) Az(x1)*[x1;x2]+Bz(x1)*u+Bz(x1)*Gz(x1)*fmodel.psi(x2);
dxh = @(x1,x1h,x2h,u) Az(x1)*[x1h;x2h]+Bz(x1)*u+Bz(x1)*Gz(x1)*fmodel.psi(x2h+Lpsi*(x1-x1h))+Lz(x1)*(x1-x1h);
cont = @(x1,x1h,x2h) -Kz(x1)*[x1h;x2h] - Gz(x1)*fmodel.psi(x2h+Lpsi*(x1-x1h));
%cont = @(x1,x1h,x2h) Kz(x1)*[x1h;x2h];
%% plotting data nicely from Simulink model
close all
mle = 'e';
mlx = 'x';
mlxh = '\hat{x}';
rd = 1;         % set to rd =1, if plot just the important data
rdtol = 1e-4;   % the tolerance of the important data
getdraw(e,mle,rd,rdtol)
getdraw(x,mlx,rd,rdtol)
getdraw(xh,mlxh,rd,rdtol)


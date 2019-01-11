function [Lz,P1,M,L_psi,eps] = getobs(fmodel)
r = length(fmodel.A); % nr of rules
ns = length(fmodel.A{1});
nc = min(size((fmodel.B{1})));
no = min(size((fmodel.C)));
M = sdpvar(length(fmodel.psi)); % this is the number of nonlinear functions
W = sdpvar(length(fmodel.psi),no);
%W = 0;
% yalmip
P1 = sdpvar(ns);
N=cell(r,1);
for i=1:r
    N{i}=sdpvar(ns,no);
end
eps = sdpvar(1);
gamma=1e-10;
F=[P1>=gamma*eye(ns), M>=gamma*eye(length(fmodel.psi)), eps>=gamma];
for i = 1:r
    for j=1:r
        beta11 = P1*fmodel.A{i}-N{i}*fmodel.C+(P1*fmodel.A{i}-N{i}*fmodel.C)'+eps*eye(ns);
        beta12 = P1*fmodel.B{i}*fmodel.G{j}+fmodel.H'*M-fmodel.C'*W';
        beta22 = -2*M*(1/fmodel.b);
        Beta{i,j} = [beta11 beta12
            beta12' beta22];
        if (i==j)
            F=[F, Beta{i,j}<=-gamma*eye(ns+no)];
        end
    end
end
%% continuation of lemma 3.1 :
for i=1:r
    for j=1:r
        if (i~=j)
            Delta=Beta{i,i}*2/(r-1) + Beta{i,j} + Beta{j,i};
            F=[F, Delta <= -gamma*eye(ns+no)];
        end
    end
end
opt=sdpsettings('debug',1);
diagnostics = optimize(F,[],opt);
%diagnostics = optimize(F);

if diagnostics.problem == 0
 disp('     Feasible')
elseif diagnostics.problem == 1
 disp('     Infeasible')
else
 disp('Something else happened')
end

%% observer gains
P1 = value(P1);
for i=1:r
N{i} = value(N{i});
L{i} = inv(P1)*N{i};
end
eps = value(eps);
M = value(M);
L_psi = inv(M)*value(W);

Lz = L;


end
function [Kz,P2] = getcont(fmodel)
r = length(fmodel.A); % nr of rules
ns = length(fmodel.A{1});
nc = min(size((fmodel.B{1})));
no = min(size((fmodel.C)));

X = sdpvar(ns);
for i =1:r
    R{i} = sdpvar(nc,ns);
end
gamma=1e-6;
F = [X>=gamma*eye(ns)];
for i = 1:r
    for j =1:r
        Beta{i,j} = [fmodel.A{i}*X-fmodel.B{i}*R{j}+(fmodel.A{i}*X-fmodel.B{i}*R{j})'];
        if (i==j)
            F=[F, Beta{i,j}<=-gamma*eye(ns)];
        end
    end
end

%% continuation of lemma 3.1 :
for i=1:r
    for j=1:r
        if (i~=j)
            Delta=Beta{i,i}*2/(r-1) + Beta{i,j} + Beta{j,i};
            F=[F, Delta <= -gamma*eye(ns)];
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

X = value(X);

for i=1:r
    R{i} = value(R{i});
    K{i} = R{i}*inv(X);
end
P2 = inv(X);
Kz=K;

end
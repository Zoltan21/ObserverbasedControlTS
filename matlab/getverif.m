function [res, LMIs] = getverif(fmodel,L,K,P1,P2)
s = length(fmodel.m);
alpha =50*1e-7;
P2 = alpha*P2;
for i=1:s
    for j= 1:s
        beta11= P2*(fmodel.A{i}-fmodel.B{i}*K{j})+(P2*(fmodel.A{i}-fmodel.B{i}*K{j}))';
        beta12= P2*L{i}*fmodel.C;
        beta22= P1*(fmodel.A{i}-L{i}*fmodel.C)+(P1*(fmodel.A{i}-L{i}*fmodel.C))';
        Beta{i,j} = [beta11   beta12;
            beta12'  beta22];
        if (i==j)
            D(i,i) = max(eig(Beta{i,j}));
        end
    end
end
% checking the second part
for i=1:s
    for j=1:s
        if (i~=j)
            D(i,j) = max(eig(Beta{i,i}*2/(s-1) + Beta{i,j} + Beta{j,i}));
        end
    end
end
D
end
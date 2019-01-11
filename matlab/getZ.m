function Lz = getZ(fmodel,L)
s = length(fmodel.m);
Lz = @(x1) 0;
for i=1:s
    Lz = @(x1) Lz(x1) + fmodel.m{i}(x1)*L{i};
end
end

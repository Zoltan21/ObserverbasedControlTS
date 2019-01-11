function res = mydxh(x1,xh,u)
global dxh
res = dxh(x1,xh(1),xh(2),u);
end
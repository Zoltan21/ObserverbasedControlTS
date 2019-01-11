function []= getdraw(data,ml,rd,tol)
x = data.signals.values;
time = data.time;
% reduce the data set to see just the useful data
if (rd==1)
    [x,time]=getrd(x,time,tol);
end
figure;
plot(time, x(:,1),'r',time,x(:,2),'b-.','LineWidth',1.5);
grid;
xlim([0,time(end)]);
ml1 = strcat('$',ml,'_1$');
ml2 = strcat('$',ml,'_2$');
leg1 = legend(ml1,ml2);
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',16);
myxl = xlabel('$t [s]$');
myyl = ylabel(strcat('$',ml,'$'));
set(myxl,'Interpreter','latex');
set(myxl,'FontSize',16);
set(myyl,'Interpreter','latex');
set(myyl,'FontSize',16);
fname = strcat('images/',ml,'.png');
saveas(gcf,fname);
end
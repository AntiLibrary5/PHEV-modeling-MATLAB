close all
clear all

cm=0:115;

x=dlmread('ploss_x.txt');
y=dlmread('ploss_y.txt');

ploss_fit=polyfit(x,y,4);
ploss_constants=polyval(ploss_fit,cm);

u=dlmread('e_x.txt');
v=dlmread('e_y.txt');

e_fit=polyfit(u,v,4);
e_constants=polyval(e_fit,cm);



figure(1)
plot(x,y,'k+')
hold on
plot(cm,ploss_constants)
xlabel('cm m/s'),ylabel('ploss Pa');
hold off

figure(2)
plot(u,v,'k+')
hold on
plot(cm,e_constants)
xlabel('cm m/s'),ylabel('e');
hold off

e00=0.749;
e01=0.0036;
e02=1.6711e-6;
e03=-4.7293e-7;
e04=2.6756e-9;

ploss0=13.5429;
ploss1=-2.1246;
ploss2=0.1051;
ploss3=-3.6401e-4;
ploss4=-2.8643e-6;

e_tweaked=[e04,e03,e02,e01,e00];
ploss_tweaked=[ploss4,ploss3,ploss2,ploss1,ploss0];

e_tweaked_plot=polyval(e_tweaked,cm);
ploss_tweaked_plot=polyval(ploss_tweaked,cm);

% figure(3)
% plot(cm,e_tweaked_plot)
% xlabel('cm'),ylabel('e');
% 
% figure(4)
% plot(cm,ploss_tweaked_plot)
% xlabel('cm'),ylabel('ploss');


A=0:0.01:100;
B=0:0.01:0.28;
[cm,pma]=meshgrid(A,B);
e=e00+e01.*cm+e02.*cm.^2+e03.*cm.^3+e04.*cm.^4;
ploss=(ploss4.*cm.^4+ploss3.*cm.^3+ploss2.*cm.^2+...
    ploss1.*cm+ploss0).*10^-5;

pme=e.*pma-ploss;

eff=pme./pma;
Vr=0.008298;
r=0.155;
omega=(cm./r);
omega=omega.*(60/(2*pi));
Torque=(2*Vr.*pme)*10^5;

%t speed curve
Tmax=337;.5;
T=0:400;
N=0:7000;
for c=1:7001
    if N(c)<2100
        T(c)=Tmax;
    else
        T(c)=708750/N(c);
    end;
end;


figure(5)
contour(omega,Torque,eff)
hold on 
plot(N,T)
xlabel('Speed/rpm'),ylabel('Torque/Nm')

% figure(6)
% contour3(pma,pme,cm)
% 
% tmax=max(Torque);
% figure(7)
% plot(tmax);

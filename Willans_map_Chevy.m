clear all
close all
%some 'ploss' values are taken from the graph 
cm_points=[0,4,8,12,16,17];
ploss_points=[1,1.6,2,2.9,3.7,4.1];
figure(1)
plot(cm_points,ploss_points,'k+');
hold on
%the points are used for a quadratic polynomial curve fit to get more
%points
ploss_fit=polyfit(cm_points,ploss_points,2);
cm2=linspace(1,17,30);
ploss2=polyval(ploss_fit,cm2);
plot(cm2,ploss2);
xlabel('cm m/s'),ylabel('ploss');
title('polynomial curve-fit for "ploss"');
legend('digitized points','curve-fit')
hold off
%the 'e' values are digitized and saved in a file
figure(2)
e=dlmread('e_points_e.txt');
cm_e=dlmread('e_points_cm.txt');
plot(cm_e,e,'k+');
hold on
%the saved values are used for a polynomial curvefit to get rest of the
%points
e_fit=polyfit(cm_e,e,2);
e2=polyval(e_fit,cm_e);
plot(cm_e,e2);
xlabel('cm m/s'),ylabel('e');
title('polynomial curve-fit for "e"');
legend('digitized points','curve-fit')

%the coefficients for the quadratic equation of 'ploss' and 'e' found from
%the curvefit
e00=0.3690;
e01=0.009999;
e02=-0.000250;

ploss0=1.0509;
ploss1=0.0926;
ploss2=0.0025;

%Engine Specs Ecotec 2.5L DOHC I$ gasoline engine Chevy Malibu 2013
Z=4;
%Vd(net displaced volume) = Z*volume of single cylinder
Vd=0.002198;
%lower heating value of fuel in MJ
Hlv=444;
%stroke length equal to bore size in this case
S=0.0946;
%max engine piston speed
cm_max=21.2;
pma_max=31.2;
vendor_eff=[0.1,0.15,0.2,0.25,0.3,0.33,0.35];

cm=0:0.1:cm_max;
E1=vendor_eff(1);
E2=vendor_eff(2);
E3=vendor_eff(3);
E4=vendor_eff(4);
E5=vendor_eff(5);
E6=vendor_eff(6);
E7=vendor_eff(7);
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme1(c)=ploss(c)/((e(c)/E1)-1);
end    
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme2(c)=ploss(c)/((e(c)/E2)-1);
end    
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme3(c)=ploss(c)/((e(c)/E3)-1);
end    
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme4(c)=ploss(c)/((e(c)/E4)-1);
end    
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme5(c)=ploss(c)/((e(c)/E5)-1);
end    
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme6(c)=ploss(c)/((e(c)/E6)-1);
end 
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme7(c)=ploss(c)/((e(c)/E7)-1);
end 
for c=1:length(cm)
    e(c)=e00+e01*cm(c)+e02*cm(c)^2;
    ploss(c)=ploss0+ploss1*cm(c)+ploss2*cm(c)^2;
    pme_max(c)=e(c)*pma_max-ploss(c);
end   

rpm=(cm.*(pi/S)).*((60)/(2*pi));
Te1=pme1.*((Vd*10^5)/(4*pi));
Te2=pme2.*((Vd*10^5)/(4*pi));
Te3=pme3.*((Vd*10^5)/(4*pi));
Te4=pme4.*((Vd*10^5)/(4*pi));
Te5=pme5.*((Vd*10^5)/(4*pi));
Te6=pme6.*((Vd*10^5)/(4*pi));
Te7=pme7.*((Vd*10^5)/(4*pi));
Te_max=pme_max.*((Vd*10^5)/(4*pi));
figure
% plot(cm,pme1,cm,pme2,cm,pme3,cm,pme4,cm,pme5,cm,pme_max)
plot(rpm,Te1,rpm,Te2,rpm,Te3,rpm,Te4,rpm,Te5,rpm,Te6,rpm,Te7,rpm,Te_max)
xlabel('rpm'),ylabel('Torque/Nm');
title('Willans model of Ecotec 2.2L LAP I4 VVT DI Engine')





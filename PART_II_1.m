close all
clear all
run('Glider_specs.m');
run('Transmission_Honda.m');
run('Engine_R16A.m');
run('Willans_engine_model_Honda.m');

%Accelration time 0-100kph:
pm_acc=(acc_load/omega_max)*(4*pi)*(1/Vd)*(1/10^5);

for c=1:length(Gear_ratio)%max velocity at a particular gear
   V_max(c)=omega_max*r/Gear_ratio(c);
end

v=zeros(1,14001);
G=zeros(1,14001);
cm=zeros(1,14001);
e=zeros(1,14001);
ploss=zeros(1,14001);
pme=zeros(1,14001);
Te=zeros(1,14001);


m=m+m_engine+m_transmission;
t=linspace(0,140,14001);  
gear=zeros(1,14001); 
dt=0.01;

for n=1:14000
    if ((v(n)==0) || v(n)<=V_max(1))
       G(n)=Gear_ratio(1);    
       gear(n)=1;
    elseif ((v(n)>V_max(1)) && v(n)<=V_max(2))
       G(n)=Gear_ratio(2);    
       gear(n)=2;
    elseif ((v(n)>V_max(2)) && v(n)<=V_max(3))
       G(n)=Gear_ratio(3);     
       gear(n)=3;
    elseif ((v(n)>V_max(3)) && v(n)<=V_max(4))
       G(n)=Gear_ratio(4);    
       gear(n)=4;
    elseif ((v(n)>V_max(4)) && v(n)<=V_max(5))
       G(n)=Gear_ratio(5); 
       gear(n)=5;
    elseif ((v(n)>V_max(5)) && v(n)<=V_max(6))
       G(n)=Gear_ratio(6);  
       gear(n)=6;
    end
    cm(n)=(S*G(n)*v(n))/(pi*r);
    e(n)=e00+e01*cm(n)+e02*cm(n)^2;
    ploss(n)=ploss0+ploss1*cm(n)+ploss2*cm(n)^2;
    pme(n)=e(n)*pma_max-ploss(n);
    pme(n)=pme(n)-pm_acc;%accounting for accessory load
    Te(n)=(pme(n)*Vd)/(4*pi)*10^5;
    v(n+1)=v(n)+(dt*(((eff_dr*G(n)*Te(n))/(m*r))-(cr*g)-(0.625*(CdAf/m)*v(n)^2)));
end
[c,index] = min(abs(v-27.77));
acceleration_time=t(index);
v=v*3.6;
figure
plot(t,v)
xlabel('Time/s'),ylabel('Velocity/kph');
title('WOT performance of the Chevy Malibu')

figure
subplot(2,1,1)
plot(t,(cm.*(pi/S)).*(60/(2*pi)))
xlabel('Time/s'),ylabel('Engine speed/rpm');
title('Variation of Engine Speed during WOT');
subplot(2,1,2)
plot(t,gear)
xlabel('Time/s'),ylabel('Gear')

%maximum velocity from WOT
Top_speed=v(length(v));


%finding maximum vehicle speed for the given power
a=0.625*CdAf;
b=0;
c=cr*m*g;
d=-Power;
%from the cruising condition of vehicle
p=[a b c d];
roots=roots(p);
%maximum velocity
v_max=roots(3)*3.6

%Gradeability
v_hill=27.77;
alpha=asind((Power-(0.625*CdAf*v_hill^3)-(cr*m*v_hill))/(m*g*v_hill));
Gradeability=tand(alpha)*100;

Parameters={'Test mass kg';'Max Speed kph';'Acceleration 0-60 mph s';...
    'Highway gradeability at 60mph at test mass %';'Powertrain sizing:';...
    'Engine peak power kW';'Estimated accessory load kW';'Engine mass kg';'Transmission mass kg';...
    'Transmission gearing';'1st gear';'2nd gear';'3rd gear';...
    '4th gear';'5th gear';'6th gear';'Reverse';'Final drive'};
Values={m;Top_speed;acceleration_time;Gradeability;'         ';Power/1000;acc_load/1000;m_engine;m_transmission;....
    '         ';G1;G2;G3;G4;G5;G6;reverse;Final_drive};
%printing table
table(Parameters,Values)
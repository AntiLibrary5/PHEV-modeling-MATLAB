close all
clear all
run('Glider_specs.m');
run('Motor_Bosch.m');
run('Li_ion_config_known.m');
v=zeros(1,14001);
t=linspace(0,140,14001);    
dt=0.01;

m=m+mass_pack_Li;

for n=1:14000
    if v(n)<linear_base_speed
      v(n+1)=v(n)+(dt*(((eff_dr*G*Max_Torque)/(m*r))-(cr*g)-(0.625*(CdAf/m)*v(n)^2)));
    else 
      v(n+1)=v(n)+(dt*(((eff_dr*G*((Max_Power*r)/(G*v(n))))/(m*r))-(cr*g)-(0.625*(CdAf/m)*v(n)^2))); 
    end
end
%0-60 mph acc time
[c index] = min(abs(v-27.77));
acceleration_time=t(index)
v=v*3.6;
%maximum velocity
Top_speed=v(length(v))

plot(t,v)

%Gradeability
v_hill=27.77;
alpha=asind((Max_Power-(0.625*CdAf*v_hill^3)-(m*cr*v_hill))/(m*g*v_hill));
Gradeability=tand(alpha)*100

Parameters={'Test mass kg';'Max Speed kph';'Acceleration 0-60 mph s';...
    'Highway gradeability at 60mph at test mass %';'Powertrain sizing:';...
    'Motor peak power kW';'Estimated accessory load kW';...
    'Single reduction gear';'Battery energy capacity kWh';...
    'Battery peak power kW';'Battery mass'};
Values={m;Top_speed;acceleration_time;Gradeability;'         ';Max_Power/1000;pm_acc/1000;....
    G;pack_V*pack_Ah/1000;Max_Power;mass_pack_Li};
%printing table
table(Parameters,Values)
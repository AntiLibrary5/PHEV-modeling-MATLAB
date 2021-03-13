clear all
close all

run('Drive_cycles');

%storing various energy consumption results for UDDS 505
[UDDS_505_Net_tractive_energy,UDDS_505_Fuel_energy_WhpKm,...
    UDDS_505_Total_energy_consumption_WhpKm,...
    UDDS_505_Total_energy_consumption_mpgge,...
    UDDS_505_WTW_PEU,UDDS_505_WTW_GHG,...
    UDDS_505_Range_km,Total_mass]=energy_cunsumption_results(UDDS_505);

%storing various energy consumption results for HWFET
[HWFET_Net_tractive_energy,HWFET_Fuel_energy_WhpKm,...
    HWFET_Total_energy_consumption_WhpKm,...
    HWFET_Total_energy_consumption_mpgge,...
    HWFET_WTW_PEU,HWFET_WTW_GHG,...
    HWFET_Range_km,Total_mass]=energy_cunsumption_results(HWFET);

%storing various energy consumption results for US06 city
[US06_city_Net_tractive_energy,US06_city_Fuel_energy_WhpKm,...
    US06_city_Total_energy_consumption_WhpKm,...
    US06_city_Total_energy_consumption_mpgge,...
    US06_city_WTW_PEU,US06_city_WTW_GHG,...
    US06_city_Range_km,Total_mass]=energy_cunsumption_results(US06_city);

%storing various energy consumption results for US06 highway
[US06_highway_Net_tractive_energy,US06_highway_Fuel_energy_WhpKm,...
    US06_highway_Total_energy_consumption_WhpKm,...
    US06_highway_Total_energy_consumption_mpgge,...
    US06_highway_WTW_PEU,US06_highway_WTW_GHG,...
    US06_highway_Range_km,Total_mass]=energy_cunsumption_results(US06_highway);

%creating table

energy_cnsmp={'Net tractive energy Wh/km';'Fuel energy_Wh/km';...
    'Total energy consumption Wh/km';...
    'Total energy consumption mpgge';...
    'WTW PEU Wh PE/km';'WTW GHG emission g/km';'Range km';'Mass'};

udds505=[UDDS_505_Net_tractive_energy;UDDS_505_Fuel_energy_WhpKm;...
    UDDS_505_Total_energy_consumption_WhpKm;...
    UDDS_505_Total_energy_consumption_mpgge;...
    UDDS_505_WTW_PEU;UDDS_505_WTW_GHG;...
    UDDS_505_Range_km;Total_mass];

hwfet=[HWFET_Net_tractive_energy;HWFET_Fuel_energy_WhpKm;...
    HWFET_Total_energy_consumption_WhpKm;...
    HWFET_Total_energy_consumption_mpgge;...
    HWFET_WTW_PEU;HWFET_WTW_GHG;...
    HWFET_Range_km;Total_mass];

us06city=[US06_city_Net_tractive_energy;US06_city_Fuel_energy_WhpKm;...
    US06_city_Total_energy_consumption_WhpKm;...
    US06_city_Total_energy_consumption_mpgge;...
    US06_city_WTW_PEU;US06_city_WTW_GHG;...
    US06_city_Range_km;Total_mass];

us06highway=[US06_highway_Net_tractive_energy;US06_highway_Fuel_energy_WhpKm;...
    US06_highway_Total_energy_consumption_WhpKm;...
    US06_highway_Total_energy_consumption_mpgge;...
    US06_highway_WTW_PEU;US06_highway_WTW_GHG;...
    US06_highway_Range_km;Total_mass];

%weighted results
weighted=[(0.29*UDDS_505_Net_tractive_energy+0.12*HWFET_Net_tractive_energy+...
    0.14*US06_city_Net_tractive_energy+0.45*US06_highway_Net_tractive_energy);...
    (0.29*UDDS_505_Fuel_energy_WhpKm+0.12*HWFET_Fuel_energy_WhpKm+...
    0.14*US06_city_Fuel_energy_WhpKm+0.45*US06_highway_Fuel_energy_WhpKm);...
    (0.29*UDDS_505_Total_energy_consumption_WhpKm+0.12*HWFET_Total_energy_consumption_WhpKm+...
    0.14*US06_city_Total_energy_consumption_WhpKm+0.45*US06_highway_Total_energy_consumption_WhpKm);...
    (0.29*UDDS_505_Total_energy_consumption_mpgge+0.12*HWFET_Total_energy_consumption_mpgge+...
    0.14*US06_city_Total_energy_consumption_mpgge+0.45*US06_highway_Total_energy_consumption_mpgge);...
    (0.29*UDDS_505_WTW_PEU+0.12*HWFET_WTW_PEU+...
    0.14*US06_city_WTW_PEU+0.45*US06_highway_WTW_PEU);...
    (0.29*UDDS_505_WTW_GHG+0.12*HWFET_WTW_GHG+...
    0.14*US06_city_WTW_GHG+0.45*US06_highway_WTW_GHG);...
    (0.29*UDDS_505_Range_km+0.12*HWFET_Range_km+...
    0.14*US06_city_Range_km+0.45*US06_highway_Range_km);Total_mass];

table(Drive_Cycle,Max_Velocity_kph,Avg_Velocity_kph,Cycle_Time_s,Cycle_Distance_km)
%printing table in command window
table(energy_cnsmp,udds505,hwfet,us06city,us06highway,weighted)

City_mpg=0.33* US06_city_Total_energy_consumption_mpgge+0.67*UDDS_505_Total_energy_consumption_mpgge
Highway_mpg=0.78* US06_highway_Total_energy_consumption_mpgge+0.22* HWFET_Total_energy_consumption_mpgge
Combined=0.43*City_mpg+0.57*Highway_mpg

%local function for repeated calculations 
function [Net_tractive_energy,Fuel_energy_WhpKm,...
    Total_energy_consumption_WhpKm,Total_energy_consumption_mpgge,...
    WTW_PEU,WTW_GHG,Range_km,Total_mass]=energy_cunsumption_results(v)
run('Glider_specs.m');
run('Transmission_Honda.m');
run('Engine_R16A.m');
run('Willans_engine_model_Honda');
run('Drive_cycles');
run('Fuel_properties');
run('EC_factors');
%conventional vehicle
m=m+m_engine+m_fuel+m_transmission;%added mass
% pm_acc=(acc_load/omega_max)*(4*pi)*(1/Vd)*(1/10^5);%accessory load
CY=1;
for c=1:length(Gear_ratio)
   V_max(c)=omega_max*r/Gear_ratio(c);
end
D=zeros(1,length(v));
fuel_tank=37.85;%10 gallons of E10
while fuel_tank>0
  for n=2:length(v)
   if v(n)>0    
     if v(n)>=v(n-1)
        Fw(n)=cr*m*g+0.5*rho*CdAf*v(n)^2+m*(v(n)-v(n-1));
        Tw(n)=Fw(n)*r;
        Pw(n)=Fw(n)*v(n);
        omega_w(n)=v(n)/r;
        if ((v(n)==0) || v(n)<=V_max(1))
           G(n)=Gear_ratio(1);       
        elseif ((v(n)>V_max(1)) && v(n)<=V_max(2))
           G(n)=Gear_ratio(2);    
        elseif ((v(n)>V_max(2)) && v(n)<=V_max(3))
           G(n)=Gear_ratio(3);     
        elseif ((v(n)>V_max(3)) && v(n)<=V_max(4))
           G(n)=Gear_ratio(4);          
        elseif ((v(n)>V_max(4)) && v(n)<=V_max(5))
           G(n)=Gear_ratio(5);           
        elseif ((v(n)>V_max(5)) && v(n)<=V_max(6))
           G(n)=Gear_ratio(6);   
        end
        Pe(n)=Pw(n)/eff_dr;%with power loss consideration, can account for other power cunsumption sinks like auxiliaries
        Pe(n)=Pe(n)+acc_load;
        omega_e(n)=G(n)*omega_w(n);
        Te(n)=Pe(n)/omega_e(n);%Te(n)=Tw(n)/G(n);
        pme(n)=(4*pi*Te(n))/(Vd);%pascal
        pme(n)=pme(n);
        cm(n)=S*omega_e(n)/pi;
        e(n)=e00+e01*cm(n)+e02*cm(n)^2;
        ploss(n)=ploss0+ploss1*cm(n)+ploss2*cm(n)^2;%bar
        ploss(n)=ploss(n)*10^5;%pascal
        eff(n)=e(n)/(1+(ploss(n)/pme(n)));
        pma(n)=pme(n)/eff(n);
        %or %pma(n)=(pme(n)+ploss(n))/e(n);%pascal
        mf=(pma(n)*omega_e(n)*Vd)/(4*pi*Hlv);
        fuel_tank=fuel_tank-mf;  
     elseif v(n)<v(n-1)
        Ft_b(n)=abs(cr*m*g+0.5*rho*CdAf*v(n)^2+m*(v(n)-v(n-1)));
        Pt_b(n)=Ft_b(n)*v(n);
        clutch(n)=1;
     end
   else
        T_idle(n)=1;
   end
  D(n)=D(n-1)+(v(n)/1000);
  if fuel_tank<=0
      break;
  end
  end
D_EOC(CY)=D(n);
Pw_EOC(CY)=trapz(Pw)/3600;
CY=CY+1;  
end

range_miles=sum(D_EOC)*0.621371;%miles

miles_per_gallon=range_miles/10;%mpg=mpgge

fuel_tank_liter=10*3.78541;%fuel amount in liters

fuel_tank_energy=9500*fuel_tank_liter; %Wh

Fuel_energy_WhpMile=fuel_tank_energy/range_miles;%Wh/mile

Fuel_energy_kWhpMile=Fuel_energy_WhpMile/1000;%kWh/mile

%table
Range_km=sum(D_EOC);%km

Net_tractive_energy=trapz(Pw_EOC)/Range_km;

Fuel_energy_WhpKm=fuel_tank_energy/Range_km;%Wh/km

Total_energy_consumption_WhpKm=Fuel_energy_WhpKm;%Wh/km

Total_energy_consumption_mpgge=miles_per_gallon;%mpgge

WTW_PEU=Fuel_energy_kWhpMile*PEU_WTW_factor_E10;%Wh PE/mile

WTW_GHG=Fuel_energy_kWhpMile*GHG_WTW_factor_E10;%g GHG/mile

Total_mass=m;

end
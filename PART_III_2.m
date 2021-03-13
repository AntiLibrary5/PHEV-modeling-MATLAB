clear all
close all

run('Drive_cycles');

%storing various energy consumption results for UDDS 505
[UDDS_505_Net_tractive_energy,UDDS_505_Battery_energy_WhpKm,...
    UDDS_505_Total_energy_consumption_WhpKm,...
    UDDS_505_Total_energy_consumption_mpgge,...
    UDDS_505_WTW_PEU,UDDS_505_WTW_GHG,...
    UDDS_505_Range_km,Total_mass]=energy_cunsumption_results(UDDS_505);

%storing various energy consumption results for HWFET
[HWFET_Net_tractive_energy,HWFET_Battery_energy_WhpKm,...
    HWFET_Total_energy_consumption_WhpKm,...
    HWFET_Total_energy_consumption_mpgge,...
    HWFET_WTW_PEU,HWFET_WTW_GHG,...
    HWFET_Range_km,Total_mass]=energy_cunsumption_results(HWFET);

%storing various energy consumption results for US06 city
[US06_city_Net_tractive_energy,US06_city_Battery_energy_WhpKm,...
    US06_city_Total_energy_consumption_WhpKm,...
    US06_city_Total_energy_consumption_mpgge,...
    US06_city_WTW_PEU,US06_city_WTW_GHG,...
    US06_city_Range_km,Total_mass]=energy_cunsumption_results(US06_city);

%storing various energy consumption results for US06 highway
[US06_highway_Net_tractive_energy,US06_highway_Battery_energy_WhpKm,...
    US06_highway_Total_energy_consumption_WhpKm,...
    US06_highway_Total_energy_consumption_mpgge,...
    US06_highway_WTW_PEU,US06_highway_WTW_GHG,...
    US06_highway_Range_km,Total_mass]=energy_cunsumption_results(US06_highway);

%creating table

energy_cnsmp={'Net tractive energy Wh/km';'Battery energy_Wh/km';...
    'Total energy consumption Wh/km';...
    'Total energy consumption mpgge';...
    'WTW PEU Wh PE/km';'WTW GHG emission g/km';'Range km';'Mass'};

udds505=[UDDS_505_Net_tractive_energy;UDDS_505_Battery_energy_WhpKm;...
    UDDS_505_Total_energy_consumption_WhpKm;...
    UDDS_505_Total_energy_consumption_mpgge;...
    UDDS_505_WTW_PEU;UDDS_505_WTW_GHG;...
    UDDS_505_Range_km;Total_mass];

hwfet=[HWFET_Net_tractive_energy;HWFET_Battery_energy_WhpKm;...
    HWFET_Total_energy_consumption_WhpKm;...
    HWFET_Total_energy_consumption_mpgge;...
    HWFET_WTW_PEU;HWFET_WTW_GHG;...
    HWFET_Range_km;Total_mass];

us06city=[US06_city_Net_tractive_energy;US06_city_Battery_energy_WhpKm;...
    US06_city_Total_energy_consumption_WhpKm;...
    US06_city_Total_energy_consumption_mpgge;...
    US06_city_WTW_PEU;US06_city_WTW_GHG;...
    US06_city_Range_km;Total_mass];

us06highway=[US06_highway_Net_tractive_energy;US06_highway_Battery_energy_WhpKm;...
    US06_highway_Total_energy_consumption_WhpKm;...
    US06_highway_Total_energy_consumption_mpgge;...
    US06_highway_WTW_PEU;US06_highway_WTW_GHG;...
    US06_highway_Range_km;Total_mass];

%weighted results
weighted=[(0.29*UDDS_505_Net_tractive_energy+0.12*HWFET_Net_tractive_energy+...
    0.14*US06_city_Net_tractive_energy+0.45*US06_highway_Net_tractive_energy);...
    (0.29*UDDS_505_Battery_energy_WhpKm+0.12*HWFET_Battery_energy_WhpKm+...
    0.14*US06_city_Battery_energy_WhpKm+0.45*US06_highway_Battery_energy_WhpKm);...
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

%printing table in command window
T=table(energy_cnsmp,udds505,hwfet,us06city,us06highway,weighted)

City_mpgge=0.33* US06_city_Total_energy_consumption_mpgge+0.67*UDDS_505_Total_energy_consumption_mpgge
Highway_mpgge=0.78* US06_highway_Total_energy_consumption_mpgge+0.22* HWFET_Total_energy_consumption_mpgge
Combined=0.43*City_mpgge+0.57*Highway_mpgge

%local function for repeated calculations 
function [Net_tractive_energy,Battery_energy_WhpKm,...
    Total_energy_consumption_WhpKm,Total_energy_consumption_mpgge,...
    WTW_PEU,WTW_GHG,Range_km,Total_mass]=energy_cunsumption_results(v)

run('Glider_specs.m');
run('Drive_cycles.m');
run('Motor_Bosch.m');
run('Li_ion_config_known.m');
run('Willans_motor_model_Bosch.m');
run('EC_factors');

CY=1;
DOD=ones(1,length(v)).*0.5;
CR=zeros(1,length(v));
D=zeros(1,length(v));

CR_EOC=zeros(1,100);

DD=0;
m=m+mass_pack_Li;%GVW
if m>=2000
    m=2000;
end
dod = [];
%To store values of power output from battery throughout CY cycles
powerbattery=[];
%To store E_oc values throughout CY cycles
voltageoc=[];
%To store current values throughout CY cycles
current=[];

dod=[];
while DD<0.8
 for n=2:length(v)
    E=polyval(fit_v_plot,(1-DOD(n-1)))*scaling_factor;
    if E<=(cell_V_min*noCells_s_module*no_modules)
        error('Pack over discharged')
    elseif E>=(cell_V_max*noCells_s_module*no_modules)
        error('Pack overcharged')
    end
    if v(n)==0
      T_idle(n)=1;
      Pmot_in(n)=0;
    else
            Fw=cr*m*g+0.5*rho*CdAf*v(n)^2+m*(v(n)-v(n-1));
            Tw=Fw*r;
            omega_w(n)=v(n)/r;
            Pw(n)=Fw*v(n);
            omega_m(n)=G*omega_w(n);
        if v(n)>=v(n-1)
            Pm(n)=Pw(n)/eff_dr;
            Pm(n)=Pm(n);
            Tm(n)=Pm(n)/omega_m(n);
            pme(n)=(Tm(n))/(2*Vr);
            cm(n)=omega_m(n)*rm;
            e(n)=e00+e01*cm(n)+e02*cm(n)^2+e03*cm(n)^3+e04*cm(n)^4;
            ploss(n)=ploss0+ploss1*cm(n)+ploss2*cm(n)^2+ploss3*cm(n)^3+ploss4*cm(n)^4;
            pma(n)=(pme(n)+ploss(n))/e(n);%%pascal 
            Pmot_in(n)=pma(n)*2*Vr*omega_m(n);    
        elseif v(n)<v(n-1)
            Pm(n)=Pw(n)*eff_dr;
            Pm(n)=Pm(n);
            Tm(n)=Pm(n)/omega_m(n);
            pme(n)=(Tm(n))/(2*Vr);
            cm(n)=omega_m(n)*rm;
            e(n)=e00+e01*cm(n)+e02*cm(n)^2+e03*cm(n)^3+e04*cm(n)^4;
            ploss(n)=ploss0+ploss1*cm(n)+ploss2*cm(n)^2+ploss3*cm(n)^3+ploss4*cm(n)^4;%pascal
            pma(n)=e(n)*pme(n)+ploss(n);%pascal 
            Pmot_in(n)=pma(n)*2*Vr*omega_m(n);
        end
    end
    Pbatt(n)=Pmot_in(n)+pm_acc;
    if Pbatt(n)>0
        Rin=polyval(fit_r_dis_plot,(1-DOD(n-1)))*scaling_factor;
        I(n)=(E-((E*E)-(4*Rin*Pbatt(n)))^0.5)/(2*Rin);
        CR(n)=CR(n-1)+(I(n)/3600);
   
    elseif Pbatt(n)==0
        I(n)=0;
    elseif Pbatt(n)<0
        Rin=polyval(fit_r_chg_plot,(1-DOD(n-1)))*scaling_factor;
        I(n)=(-E+((E*E)-(4*Rin*Pbatt(n)))^0.5)/(2*Rin);
        CR(n)=CR(n-1)-(I(n)/3600);
       
    end
    DOD(n)=(CR(n)/pack_Ah);
    D(n)=D(n-1)+(v(n)/1000);
    VOC(n)=E;
    if DOD(n)>=0.8
        break;
    end
    
 end
dod=[dod DOD];
voltageoc=[voltageoc VOC];
current=[current I];
%updating end of cycle values
DOD_EOC(CY)=DOD(n);
CR_EOC(CY)=CR(n);
D_EOC(CY)=D(n);
Pw_EOC(CY)=trapz(Pw)/3600;
%The DOD,CR and D values of next cycle should start where their previous cycle values left
%off
DOD(1)=DOD(n);
CR(1)=CR(n);
D(1)=D(n);
%the while loop will exit when DD=DOD_end reaches 0.9
DD=DOD_EOC(CY);
%next cycle 
CY=CY+1;
end

s=length(dod);
sec=1:s;

Range_km=D_EOC(end);

Range_miles=Range_km*0.621371;

Net_tractive_energy=trapz(Pw_EOC)/Range_km;

Battery_energy_used=pack_V*pack_Ah*0.75;

Battery_energy_kWhpMile=(Battery_energy_used/Range_miles)/1000;

Battery_energy_WhpKm=(Battery_energy_used)/Range_km;% 75% used

Battery_energy_fuel_gallon_eq=Battery_energy_used/33560;%1 gallon (US) = 33.56 kWh

Total_energy_consumption_WhpKm=Battery_energy_WhpKm;%Wh/km

Total_energy_consumption_mpgge=Range_miles/Battery_energy_fuel_gallon_eq;%mpgge

WTW_PEU=Battery_energy_kWhpMile*PEU_WTW_factor_Electricity;%Wh PE/mile

WTW_GHG=Battery_energy_kWhpMile*GHG_WTW_factor_Electricity;%g GHG/mile

Total_mass=m;


end
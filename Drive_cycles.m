%Drive cycles required for the Ecocar E&EC 4-cycle

%First 505s of the UDDS
UDDS_505=xlsread('UDDS.xlsx','B4:B508');

%HWFET
HWFET=xlsread('HWFET.xlsx','B4:B769');

%US06 city
US06_city_1=xlsread('US06.xlsx','B4:B135');
US06_city_2=xlsread('US06.xlsx','B501:B604');
US06_city=cat(1,US06_city_1,US06_city_2);

%US06 highway 
US06_highway=xlsread('US06.xlsx','B136:B500');


% %plots of drive cycles
% figure('Name','UDDS 505')
% plot(UDDS_505)
% title('UDDS-505')
% xlabel('Time/sec'),ylabel('Speed/mph');

%conversion to m/s , factor 0.44704
UDDS_505=UDDS_505.*0.44704;
HWFET=HWFET.*0.44704;
US06_city=US06_city.*0.44704;
US06_highway=US06_highway.*0.44704;
% 
% figure('Name','HWFET')
% plot(HWFET)
% xlabel('Time/sec'),ylabel('Speed/mph');
% title('HWFET')
% 
% figure('Name','US06 City')
% plot(US06_city)
% xlabel('Time/sec'),ylabel('Speed/mph');
% title('US06-city')
% 
% figure('Name','US06 Highway')
% plot(US06_highway)
% xlabel('Time/sec'),ylabel('Speed/mph');
% title('US06-highway')

for c=2:length(UDDS_505)
    a_UDDS_505(c)=UDDS_505(c)-UDDS_505(c-1);
    if a_UDDS_505(c)<0
      a_UDDS_505(c)=0;
    end
end

for c=2:length(HWFET)
    a_HWFET(c)=HWFET(c)-HWFET(c-1);
    if a_HWFET(c)<0
      a_HWFET(c)=0;
    end
end

for c=2:length(US06_city)
    a_US06_city(c)=US06_city(c)-US06_city(c-1);
    if a_US06_city(c)<0
      a_US06_city(c)=0;
    end
end

for c=2:length(US06_highway)
    a_US06_highway(c)=US06_highway(c)-US06_highway(c-1);
    if a_US06_highway(c)<0
      a_US06_highway(c)=0;
    end
end

Cycle_Distance_km=[sum(UDDS_505)/1000;sum(HWFET)/1000;sum(US06_city)/1000;sum(US06_highway)/1000];
Avg_Velocity_kph=[mean(UDDS_505);mean(HWFET);mean(US06_city);mean(US06_highway)];
Max_Velocity_kph=[max(UDDS_505);max(HWFET);max(US06_city);max(US06_highway)];
Cycle_Time_s=[length(UDDS_505);length(HWFET);length(US06_city);length(US06_highway)];
Avg_acceleration=[mean(a_UDDS_505);mean(a_HWFET);mean(a_US06_city);mean(US06_highway)];
Drive_Cycle={'UDDS 505';'HWFET';'US06_city';'US06_highway'};
% t=table(Drive_Cycle,Max_Velocity_kph,Avg_Velocity_kph,Cycle_Time_s,Cycle_Distance_km)

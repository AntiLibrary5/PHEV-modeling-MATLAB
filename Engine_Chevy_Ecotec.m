%Engine specs Ecotec 2.5L DOHC I4 gasoline engine Chevy Malibu 2013
%Vd=2457 cc
%HP=147 kW @ 6300 rpm
%T=259 Nm @4400 rpm
%Redline=7000 rpm
%Bore=88mm
%Stroke=101mm

Power=147000;
rpm_max=7000;
omega_max=2*pi*rpm_max/60;
pma_max=33.9;%from max torque consideration at rated engine speed
S=0.101;
Vd=0.002457;
acc_load=11000;
m_engine=165;%mass of a typical 2.5L engine

%transmission Chevy Malibu 2013

G1=4.58;
G2=2.96;
G3=1.91;
G4=1.45;
G5=1;
G6=0.75;
reverse=2.84;
Final_drive=2.64;
Gear_ratio=[G1 G2 G3 G4 G5 G6]*Final_drive;
Gears=[G1 G2 G3 G4 G5 G6];
m_transmission=66.3;%mass of transmission
eff_dr=0.97*0.94*0.9;%driveline efficiency; gearbox*final_drive*rest_of_components; source Vehicle powertrain systems, Crolla
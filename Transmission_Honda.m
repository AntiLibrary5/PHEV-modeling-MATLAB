%transmission Honda HRV 6 speed manual

G1=3.642;
G2=1.885;
G3=1.361;
G4=1.024;
G5=0.83;
G6=0.686;
reverse=3.673;
Final_drive=4.705;
Gear_ratio=[G1 G2 G3 G4 G5 G6]*Final_drive;
Gears=[G1 G2 G3 G4 G5 G6];
m_transmission=66.3;%mass of transmission
eff_dr=0.95;%driveline efficiency; gearbox*final_drive*rest_of_components; source Vehicle powertrain systems, Crolla
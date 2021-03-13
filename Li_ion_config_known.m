%The input to the script is number of series modules, no of 
%cells in series in a module, and no of cells in parallel 
%and the output will be the coefficients for the open 
%circuit voltage and internal resistance equation for the pack

% Built with A123 AMP20 cells, a rescalable 7x15s3p module
% "Modified" Rint model parameters, for class use

% Battery mass 
module_added_mass=5.2;           % Packaging per 15s3p module, in kg
%# bat_mass=series_cells*parallel_cells*cell_mass+modules*module_added_mass; % Cell mass all modules, in kg
%# bat_overall_mass=1.1*bat_mass;  % 10% added weight for packaging

battery_desc='A123';   

% Li ion cell ESS Parameters
module_added_mass=5.2;           % Packaging per 15s3p module, in kg

no_modules=7;           %Enter number of Modules in series
noCells_s_module=15;    %Enter number of cell in series in module
noCells_p=7;            %Enter number of cell in parallel in module
cell_V=3.3;                      % Cell nominal voltage in V, @ C/3
cell_mass=0.496;                 % Cell mass, in kg
cell_V_min=2.5;                  % Min mell OCV
cell_V_max=3.6;                  % Max mell OCV 
cell_Ah=19.0;                    % Cell capacity 

module_V=noCells_s_module*cell_V;

pack_V=module_V*no_modules;                % Pack nominal voltage
pack_Ah=cell_Ah*noCells_p;                 % Pack amps/hr

scaling_factor=pack_V/cell_V;      %for converting characteristics from cell to pack

% Battery mass 
mass_s=noCells_s_module/15;
mass_p=noCells_p/3;
mass_module_packaging=module_added_mass*no_modules*mass_s*mass_p;
mass_cell=no_modules*noCells_s_module*noCells_p*cell_mass;
mass_pack_Li=(mass_module_packaging+mass_cell)*1.1;

% Index of battery soc
bat_soc_idx=[5 10 15 20 25 30 40 50 60 70 80 90 95 100]/100; 
% OCV for cell, in V from HPPC test
cell_voc=[3.14 3.32 3.35 3.33 3.35 3.37 3.40 3.42 3.41 3.43 3.42 3.43 3.48 3.60];	     
% Cell charge resistance, in ohm from HPPC test
cell_r_chg=[.00321 .00227 .00213 .00217 .00218 .00214 .00209 .00206 .00203 .00201 .00202 .00203 .00206 .00207];
% Cell discharge resistance, in ohm from HPPC test
cell_r_dis=[.00337 .00236 .00221 .00212 .00203 .00202 .00193 .00189 .00181 .00180 .00181 .00176 .00175 .00195];

% Pack description
batpk_desc=[battery_desc ' ' num2str(pack_V*pack_Ah/1000) ' kWh '...
                 ', ' num2str(no_modules) ' x ' num2str(noCells_s_module) 's x ' ...
                 num2str(noCells_p) 'p '...
                  ', Nominal Voltage ' num2str(pack_V) ' V' ...
                  ', Minimum Voltage ' num2str(cell_V_min*noCells_s_module*no_modules) ' V' ...
                 ', Maximum Voltage ' num2str(cell_V_max*noCells_s_module*no_modules) ' V' ...
                 ', ' num2str(mass_pack_Li) ' kgs'];

disp(['Battery: ' batpk_desc]);

x=0.05:0.001:1; %SOC

%fitting the data points for an equation
fit_v_plot=polyfit(bat_soc_idx,cell_voc,8);
val_v_plot=polyval(fit_v_plot,x);

fit_r_chg_plot=polyfit(bat_soc_idx,cell_r_chg,8);
val_r_chg_plot=polyval(fit_r_chg_plot,x);

fit_r_dis_plot=polyfit(bat_soc_idx,cell_r_dis,8);
val_r_dis_plot=polyval(fit_r_dis_plot,x);

val_v_pack_plot=polyval(fit_v_plot,x)*scaling_factor;
val_r_chg_pack_plot=polyval(fit_r_chg_plot,x)*scaling_factor;
val_r_dis_pack_plot=polyval(fit_r_dis_plot,x)*scaling_factor;

% figure
% plot(x,val_v_pack_plot)
% xlabel('SOC'),ylabel('Voc volts')
% 
% figure
% plot(x,val_r_chg_pack_plot)
% hold on
% plot(x,val_r_dis_pack_plot)
% xlabel('SOC'),ylabel('Rint ohms')
% legend('Rint during charging','Rint during discharging')
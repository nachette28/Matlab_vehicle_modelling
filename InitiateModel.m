%% load driving cycles
clear all;
close all;
clc;


%% Simulation Parameters
tstop = 780;                            % simulation run time [sec]
tstep = .01;                            % maximum simulation step [sec]

%% Driver model parameters
Ti = 50;                                % integral time constant
Kv = 650;                               % proportional gain 


%% Transmission Parameters

gratio=5.5;
g_rat_electric = 3.06;

%% Wheel Parameters
rw = 0.668/2;                           % wheel radius for 275/40/r18 tire [m]      

%% Chasiss parameters
S_weight=800;

%% Battery cells data                   %Based on data from a samsung inr 50E cell
cell_capacity=5.0;                      %capacity of a single 21700 cell [Ah]
cell_nom_v=3.7;                         %cell's nominal voltage
cell_max_v=4.2;                         %cell's maximum allowable voltage [V]
cell_cutoff_v=3.2;                      %cell's lower cut-off voltage [V]
cell_energy=cell_capacity*cell_nom_v;   %total cell energy [Wh]
cell_nom_curr=15;                       %cell's maximum continuous current [A]
cell_max_curr=20;                       %cell's maximum intantaneus current [A]



success = false;
while ~success
    b = input('Select the gear ratio for the vehicle (0=default, 1=short, 2=medium or 3=tall)     ');
    switch b
        case 0
            disp ('The gear ratio will remain unaltered (5.5:1)')
            success = true;
        case 1
            gratio=3;
            disp ('The gear ratio selected is 3:1')
            success = true;
        case 2
            gratio=5;
            disp ('The gear ratio selected is 5:1')
            success = true;
        case 3 
            gratio=7;
            disp ('The gear ratio selected is 7:1')
            success = true;
        otherwise
            disp('Please, select one of the available options')
            success = false;
    end
end

success = false;
while ~success
    b = input('Select the desired battery pack size (1=small, 2=medium or 3=large)     ');
    switch b
        case 1
            disp ('The battery size is 30 kWh')
            batt_cap = 30
            success = true;
        case 2
            disp ('The battery size is 50 kWh')
            batt_cap = 50;
            success = true;
        case 3 
            disp ('The battery size is 70 kWh')
            batt_cap = 70;
            success = true;
        otherwise
            disp('Please, select one of the available options')
            success = false;
    end
end
success = false;
while ~success
    b = input('Select the number of motors for the FRONT axle (choose 0, 1 or 2)     ');
    switch b
        case 0
            disp ('The front axle of the vehicle is not driven by any motor')
            front_motor = 0;
            success = true;
        case 1
            disp ('Front axle has 1 motor powering both wheels')
            front_motor = 1;
            success = true;
        case 2 
            disp ('Front axle has 2 individual motors on each wheel')
            front_motor = 2;
            success = true;
        otherwise
            disp('Please, select one of the available options')
            success = false;
    end
end
success = false;
while ~success
    b = input('Select the number of motors for the REAR axle (choose 0, 1 or 2)     ');
    switch b
        case 0
            disp ('The Rear axle of the vehicle is not driven by any motor')
            rear_motor = 0;
            success = true;
        case 1
            disp ('Rear axle has 1 motor powering both wheels')
            rear_motor = 1;
            success = true;
        case 2 
            disp ('Rear axle has 2 individual motors on each wheel')
            rear_motor = 2;
            success = true;
        otherwise
            disp('Please, select one of the available options')
            success = false;
    end
end

%% Battery pack chracteristics

pack_desired_v=540;
batt_cells=roundn(((batt_cap*1e3)/cell_energy), 1);             %Calculates number of battery cells based on chosen battery size
cell_series=roundn((pack_desired_v/cell_nom_v),0);              %number of cells arrange in series connection
batt_nom_v=cell_series*cell_nom_v;                              %naminal battery voltage (assuming 4.2v as maximum cell voltage)
batt_max_v=cell_series*cell_max_v;                              %naminal battery voltage (assuming 4.2v as maximum cell voltage)
cells_parallel=roundn((batt_cells/cell_series),1);              %calculates the number of paralle arranged cells
Capacity=batt_cap*1e3*3600;                                     %transforms the chosen battery energy from kWh to Jules
SOC_0 = 80;                                                     % Initial battery state of charge [%]
Vbat=cell_series*3.7;                                           %battery pack nominal voltage [V]


 %% Calculates the weight of the battery  
        
                                            
        cells_weight=(batt_cells*0.069);
        batt_weight=cells_weight*1.5;                           %battery pack weight asumming each cell weights 69g nad a factor 
                                                                %of 1.5 to account for the packs auxiliary elements such as nikel 
                                                                %strips and batthery charge controllers
        max_curr=cell_max_curr*cells_parallel ;                 %max battery output current assuming peack discharge of 15A
        nom_curr=cell_nom_curr*cells_parallel ;                 %nominal battery output current assuming peack discharge of 10A
        max_batt_pwr=max_curr*batt_nom_v*1e-3;                  %maximum battery power output in kW
        batt_pwr=nom_curr*batt_nom_v*1e-3;                      %nominal battery power output

        %% Inverter parameters
        inv_eff=0.96;
        regen_eff=0.75;

%% Electric Motor Parameters
load MotorEff;                              % Electric Motor Efficiency Data
Ke = 0.607;                                 % Torque Constant [Nm/A] (slope of the torque / current curve of the motor)
Pe_max = 120e3;                             % Maximum Motor Power [W]
Wbase = 400;                                % Electric motor base speed [rad/s]
Te_max = Pe_max/Wbase;    % Maximum motor torque [Nm]
Fv_max = Te_max*gratio/rw;          % Maximum vehicle tractive force[N]

%Br_th=0.3*Fv_max_electric;                  % Brake thersshols expressed as a percentage of Fv_max_electric (UNIMPEMENTED)
             

%% Calculates the total mass of the vehicel given previous inputs  
base_weight = 1100;                                     %weight of the base vehicle chasis witchout powertrain
M_weight=140;                                           %weight for each added motor in kg (tesla motor taken as reference)
motor_weight = M_weight*(rear_motor+front_motor);       %calculates the total weight of all motors existent in the vehicle
Mv = (base_weight+batt_weight+motor_weight);            %calculates the total vehicle weight used for the dynamic equations

%% Calculates the tire vertical force

        
        if (front_motor == 1 || front_motor == 2) && rear_motor == 0
            weight_dist=0.3;                         %weight ratio for the rear axle
            Fz_tire=(Mv*weight_dist*0.5)*9.81  ;            %calculates vertical force acting on an individual tire
            X=['Individual tire force is ',num2str(Fz_tire), ' N'] ;
            Y=['Vehicle weight is ',num2str(Mv),' kg, with a battery capacity of ',num2str(batt_cap*1e3), ' Wh'] ;
            Z=['Battery maximum continupus current is ',num2str(nom_curr),' A with a maximum power of ',num2str(batt_cap), ' kW'];
            disp (X)
            disp (Y)
            disp (Z)
        elseif (rear_motor == 1 || rear_motor == 2) && front_motor == 0
            weight_dist=0.65;                        %weight ratio for the rear axle
            Fz_tire=(Mv*weight_dist*0.5 )*9.81 ;            %calculates vertical force acting on an individual tire
            X=['Individual tire force is ',num2str(Fz_tire), ' N'] ;
            Y=['Vehicle weight is ',num2str(Mv),' kg, with a battery capacity of ',num2str(batt_cap*1e3), ' Wh'];
            Z=['Battery maximum continuous current is ',num2str(nom_curr),' A with a maximum power of ',num2str(batt_cap), ' kW'];
            disp (X)
            disp (Y)
            disp (Z)
        elseif (front_motor == 1 || front_motor == 2) && (rear_motor == 1 || rear_motor == 2) 
            weight_dist=0.45;                        % Vehicles weight distribution fore-aft (0-1)
            Fz_tire = (Mv * weight_dist * 0.5)*9.81   ;           %calculates vertical force acting on an individual tire
            X=['Individual tire force is ',num2str(Fz_tire), ' N'] ;
            Y=['Vehicle weight is ',num2str(Mv),' kg, with a battery Capacity of ',num2str(batt_cap*1e3), ' Wh'];
            Z=['Battery maximum continuos current is ',num2str(nom_curr),' A with a maximum power of ',num2str(batt_pwr), ' kW'];
            disp (X)
            disp (Y)
            disp (Z)
        end
            
        

%% DC-DC Converter Parameters
eta_DC = .985;               % DC-DC Converter Efficiency (constant)
Vbus_ref = 600;             % DC Bus Voltage Reference (constant) [V]

%% Inverter Parameters
eta_inv = .965;              % Inverter Efficiency (constant)

%% Torque vectoring parameters
opt_slip=0.18;    %optimum tire slip ratio
Tv_gain=800;

%% Vehicle physical parameters

Cd = 0.26;                  % Coefficient of Drag	    
Cr = 0.01;                  % Coefficient of Friction   
Av = 2.75;                  % Front area [m^2]
rho_air = 1.204;            % Air density [kg/m^3]
grade=0;                    % Grade of the road [�]
grav=9.81;
motoreff_T=linspace(0,300,101);
 
%% Sample times
s_time=0.01;
%% tire model parameters for friction calculation

%dry road
 b_d = 10.0;
 c_d = 1.9;
 d_d = 1;
 e_d = 0.97;
 
 %wet road
 b_w = 12;
 c_w = 2.3;
 d_w = 0.82;
 e_w = 1;

 %snowy road
 b_s = 5;
 c_s = 2;
 d_s = 0.3;
 e_s = 1;
 
 %ice road
 b_i = 4;
 c_i = 2;
 d_i = 0.1;
 e_i = 1;
 
 %% Tire selector
 
 %%selects surface for left tire
%clc

tire_L = input('what is the left tire''s surface? (d=dry, w=wet, s=snow, i=ice): ','s');
if strcmp(tire_L,'s')
disp('Left tire surface is snow')
    b_l=b_s;
    c_l=c_s;
    d_l=d_s;
    e_l=e_s;
elseif strcmp(tire_L,'d')
    disp('Left tire surface is dry')
    b_l=b_d;
    c_l=c_d;
    d_l=d_d;
    e_l=e_d;
elseif strcmp(tire_L,'i')
    disp('Left tire surface is ice')
    b_l=b_i;
    c_l=c_i;
    d_l=d_i;
    e_l=e_i;
elseif strcmp(tire_L,'w')
    disp('Right tire surface is wet')
    b_l=b_w;
    c_l=c_w;
    d_l=d_w;
    e_l=e_w;
else
    disp('Select a correct surface type for the left tire.')

end


tire_R = input('what is the right tire''s surface? (d=dry, w=wet, s=snow, i=ice): ','s');
if strcmp(tire_R,'s')
     disp('Right tire surface is snow')
    b_r=b_s;
    c_r=c_s;
    d_r=d_s;
    e_r=e_s;
elseif strcmp(tire_R,'d')
   disp('Right tire surface is dry')
    b_r=b_d;
    c_r=c_d;
    d_r=d_d;
    e_r=e_d;
elseif strcmp(tire_R,'i')
    disp('Right tire surface is ice')
    b_r=b_i;
    c_r=c_i;
    d_r=d_i;
    e_r=e_i;
elseif strcmp(tire_R,'w')
    disp('Right tire surface is wet')
    b_r=b_w;
    c_r=c_w;
    d_r=d_w;
    e_r=e_w;
else
    disp('Select a correct surface type for the right tire.')
end
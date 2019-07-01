%% load driving cycles
clear all;
close all;
clc;
thisPath = strrep(mfilename('fullpath'),mfilename,'');
addpath([thisPath 'images']);
% addpath([thisPath 'drivingCycles']);
% load eudc;                  % simulation time: 1200
% load us06;                  % simulation time: 600 
% load udds;                  % simulation time: 13801
% load hwy;                   % simulation time: 780
% load mph60;                 % simulation time: 10000

%% Simulation Parameters
tstop = 780;                 % simulation run time [sec]
tstep = .01;                % maximum simulation step [sec]

%% Driver model parameters
Ti = 50;                    % integral time constant
Kv = 650;                   % proportional gain 


%% Transmission Parameters
g_rat_electric = 3.06;      % Transmission reduction ratio electric

gratio=5.3;
%% Wheel Parameters
rw = 0.668/2;                   % wheel radius for 275/40/r18 tire [m]      

%% Chasiss parameters
S_weight=800;
%% Battery Model Parameters
cell_capacity=5.0;  %capacity of a single 18650 cell in Ah
cells_parallel=18;     %number of cells arrange in parallel connection
cells_series=143;    %number of cells arrange in series connection
max_batt_v=cells_series*4.2;     %maximum battery voltage (assuming 4.2v as maximum cell voltage)
pack_capacity=cells_parallel*cell_capacity*cells_series*3.7;   %maximum design battery pack capacity
%Capacity = pack_capacity*3600;       % Battery pack capacity [J] = Wh*3600
SOC_0 = 80;                 % Initial battery state of charge [%]
Vbat=cells_series*3.7;  % battery pack nominal voltage [V]

    cap=input('Slect the battery size for the vehicle s = short range m = medium range l = long range   ','s')
    %s=30kwh m=50kwh l=70kwh;
    if strcmp(cap,'s')
        cap=50;
        Capacity=cap*3600;                       %transforms the chosen battery cpacity to jules
        B_cells=roundn((cap/3.7),1);             %Calculates number of battery cells based on chosen battery size
        B_weight=(B_cells*0.069)*1.3;            %battery pack weight asumming each cell weights 69g
        cells_parallel=roundn(cap*1e3/650,1);    %calculates the number of parallel cells
        max_curr=15*cells_parallel;              %max battery output current assumin peack discharge of 15A
    elseif strcmp(cap,'m')
        cap=50;
        Capacity=cap*3600;                       %transforms the chosen battery cpacity to jules
        B_cells=roundn((cap/3.7),1);             %Calculates number of battery cells based on chosen battery size
        B_weight=(B_cells*0.069)*1.3;            %battery pack weight in kg asumming each cell weights 69g
        cells_parallel=roundn(cap*1e3/650,1) ;   %calculates the number of parallel cells
        max_curr=15*cells_parallel;              %max battery output current assumin peack discharge of 15A
    elseif strcmp(cap,'l')
        cap=70;
        Capacity=cap*3600;                       %transforms the chosen battery cpacity to jules
        B_cells=roundn((cap/3.7),1);             %Calculates number of battery cells based on chosen battery size
        B_weight=(B_cells*0.069)*1.3;            %battery pack weight asumming each cell weights 69g
        cells_parallel=roundn(cap*1e3/650,1) ;   %calculates the number of parallel cells
        max_curr=15*cells_parallel;              %max battery output current assumin peack discharge of 15A
    else
        disp('Plese slect one of the abobe options')
    end

%% Electric Motor Parameters
load MotorEff;              % Electric Motor Efficiency Data
Ke = 0.607;                 % Torque Constant [Nm/A]
Pe_max = 120e3;              % Maximum Motor Power [W]
Vbase = 14.30;              % Base speed [m/s]
Te_max_electric = Pe_max*rw/g_rat_electric/Vbase;       % Maximum motor torque electric[Nm]
Fv_max_electric = Te_max_electric*g_rat_electric/rw;    % Maximum vehicle tractive force electric[N]
Fv_max = 2*Fv_max_electric;                   % Maximum vehicle tractive force[N]
Te_max = 2*Te_max_electric;                   % Maximum motor torque [Nm]

Br_th=0.3*Fv_max_electric;                    %Brake thersshols expressed as a percentage of Fv_max_electric 
M_weight=135                   %gives the weight of the motor and auxiliary components such as reduction gears and controller
%% motor selector

    driven_axle=input('Slect one of the following layouts [1=fwd, 2=rwd, 3=awd]   ');
    if strcmp(driven_axle,'fwd')
        driven_axle=1
    elseif strcmp(driven_axle,'rwd')
        driven_axle=2
    elseif strcmp(driven_axle,'awd')
        driven_axle=3
    else
        disp('Plese slect one of the abobe options')
    end
    
    n_motors = input('How many motors should the drivetrain have [1,2 or 4]?      ');
    if strcmp(n_motors,'1')
        if driven_axle==1
            n_motors=1;
            dip('drivetrain will have one front motor')
        elseif driven_axle == 2
            n_motors=1;
            dip('drivetrain will have one front motor')
        else
            error('Allowable inpts are only 1 or 2')
        end
        
    elseif strcmp(n_motors,'2')
        if driven_axle==1 
            n_motors=2;
            disp('drivetrain will have two individually controlled motors in the front axle')
        elseif driven_axle==2
            n_motors=2
            disp('drivetrain will have two individually controlled motors in the rear axle')
        elseif driven_axle==1
            error('Allowable inpts are only 1 or 2')
        
        elseif driven_axle==3
            n_motors=2;
        else
            error('Allowable inpts are only 1 or 2')
        end
    elseif strcmp(n_motors,'4')
        if driven_axle==1
            disp('option selected is not compatible with previously chosen drivetrain layou')
        end
        if driven_axle==2
            disp('option selected is not compatible with previously chosen drivetrain layou')
        end
        if driven_axle==3
            n_motors=4;
        end
    end
%% Calculates the total mass of the vehicel given previous inputs    
    if driven_axle==1 && n_motors==1
        Mv=M_weight*1+B_weight+S_weight;
        Tire_N_force=n_motors*M_weight*1.8
    elseif driven_axle==1 && n_motors==2
        Mv=M_weight*1+B_weight+S_weight;
        Tire_N_force=n_motors*M_weight*1.8
    elseif driven_axle==2 && n_motors==1
        Mv=M_weight*1+B_weight+S_weight;
        Tire_N_force=n_motors*M_weight*2.5
    elseif driven_axle==2 && n_motors==2
        Mv=M_weight*1+B_weight+S_weight;
        Tire_N_force=n_motors*M_weight*2.5
    elseif driven_axle==3 && n_motors==2
        Mv=M_weight*1+B_weight+S_weight;
        Tire_N_force=n_motors*M_weight*1.8
    elseif driven_axle==3 && n_motors==4
        Mv=M_weight*1+B_weight+S_weight;
        Tire_N_force=n_motors*M_weight*1.8
    end

%% DC-DC Converter Parameters
eta_DC = .985;               % DC-DC Converter Efficiency (constant)
Vbus_ref = 530;             % DC Bus Voltage Reference (constant) [V]

%% Inverter Parameters
eta_inv = .965;              % Inverter Efficiency (constant)

%% Torque vectoring parameters

Tv_gain=800;

%% Vehicle physical parameters
Mv = 1420;                  % Vehicle curb weight + 120 kg passenger and carg0
W_d = 0.5;                  % Vehicles weight distribution fore-aft (0-1)
Cd = 0.26;                  % Coefficient of Drag	    
Cr = 0.01;                  % Coefficient of Friction   
Av = 2.75;                  % Front area [m^2]
rho_air = 1.204;            % Air density [kg/m^3]
grade=0;                    % Grade of the road [percentage]
grav=9.81;
 
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
%     disp('Left tire surface is 'tire_l)
    b_l=b_s;
    c_l=c_s;
    d_l=d_s;
    e_l=e_s;
elseif strcmp(tire_L,'d')
%    disp('Left tire surface is 'tire_l)
    b_l=b_d;
    c_l=c_d;
    d_l=d_d;
    e_l=e_d;
elseif strcmp(tire_L,'i')
%    disp('Left tire surface is 'tire_l)
    b_l=b_i;
    c_l=c_i;
    d_l=d_i;
    e_l=e_i;
elseif strcmp(tire_L,'w')
%    disp('Right tire surface is 'tire_l)
    b_l=b_w;
    c_l=c_w;
    d_l=d_w;
    e_l=e_w;
else
    disp('Select a correct surface type for the left tire.')

end


tire_R = input('what is the right tire''s surface? (d=dry, w=wet, s=snow, i=ice): ','s');
if strcmp(tire_R,'s')
%     disp('Right tire surface is 'tire_R)
    b_r=b_s;
    c_r=c_s;
    d_r=d_s;
    e_r=e_s;
elseif strcmp(tire_R,'d')
 %   disp('Right tire surface is 'tire_R)
    b_r=b_d;
    c_r=c_d;
    d_r=d_d;
    e_r=e_d;
elseif strcmp(tire_R,'i')
%    disp('Right tire surface is 'tire_R)
    b_r=b_i;
    c_r=c_i;
    d_r=d_i;
    e_r=e_i;
elseif strcmp(tire_R,'w')
%    disp('Right tire surface is 'tire_R)
    b_r=b_w;
    c_r=c_w;
    d_r=d_w;
    e_r=e_w;
else
    disp('Select a correct surface type for the right tire.')
end

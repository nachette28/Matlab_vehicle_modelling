close all;

figuresdir = '/home/ignacio/Dropbox/Q2_2018_19_drop/TFG/Thesis/Images/';

success = false;
while ~success
    b = input('Do you want to save the generated plots? 1=yes 2=no     ');
    switch b
        case 1
            disp ('The plots will be saved to seleced folder')
            save = 1;
            success = true;
        case 2
            disp ('The plots will not be saved')
            save = 2;
            success = true;
        otherwise
            disp('Please, select one of the available options')
            success = false;
    end
end


load('Pmec_single.mat');
load('Ve_speed_single.mat');
load('Left_torque_single.mat');
load('dist_single.mat');
load('E_single.mat');
load('SOC_single.mat');
load('drivetrain_losses_single.mat');
load('slip_right_single.mat');

load('Pmec_triple.mat');
load('Ve_speed_triple.mat');
load('Left_torque_triple.mat');
load('dist_triple.mat');
load('E_triple.mat');
load('SOC_triple.mat');
load('drivetrain_losses_triple.mat');
load('slip_right_triple.mat');


figure(1);
hold on;
plot(Ve_speed_triple.time/60, Ve_speed_triple.signals.values(:,1)*3.6, 'b', 'LineWidth', 0.7);
plot(Ve_speed_single.time/60, Ve_speed_single.signals.values(:,1)*3.6, 'r', 'LineWidth', 0.7);
legend('Layout 2','Layout 1');
title('Vehicle speeds');
ylabel('Speed [km/h]');
xlabel('Time [min]');
%set(gca, 'XTickLabel', []);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'vehicle_speeds_comp'),'png');
else
end


figure(2);
hold on;
plot(Ve_speed_triple.time/60, 2*Left_torque_triple.signals.values(:,1), 'b', 'LineWidth', 1);
plot(Ve_speed_single.time/60, 2*Left_torque_single.signals.values(:,1), 'r', 'LineWidth', 0.7);
legend('Layout 2', 'Layout 1');
title('Vehicle output torque');
ylabel('Torque [Nm]');
xlabel('Time [min]');
%set(gca, 'XTickLabel', []);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'vehicle_torque_comp'),'png');
else
end


figure(3);
hold on;
plot(dist_triple.signals.values(:,1), SOC_triple.signals.values(:,1), 'b', 'LineWidth', 0.6);
plot(dist_single.signals.values(:,1), SOC_single.signals.values(:,1), 'r', 'LineWidth', 0.6);
title('Battery SOC vs. Distance travelled');
legend('Layout 2','Layout 1');
ylabel('Battery SOC [%]');
xlabel('Distance [km]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'SOC_comp'),'png');
else
end


figure(4);
hold on
plot(Pmec_triple.time/60, Pmec_triple.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(Pmec_single.time/60, Pmec_single.signals.values(:,1), 'r', 'LineWidth', 0.5);
legend('Layout 2', 'Layout 1');
title('Mechanical power output');
ylabel('Power output [kW]');
xlabel('Time[min]');
%set(gca, 'XTickLabel', []);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'Pmec_comp'),'png');
else
end


figure(5);
hold on;
plot(drivetrain_losses_triple.time/60, drivetrain_losses_triple.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(drivetrain_losses_single.time/60, drivetrain_losses_single.signals.values(:,1), 'r', 'LineWidth', 0.5);
title('Drivetrain losses');
legend ('Layout 2','Layout 1')
ylabel('Power losses [W]');
xlabel('Time [min]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'drivetrain_losses_comp'),'png');
else
end


figure(6);
hold on;
plot(slip_right_triple.time/60, slip_right_triple.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(slip_right_single.time/60, slip_right_single.signals.values(:,1), 'r', 'LineWidth', 0.5);
legend('Layout 2', 'Layout 1');
xlim([0.5 7.5])
ylim([-0.4 0.4])
title('Wheel slip');
ylabel('Force [N]');
xlabel('Time [min]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'slip_comp'),'png');
else
end

figure(7);
plot(dist_single.time/60, dist_triple.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(dist_single.time/60, dist_single.signals.values(:,1), 'r', 'LineWidth', 0.5);
legend('Layout 2', 'Layout 1');
title('Distance travelled');
ylabel('Distance [km]');
xlabel('Time [min]');
xlim([0 8])

grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'distance_comp'),'png');
else
end


figure (8);
hold on;
plot(dist_triple.signals.values(:,1), E_triple.signals.values(:,1), 'r', 'LineWidth', 0.8);
plot(dist_single.signals.values(:,1), E_single.signals.values(:,1), 'b', 'LineWidth', 0.8);
title('Consumed energy vs distance travelled');
xlabel('Distance [km]');
ylabel('Energy [kWh]');
legend('Layout 2', 'Layout 1')
if save==1
    saveas(gcf,strcat(figuresdir,'energy_comp'),'png')
else
end
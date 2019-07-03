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

figure(1);
hold on;
plot(speeds.time/60, R_speed.signals.values(:,1)*3.6, 'b', 'LineWidth', 0.7);
plot1.Color(4) = 0.2;
plot(speeds.time/60, L_speed.signals.values(:,1)*3.6, 'r', 'LineWidth', 0.6);
plot1.Color(4) = 0.2;
plot(speeds.time/60, Cm_speed.signals.values(:,1)*3.6, 'y', 'LineWidth', 0.5);
plot(speeds.time/60, Ve_speed.signals.values(:,1)*3.6, 'k', 'LineWidth', 0.4);
legend('Right wheel speed','Left wheel speed','Reference Speed','Vehicle speed');
title('Vehicle speeds');
ylabel('Speed [km/h]');
set(gca, 'XTickLabel', []);
xlim([0 8]);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'vehicle_speeds'),'png');
else
end

figure(2);
hold on;
plot(Forces.time/60, Left_torque.signals.values(:,1), 'b', 'LineWidth', 1);
plot(Forces.time/60, Right_torque.signals.values(:,1), 'r', 'LineWidth', 0.7);
plot(Forces.time/60, Commanded_torque.signals.values(:,1), 'k', 'LineWidth', 0.4);
legend('Left tire torque', 'Right tire torque', 'Torque command');
title('Vehicle output torque');
ylabel('Torque [Nm]');
xlabel('Time [min]');
set(gca, 'XTickLabel', []);
xlim([0 8]);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'torque_output'),'png');
else
end

figure(3);
hold on;
plot(dist.signals.values(:,1), SOC.signals.values(:,1), 'b', 'LineWidth', 1.5);
title('Battery SOC vs. Distance travelled');
legend('Battery SOC]');
ylabel('Battery SOC [%]');
xlabel('Distance [km]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'tevelled_distance'),'png');
else
end


figure(4);
hold on
plot(aero_losses.time/60, aero_losses.signals.values(:,1), 'b', 'LineWidth', 0.7);
plot(rolling_losses.time/60, rolling_losses.signals.values(:,1), 'm', 'LineWidth', 0.7);
plot(incline_losses.time/60, incline_losses.signals.values(:,1), 'k', 'LineWidth', 0.7);
%plot(speeds.time/60, speeds.signals.values(:,1), 'k', 'LineWidth', 0.7);
legend('Aero losses', 'Rolling resitance losses','Incline losses');
title('Power losses due to the environment');
ylabel('Power [W]');
xlabel('Time [min]');
%set(gca, 'XTickLabel', []);
xlim([0 8]);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'power_losses_vehicle'),'png');
else
end

figure(5);
hold on;
plot(dcdc_losses.time/60, motor_losses.signals.values(:,1), 'k', 'LineWidth', 0.3);
plot(dcdc_losses.time/60, gearbox_losses.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(dcdc_losses.time/60, inverter_losses.signals.values(:,1), 'm', 'LineWidth', 0.5);
plot(dcdc_losses.time/60, dcdc_losses.signals.values(:,1), 'r', 'LineWidth', 0.5);
title('Drivetrain losses');
legend ('Motor losses','Gearbox losses','Inverter losses','DcDc losses');
ylabel('Power losses [W]');
xlabel('Time [min]');
xlim([0 8]);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'drivetrain_losses'),'png');
else
end

figure(6);
hold on;
plot(Ibat1.time/60, Iabc.signals.values(:,1), 'y', 'LineWidth', 0.5);
plot(Iinv.time/60, Iinv.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(Ibat.time/60, Ibat.signals.values(:,1), 'r', 'LineWidth', 0.5);

legend('Battery Current','Inverter Input Current','Inverter Output Current');
title('Vehicle current draw');
ylabel('Current [A]');
xlabel('time [min]');
xlim([0 8]);
grid on;
if save ==1
    saveas(gcf,strcat(figuresdir,'current_plot'),'png');
else
end

figure(7);
hold on;
x=1:10:1200;
y=23700./x;
plot(x,y);
axis([0 1200 0 400]);
contour(motoreff_w, motoreff_T, motoreff);
plot(wr.signals.values(:,1), Left_torque.signals.values(:,1),'k', 'LineWidth', 1);
plot(wr.signals.values(:,1), Right_torque.signals.values(:,1),'r', 'LineWidth', 1);
title('Motor efficency');
xlabel('Motor Angular Speed [rad/s]');
ylabel('Motor Torque [Nm]');
legend('Motor Efficiency','Drive cycle');
if save == 1
    saveas(gcf,strcat(figuresdir,'Motor_efficiency'),'png');
else
end

figure(8);
hold on;
plot(tv_R.time/60, tv_R.signals.values(:,1), 'b', 'LineWidth', 0.7);
plot(tv_L.time/60, tv_L.signals.values(:,1), 'r', 'LineWidth', 0.7);
plot(Right_torque.time/60, Commanded_torque.signals.values(:,1), 'k', 'LineWidth', 0.7);
legend('Right motor torque', 'Left motor torque','Torque command');
title('Motor torque outputs');
ylabel('Torque [Nm]');
xlabel('time [min]');
xlim([5 8])
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'TC_output'),'png');
else
end

figure(9);
hold on;
plot(slip_left.time/60, slip_left.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(traction_correction_l.time/60, traction_correction_l.signals.values(:,1),'r','LineWidth', 0.5);
legend('Left wheel slip ratio', 'Traction control intervention Left');
xlim([0.5 7])
ylim([-0.4 0.4])
title('Left wheel slip and T.C intervention');
ylabel('Force [N]');
xlabel('time [min]');
grid on;
if save == 1
    saveas(gcf,strcat(figuresdir,'left_slip_intervention'),'png');
else
end

figure(10);
hold on;
plot(slip_right.time/60, slip_right.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(traction_correction_r.time/60, traction_correction_r.signals.values(:,1)*0.001,'r','LineWidth', 0.5);
legend('Right wheel slip ratio', 'Traction control intervention Right');
xlim([0.5 7])
ylim([-0.4 0.4])
title('Right wheel slip and T.C intervention');
ylabel('Force [N]');
xlabel('time [min]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'right_slip_intervention'),'png');
else
end

figure(11);
plot(dist.signals.values(:,1), slope.signals.values(:,1), 'r', 'LineWidth', 1);
legend('Slope');
title('Slope profile');
ylabel('Slope [%]');
xlabel('time [min]');
xlim([0 7])

grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'elevation_profile'),'png');
else
end

 figure(12);
 hold on;
 plot(steering_angle.time/60, steering_angle.signals.values(:,1), 'k', 'LineWidth', 0.7);
 plot(tv_right.time/60, tv_right.signals.values(:,1),'b','LineWidth', 1.7);
 plot(tv_left.time/60,tv_left.signals.values(:,1),'r','LineWidth', 0.7);
 xlim([0 8]);
 legend('Steering input','Right torque output', 'Left torque output');
 title('Lateral torque vectoring output');
 xlim([4 8]);
 ylabel('Torque [Nm]');
 xlabel('time [min]');
 grid on;
 if save==1
     saveas(gcf,strcat(figuresdir,'left_slip'),'png')
 else
 end

figure (13);
hold on;
plot(dist.signals.values(:,1), E_batt.signals.values(:,1), 'r', 'LineWidth', 0.8);
plot(dist.signals.values(:,1), energy_regen.signals.values(:,1), 'b', 'LineWidth', 0.8);
legend('Energy used','Regen energy');
title('Consumed energy vs distance travelled');
xlabel('Distance [km]');
ylabel('Energy [kWh]');
if save==1
    saveas(gcf,strcat(figuresdir,'energy_vs_dist'),'png')
else
end
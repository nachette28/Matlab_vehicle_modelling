
figuresdir = '/home/ignacio/Dropbox/Q2_2018_19_drop/TFG/Thesis/Images/';

success = false;
while ~success
    b = input('Do you want to save the generated plots? 1=yes 2=no     ');
    switch b
        case 1
            disp ('The plots will be saved to ', figuresdir)
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

subplot(3,1,1);
hold on;
plot(speeds.time/60, speeds.signals.values(:,1)*3.6, 'b', 'LineWidth', 1.5);
plot(speeds.time/60, speeds.signals.values(:,2)*3.6, 'r', 'LineWidth', 1.5);
legend('Reference Speed', 'EV Speed');
title('Vehicle speeds');
ylabel('Speed [km/h]');
xlabel('Time [min]');
set(gca, 'XTickLabel', []);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'vehicle_speeds'),'epsc');
else
end

subplot(3,1,2);
hold on;
plot(Forces.time/60, Forces.signals.values(:,1), 'b', 'LineWidth', 1.5);
plot(Forces.time/60, Forces.signals.values(:,2), 'r', 'LineWidth', 1.5);
legend('Drive Force', 'Resistive Force');
title('Vehicle forces');
ylabel('Force [N]');
xlabel('Time [min]');
set(gca, 'XTickLabel', []);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'vehicle_forces'),'epsc');
else
end

subplot(3,1,3);
hold on;
plot(dist.time/60, dist.signals.values, 'b', 'LineWidth', 1.5);
title('Distance travelled');
ylabel('Distance Traveled [km]');
xlabel('time [min]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'tevelled_distance'),'epsc');
else
end

figure(2);

subplot(3,1,1);
hold on;
plot(P.time/60, P.signals.values(:,1)-Pmec.signals.values(:,1), 'b', 'LineWidth', 1.5);
plot(Pmec.time/60, Pmec.signals.values(:,1), 'r', 'LineWidth', 1.5);
legend('Pelectric', 'Pmecanic');
title('Vehicle power output');
ylabel('Inst. Power [kW]');
xlabel('Time [min]');
set(gca, 'XTickLabel', []);
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'power_output'),'epsc');
else
end

subplot(3,1,2);
hold on;
plot(SOC.time/60, SOC.signals.values(:,1), 'b', 'LineWidth', 1.5);
title('Battery SOC');
ylabel('Battery SOC [%]');
xlabel('time [min]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'Battery SOC'),'epsc');
else
end

subplot(3,1,3);
hold on;
plot(Iinv.time/60, Iinv.signals.values(:,1), 'b', 'LineWidth', 0.5);
plot(Ibat.time/60, Ibat.signals.values(:,1), 'r', 'LineWidth', 0.5);
%plot(Ibat1.time/60, Ibat.signals.values(:,1), 'y', 'LineWidth', 0.5);
legend('Inverter Input Current', 'Battery Current');
title('Vehicle current draw');
ylabel('Current [A]');
xlabel('time [min]');
grid on;
if save ==1
    saveas(gcf,strcat(figuresdir,'current_plot'),'epsc');
else
end

figure(3);

hold on;
x=1:10:1200;
y=23700./x;
plot(x,y);
axis([0 1200 0 350]);
contour(motoreff_w, motoreff_T, motoreff);
plot(speeds.signals.values(:,2)/rw*gratio, Forces.signals.values(:,1)*rw/gratio,'k', 'LineWidth', 3);
title('Motor efficency');
xlabel('Motor Angular Speed [rad/s]');
ylabel('Motor Torque [Nm]');
legend('Motor Efficiency','Drive cycle');
if save == 1
    saveas(gcf,strcat(figuresdir,'Motor_efficiency'),'epsc');
else
end

figure(4);

subplot(3,1,1);
hold on;
plot(Right_torque.time/60, Right_torque.signals.values(:,1), 'b', 'LineWidth', 1.5);
plot(Left_torque.time/60, Left_torque.signals.values(:,1), 'r', 'LineWidth', 1.5);
plot(Commanded_torque.time/60, Commanded_torque.signals.values(:,1), 'g', 'LineWidth', 1.5);
legend('Right motor torque', 'Left motor torque','Torque command');
title('Motor torque outputs');
ylabel('Torque [Nm]');
xlabel('Time [min]');
xlim([0 2])
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'torque_output'),'epsc');
else
end

subplot(3,1,2);
hold on;
plot(slip_left.time/60, slip_leftsignals.values(:,1), 'b', 'LineWidth', 1.5);
plot(traction_correction_l.time/60, traction_correction_l.signals.values(:,1),'r','LineWidth', 1.5);
legend('Left wheel slip ratio', 'Traction control intervention Left');
xlim([0 2])
ylim([-0.2 0.2])
title('Right wheel slip and T.C intervention');
ylabel('Force [N]');
xlabel('Time [min]');
grid on;
if save == 1
    saveas(gcf,strcat(figuresdir,'left_slip_intervention'),'epsc');
else
end
subplot(3,1,3);
hold on;
plot(slip_right.time/60, slip_right.signals.values(:,1), 'b', 'LineWidth', 1.5);
plot(traction_correction_r.time/60, traction_correction_r.signals.values(:,1),'r','LineWidth', 1.5);
legend('Right wheel slip ratio', 'Traction control intervention Right');
xlim([0 2])
ylim([-0.2 0.2])
title('Right wheel slip and T.C intervention');
ylabel('Force [N]');
xlabel('Time [min]');
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'right_slip_intervention'),'epsc');
else
end

figure(5);

subplot(2,1,1);
hold on;
plot(slope.time/60, slope.signals.values(:,1), 'b', 'LineWidth', 1.5);
legend('Slope');
title('Slope profile');
ylabel('Slope [%]');
xlabel('Time [min]');
xlim([0 2])
grid on;
if save==1
    saveas(gcf,strcat(figuresdir,'elevation_profile'),'epsc');
else
end

hax=subplot(2,1,2);
hold on;
plot(slip_lefttime/60, slip_leftsignals.values(:,1), 'b', 'LineWidth', 1.5);
plot(traction_correction_l.time/60, traction_correction_l.signals.values(:,1),'r','LineWidth', 1.5);
legend('Left wheel slip ratio', 'Traction control intervention Left');
xlim([0 2])
ylim([-0.2 0.2])
ylabel('Force [N]');
xlabel('Time [min]');
grid on;
surf(peaks)
if save==1
    saveas(gcf,strcat(figuresdir,'left_slip'),'epsc')
else
end


hfig = figure(5);
hax_new=copyobj(hax,figure(6))
set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
%print(hfig);
saveas(gcf, strcat(figuresdir,'test_left'),'epsc')
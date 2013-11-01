% clc
% clear all
% load gdl simulation configuration
% load motor data
GDLoutput = csvread('Sim-configuration.csv');
Motor_data = csvread('Motor Database.csv');
% geometry and other parameters
Crank_xyz = [-GDLoutput(1) GDLoutput(2) 0];
Rocker_xyz = [-GDLoutput(3) GDLoutput(4) 0];
Motor_gear_r = GDLoutput(5);
Main_gear_r = GDLoutput(6);
Dis_main_crank = GDLoutput(7);
Drive_length = GDLoutput(8);
Load_torque = GDLoutput(9);
Motor_number = GDLoutput(10);
switch GDLoutput(11)
    case 1 
        Head_direction = [1 0 0];
    case 2 
        Head_direction = [0 1 0];
    otherwise
        Head_direction = [1 0 0];  
end
Swing_angle = GDLoutput(12)/2;
Sim_time = GDLoutput(13);

Motor_speed = Motor_data(Motor_number,4); % rpm
Stall_torque = Motor_data(Motor_number,5);

Head_xyz = [0 0 Drive_length+Dis_main_crank];
Body_mass = 1;
Body_inertia = eye(3);
% start simulation
open E_Toothbrush_01
sim E_Toothbrush_01
close_system('E_Toothbrush_01')
head_angle = (max(simout_head_angle) - min(simout_head_angle))/2;
swing_frequency = max(simout_swing_frequency);
motor_speed = simout_motor_speed(end);
% other parameters
motor_price = Motor_data(Motor_number,13); % price
motor_current = (Motor_data(Motor_number,1)/Motor_data(Motor_number,7) + Motor_data(Motor_number,8))*1000; % current
motor_weight = Motor_data(Motor_number,10); % weight
csvwrite(fullfile(pwd,'Projects','Toothbrush','matlab','model','GDL data','matlab-simulation-results.csv'),[head_angle; swing_frequency; motor_speed; motor_price; motor_current; motor_weight]);
% clc
% clear all
% Motor_speed = 10000; % rpm
% Motor_gear_r = 1.5;
% Main_gear_r = 3;
% Crank_xyz = [3.2752 0.8660 0];
% Dis_main_crank = 5;
% 
% Rocker_xyz = [0.2752 2.9873 0];
% 
% Drive_length = 20;
% 
% Head_xyz = [0 0 Drive_length+Dis_main_crank];
% Head_direction = [1 0 0];
% Sim_time = 10;
% Stall_torque = 2.5;
% Load_torque = 2;
% 
% Body_mass = 1;
% Body_inertia = eye(3);
% Swing_angle = 30;
% sim E_Toothbrush_01
% head_angle = (max(simout_head_angle) - min(simout_head_angle))/2
% clc
% clear
% Select a motor by AHP
Motor_constraint = csvread('AHP-motor-constraint.csv');
Motor_requirement =  csvread('AHP-motor-requirement.csv');
Motor_data = csvread('Motor Database.csv');
%Motor_data = Motor_data(:,[1,2,3,4,5,7,8,10,13]);
Motor_data_dia = Motor_data(Motor_data(:,2) <=  Motor_constraint(1)*2,:);
Current_under_load = (Motor_constraint(2)./Motor_data_dia(:,7)+Motor_data_dia(:,8)).*1000;
Motor_AHP_matrix = [Motor_data_dia(:,13) Current_under_load Motor_data_dia(:,10)];

Criteria_Matrix = AHP_Matrix_Generation(Motor_requirement) %(Motor_requirement);

B1 = AHP_Matrix_Generation(AHP_Object_Small_Better(Motor_AHP_matrix(:,1)'));
B2 = AHP_Matrix_Generation(AHP_Object_Small_Better(Motor_AHP_matrix(:,2)'));
B3 = AHP_Matrix_Generation(AHP_Object_Small_Better(Motor_AHP_matrix(:,3)'));
Object_Matrix =  {B1 B2 B3};
[weights,CRs,index] = AHP(Criteria_Matrix,Object_Matrix);
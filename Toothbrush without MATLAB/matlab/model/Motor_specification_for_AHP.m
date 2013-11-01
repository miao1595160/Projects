clc
clear all

load Motor_specification

Criteria_Matrix = AHP_Matrix_Generation([1 3 3;
                                         0 1 5;
                                         0 0 1])
B1 = AHP_Matrix_Generation(AHP_Object_Score_Positive(Motor_specification(:,1)'));
B2 = AHP_Matrix_Generation(AHP_Object_Score_Positive(Motor_specification(:,2)'));
B3 = AHP_Matrix_Generation(AHP_Object_Score_Positive(Motor_specification(:,3)'));
Object_Matrix =  {B1 B2 B3};
[weights,CRs,index] = AHP(Criteria_Matrix,Object_Matrix);
% [Motor_row,Motor_col] = size(Motor_specification);

% for i = 1:Motor_col
%     Motor_mean(:,i) = mean(Motor_specification(:,i));
%     Motor_diff(:,i) = (Motor_specification(:,i) - Motor_mean(:,i)) ./ Motor_mean(:,i);
% end
% 
% 
% for i = 1:Motor_row
%     for j = 1:Motor_col
%         if Motor_diff(i,j) >= 0
%             if (Motor_diff(i,j)>= 0)&&(Motor_diff(i,j) < 0.1)
%                 Motor_scale(i,j) = 1;
%             elseif (Motor_diff(i,j)>= 0.1)&&(Motor_diff(i,j) < 0.2)
%                 Motor_scale(i,j) = 1; 
%             elseif (Motor_diff(i,j)>= 0.2)&&(Motor_diff(i,j) < 0.3)
%                 Motor_scale(i,j) = 2;
%             elseif (Motor_diff(i,j)>= 0.3)&&(Motor_diff(i,j) < 0.4)
%                 Motor_scale(i,j) = 3; 
%             elseif (Motor_diff(i,j)>= 0.4)&&(Motor_diff(i,j) < 0.5)
%                 Motor_scale(i,j) = 4;
%             elseif (Motor_diff(i,j)>= 0.5)&&(Motor_diff(i,j) < 0.6)
%                 Motor_scale(i,j) = 5;
%             elseif (Motor_diff(i,j)>= 0.6)&&(Motor_diff(i,j) < 0.7)
%                 Motor_scale(i,j) = 6;
%             elseif (Motor_diff(i,j)>= 0.7)&&(Motor_diff(i,j) < 0.8)
%                 Motor_scale(i,j) = 7;
%             elseif (Motor_diff(i,j)>= 0.8)&&(Motor_diff(i,j) < 0.9)
%                 Motor_scale(i,j) = 8;
%             else
%                 Motor_scale(i,j) = 9;
%             end
%         else
%             if (Motor_diff(i,j)<= 0)&&(Motor_diff(i,j) > -0.1)
%                 Motor_scale(i,j) = 1;
%             elseif (Motor_diff(i,j)<= -0.1)&&(Motor_diff(i,j) > -0.2)
%                 Motor_scale(i,j) = 1; 
%             elseif (Motor_diff(i,j)<= -0.2)&&(Motor_diff(i,j) > -0.3)
%                 Motor_scale(i,j) = 1/2;
%             elseif (Motor_diff(i,j)<= -0.3)&&(Motor_diff(i,j) > -0.4)
%                 Motor_scale(i,j) = 1/3; 
%             elseif (Motor_diff(i,j)<= -0.4)&&(Motor_diff(i,j) > -0.5)
%                 Motor_scale(i,j) = 1/4;
%             elseif (Motor_diff(i,j)<= -0.5)&&(Motor_diff(i,j) > -0.6)
%                 Motor_scale(i,j) = 1/5;
%             elseif (Motor_diff(i,j)<= -0.6)&&(Motor_diff(i,j) > -0.7)
%                 Motor_scale(i,j) = 1/6;
%             elseif (Motor_diff(i,j)<= -0.7)&&(Motor_diff(i,j) > -0.8)
%                 Motor_scale(i,j) = 1/7;
%             elseif (Motor_diff(i,j)<= -0.8)&&(Motor_diff(i,j) > -0.9)
%                 Motor_scale(i,j) = 1/8;
%             else
%                 Motor_scale(i,j) = 1/9;
%             end
%         end
%     end
% end



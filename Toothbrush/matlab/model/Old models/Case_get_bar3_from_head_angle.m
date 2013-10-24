sim E_Toothbrush_01
head_angle = (max(simout_head_angle) - min(simout_head_angle))/2;
GDLoutput_case_get_bar3 = csvread('get-bar3-from-head-angle.csv');
Target_head_angle = GDLoutput_case_get_bar3(1);
Bar3_step = GDLoutput_case_get_bar3(2);
Bar3_x = Bar3_end_xyz(1);
Bar3_y = Bar3_end_xyz(2);
if head_angle > Target_head_angle
    while  head_angle > Target_head_angle
        Bar3_x = Bar3_x + Bar3_step;
        Bar3_y = Bar3_y + Bar3_step;
        Bar3_end_xyz = [Bar3_x Bar3_y 0];
        sim E_Toothbrush_01
        head_angle = (max(simout_head_angle) - min(simout_head_angle))/2;
    end
elseif head_angle < Target_head_angle
    while  head_angle < Target_head_angle
        Bar3_x = Bar3_x - Bar3_step;
        Bar3_y = Bar3_y - Bar3_step;
        Bar3_end_xyz = [Bar3_x Bar3_y 0];
        sim E_Toothbrush_01
        head_angle = (max(simout_head_angle) - min(simout_head_angle))/2;
    end
end

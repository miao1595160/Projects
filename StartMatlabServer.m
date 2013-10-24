% put this file under the *default-pathname-defaults* 

clc
clear

end_in = 5;
j = end_in;
for i = 1:end_in
pause(1)
fprintf('The MATLAB server will be started in %d second', j)
j = j - 1;
fprintf('\n');
end

run MatlabServer

% disp('Load model parameters')
% run E_Toothbrush_P_01
% disp('Open dynamic model')
% open E_Toothbrush_01
% disp('Start simulation')
% sim E_Toothbrush_01
% disp('Close model')
% close_system('E_Toothbrush_01')

exit
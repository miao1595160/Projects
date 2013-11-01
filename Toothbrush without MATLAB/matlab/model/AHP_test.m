clc
clear all


% Criteria_Matrix = [ 1 2 7 5 5;
%       1/2 1 4 3 3;
%       1/7 1/4 1 1/2 1/3;
%       1/5 1/3 2 1 1;
%       1/5 1/3 3 1 1];
% B1 = [1 1/3 1/8;
%       3 1 1/3
%       8 3 1];
% B2 = [1   2   5;
%       1/2 1   2
%       1/5 1/2 1];
% B3 = [1   1   3;
%       1   1   3
%       1/3 1/3 1];
% B4 = [1   3 4;
%       1/3 1 1;
%       1/4 1 1];
% B5 = [1   4 1/4;
%       1/4 1 1/4;
%       4   4 1];
Criteria_Matrix = AHP_Matrix_Generation([1 4 3 7;
                                         0 1 1/3 3;
                                         0 0 1 5;
                                         0 0 0 0])
%                    [1   4   3   7;
%                     1/4 1   1/3 3;
%                     1/3 3   1   5;
%                     1/7 1/3 1/5 1];
B1 = [1 1/4 4;
      4 1 9
      1/4 1/9 1];
B2 = [1 3 1/5;
      1/3 1 1/7
      5 7 1];
B3 = [1 5 9;
      1/5 1 4
      1/9 1/4 1];
B4 = [1 1/3 5;
      3 1 9
      1/5 1/9 1];
Object_Matrix =  {B1 B2 B3 B4};
[weights,CRs,index] = AHP(Criteria_Matrix,Object_Matrix);
% % Get criteria weights 
% Criteria_weights = AHP_MaxEigenVector(Criteria_Matrix);
% % Consistency check
% Criteria_CR = AHP_Consistency(Criteria_Matrix);
% % Get object weights
% for i = 1:length(Criteria_Matrix)
%     Object_weights(i,:) = AHP_MaxEigenVector(Object_Matrix{1,i});
% end
% % Get final judgement weights for each object
% for i = 1:length(Object_Matrix{1,1})
% Judgement_weights (i) = Criteria_weights' * Object_weights(:,i);
% 
% end
% % Get max object index
% Judgement_max = max(Judgement_weights);
% [Judgement_max Judgement_index] = max(Judgement_weights);
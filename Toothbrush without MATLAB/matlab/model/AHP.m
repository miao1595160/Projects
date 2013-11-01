function [Judgement_weights,Judgement_CRs,Judgement_index] = AHP(Criteria_Matrix,Object_Matrix)
% Get criteria weights 
Criteria_weights = AHP_MaxEigenVector(Criteria_Matrix);
% Consistency check
Criteria_CR = AHP_Consistency(Criteria_Matrix);
Judgement_CRs(1) = Criteria_CR;
% Get object weights and CRs
for i = 1:length(Criteria_Matrix)
    Object_weights(i,:) = AHP_MaxEigenVector(Object_Matrix{1,i});
    Judgement_CRs(i+1) = AHP_Consistency(Object_Matrix{1,i});
end
% Get final judgement weights for each object
for i = 1:length(Object_Matrix{1,1})
Judgement_weights (i) = Criteria_weights' * Object_weights(:,i);

end
% Get max object index
Judgement_max = max(Judgement_weights);
[Judgement_max Judgement_index] = max(Judgement_weights);
end

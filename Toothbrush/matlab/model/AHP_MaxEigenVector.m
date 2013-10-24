function MaxEigenVector = AHP_MaxEigenVector(Matrix)
% get eigen values and vectors
[EigenVectors, EigenValues] = eig(Matrix);
% get eigen diag matrix
DiagonalVal = diag(EigenValues);
% get max eigen value and corresponing index
[EigenValues,Index] = max(DiagonalVal);
% get the corresponding vector of max eigen value
MaxEigenVector = EigenVectors(:,Index);
% make the sum of eigen vector to 1
MaxEigenVector = MaxEigenVector./sum(MaxEigenVector);
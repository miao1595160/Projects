function [AHP_matrix] = AHP_Matrix_Generation(scale)
% prepare matrix for AHP
matrix_size = length(scale);
AHP_matrix = ones(matrix_size,matrix_size);

for i = 1:matrix_size
    for j = 1:matrix_size
        if i == j
        elseif j > i
            AHP_matrix(i,j) = scale(i,j); 
        elseif j < i
            AHP_matrix(i,j) =  1 / AHP_matrix(j,i);
        end
    end
end

end
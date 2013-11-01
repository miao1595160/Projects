clc
clear all
A = round(rand(5,3)*100)
X = [1 2 3];
[row,col] = size(A);
B = round(rand(length(X),col));
for i = 1:length(X)
    A = sortrows(A,X(i));
    B(i,:) = A(1,:)
    A(1,:) = [];
end
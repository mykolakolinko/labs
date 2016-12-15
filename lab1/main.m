function [] = main()
% main - main function, duh
%
% Syntax: [] = main()
% It's kinda void.

% We're solving the following problem
% Having some special tridiagonal matrix A and a vector b
% one wishes to find a solution to equation Ax = b.
% Considering the fact that b is derived from given x
% it would be a lot easier to just return x, duh

	[matrix, solution, rightSide, eigenvaluePrecision, solutionPrecision] = Init('params.mat');

	minimalEigenvalue = Eigenvalue(matrix, eigenvaluePrecision, 'default', 'min');
	maximalEigenvalue = Eigenvalue(matrix, eigenvaluePrecision, 'default', 'max');

	sprintf('Minimal eigenvalue is %f and maximal is %f', minimalEigenvalue, maximalEigenvalue)

	[predictedSolution, numberOfIterations] = Solve(matrix, rightSide, solutionPrecision, 'default', minimalEigenvalue, maximalEigenvalue);
	sprintf('Found solution in %d iterations.', numberOfIterations)
	predictedSolution
end;

function [matrix, solution, rightSide, eigenvaluePrecision, solutionPrecision] = Init(fileName)
% Syntax: [matrix, solution, rightSide, eigenvaluePrecision, solutionPrecision] = Init(fileName)

	% Loading parameters.
	% File params.mat should contain a lot of stuff
	% Namely, diagonal of A, vector of offsets and x (lol)
	load(fileName);
	rows = size(A);
	matrix = diag(A + offsets) - diag(ones(rows - 1, 1), 1) - diag(ones(rows - 1, 1), -1); 
	rightSide = matrix * x;
	solution = x;
end;
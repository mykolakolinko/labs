function [solution, numberOfIterations] = Solve(matrix, rightSide, precision, approximation = 'default',...
												minimalEigenvalue, maximalEigenvalue)
% Syntax: [solution, numberOfIterations] = Solve(matrix, rightSide, precision, firstApprox = 'default',...
%												minimalEigenvalue, maximalEigenvalue)
% Finds a solution to an equation matrix * solution = rightSide.
	[rows, cols] = size(matrix);
	if rows ~= cols
		error('matrix expected to be square, got %dx%d', rows, cols);
	end;
	if (approximation == 'default')
		approximation = rand(rows, 1);
	end;

	% Just an implementation of given algorithm
	iterationParameter = 2 / (minimalEigenvalue + maximalEigenvalue);
	numberOfIterations = floor(0.5 * sqrt(maximalEigenvalue / minimalEigenvalue) * log(2 / precision));
	for i = 1 : numberOfIterations
		approximation = (rightSide - matrix * approximation) * iterationParameter + approximation;
	end; 
	solution = approximation;
end;
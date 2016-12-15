function [eigenvalue, eigenvector] = Eigenvalue(matrix, precision, approximation = 'default', method = 0)
% this is a stub
	[rows, cols] = size(matrix);
	if rows ~= cols
		error('matrix expected to be square, got %dx%d', rows, cols);
	end;
	if (approximation == 'default')
		approximation = rand(rows, 1);
	end;

	if (method == 0 || method == 'max') 		% the following part is really counterintuitive
		difference = 0;
		while abs(difference - 1) > precision
			eigenvector = matrix * approximation;
			[eigenvalue, index] = max(abs(eigenvector ./ approximation));
			eigenvalue = eigenvector(index) / approximation(index);
			difference = norm(eigenvector);
			approximation = eigenvector / (difference * eigenvalue);
		end;
	elseif (method == 1 || method == 'min') 	% same as before, but matrix is virtually inverted
		[lowerTriangular, upperTriangular] = lu(matrix);
		difference = 0;
		while abs(difference - 1) > precision
			eigenvector = solve(lowerTriangular, 'lower', solve(upperTriangular, 'upper', approximation));
			[eigenvalue, index] = max(abs(eigenvector ./ approximation));
			eigenvalue = eigenvector(index) / approximation(index);
			difference = norm(eigenvector);
			approximation = eigenvector / (difference * eigenvalue);
		end;
		eigenvalue = 1 / eigenvalue;
	else
		error('unexpected method. expected 0 or max, 1 or min, got %s', method);
	end;	
end;

function solution = solve(matrix, method, rightSide)
% Syntax: solution = solve(matrix, method, rightSide)
%
% Solves an equation matrix * solution = rightSide.
% matrix should be either upper or lower triangular, what is reflected in method.
% This property of matrix is NOT checked. 
	[rows, cols] = size(matrix);
	if rows < cols
		rightSide = matrix(:, rows + 1 : end);
		matrix = matrix(:, 1:rows);
		cols = cols - rows;						% reusing cols for number of columns in rightSide
	elseif rows > cols
		error('invalid parameters. matrix expected to be either square or has more'+ ...
				'columns than rows, got %dx%d', rows, cols);
	else
		cols = 1;								% reusing cols for number of columns in rightSide
	end;
	if (method == 0 || method == 'upper')
		solution = zeros(rows, cols);
		for (i = rows : -1 : 1)
			solution(i, :) = rightSide(i, :) ./ matrix(i, i);
			rightSide -= matrix(:, i) * solution(i, :);
		end;
	elseif (method == 0 || method == 'lower')
		solution = rot90(solve(rot90(matrix, 2), 'upper', rot90(rightSide, 2)), 2);
	else
		error('invalid parameters. method expected to be 0 or upper, 1 or lower, got %s', method);
	end; 
end;
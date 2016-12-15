function solution = Solve(matrix)
% Solves linear system

	[rows, cols] = size(matrix);
	if (isTridiagonal(matrix))
		matrix = [[0; diag(matrix, -1)], diag(matrix), [diag(matrix, 1)], matrix(:, rows + 1 : end)];
		coefficients = zeros(rows - 1, 2);
		columns = zeros(1, rows - 1);
		currentColumn = 1;
		dependencies = zeros(1, rows - 1);
		for i = 1 : rows - 1
			if abs(matrix(i, 2)) >= abs(matrix(i, 3))
				coefficients(i, :) = [-matrix(i, 3), matrix(i, 4)] / matrix(i, 2);
				matrix(i + 1, [2, 4]) += [coefficients(i, 1), -coefficients(i, 2)] * matrix(i + 1, 1);
				dependencies(currentColumn) = i + 1;
				columns(i) = currentColumn;
				currentColumn = i + 1;
			else
				coefficients(i, :) = [-matrix(i, 2), matrix(i, 4)] / matrix(i, 3);
				matrix(i + 1, [2, 4]) = matrix(i + 1, [1, 4]) + [coefficients(i, 1), -coefficients(i, 2)] * matrix(i + 1, 2);
				if i < rows - 1
					matrix(i + 2, [1, 4]) = [0, matrix(i + 2, 4)] + [coefficients(i, 1), -coefficients(i, 2)] * matrix(i + 2, 1);
				end;
				dependencies(i + 1) = currentColumn;
				columns(i) = i + 1;
			end;
		end;
		solution = zeros(rows, 1);
		solution(currentColumn) = matrix(rows, 4) / matrix(rows, 2);
		for i = rows - 1 : -1 : 1
			solution(columns(i)) = coefficients(i, 1) * solution(dependencies(columns(i))) + coefficients(i, 2);
		end;
	else
		warning('Input matrix was not tridiagonal');
		rightSide = matrix(:, rows + 1 : end);
		matrix = matrix(:, 1:rows);
		solution = matrix \ rightSide;
	end;
end;

function result = isTridiagonal(matrix)
	[rows, cols] = size(matrix);
	core = matrix(:, 1 : rows);
	mask = 1 - (diag(ones(1, rows)) + diag(ones(1, rows - 1), 1) + diag(ones(1, rows - 1), -1));
	if core .* mask == 0
		result = true;
	else
		result = false;
	end;
end;
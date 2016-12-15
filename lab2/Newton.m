function [solution, iterationsElapsed] = Newton(func, interval, precision = 1e-5, approximation = 'default', linearPart = [], maxIterationSteps = 1000)
% Newton - solves non-linear equation F(x) = 0 using Newton's method
%
% Function may have explicit linear part

	[funcInputLength, cols] = size(interval);
	if cols ~= 2
		error('invalid interval format. expected nx2 matrix, got %dx%d', funcInputLength, cols);
	end;
	if strcmp(approximation, 'default')
		approximation = interval(:, 1) + rand(funcInputLength, 1) .* (interval(:, 2) - interval(:, 1));
	end;
	if length(linearPart) == 0
		differentiate = @(point)(Diff(func, point, 1e-5));
		fullValue = func;
	else
		differentiate = @(point)(Diff(func, point, 1e-5) + linearPart);
		fullValue = @(point)(func(point) + linearPart * point);
	end;
	if funcInputLength == 1
		for iterationsElapsed = 1 : maxIterationSteps
			if (differentiate(approximation) == 0)
				warning('Newton method found local minimum.');
				return
			end;
			change = fullValue(approximation) / differentiate(approximation);
			solution = approximation - change;
			if abs(change) < precision
				return
			end;
			approximation = solution;
		end;
	else
		for iterationsElapsed = 1 : maxIterationSteps
			change = Solve([differentiate(approximation), fullValue(approximation)]);
			solution = approximation - change;
			if (norm(fullValue(solution)) > norm(fullValue(approximation)))
				[eigenVectors, eigenValues] = eig(differentiate(approximation));
				[minimal, minimalIndex] = min(abs(diag(eigenValues)));
				minimalEigenVector = eigenVectors(:, minimalIndex);
				solution += sum(change .* minimalEigenVector) * minimalEigenVector;
				change -= sum(change .* minimalEigenVector) * minimalEigenVector;
				solution += Newton(@(t)(Diff(@(u)(norm(fullValue(solution + u * minimalEigenVector))), t, 1e-5)), [-1, 1]) * minimalEigenVector;
				if max(abs(change)) < precision
					warning('Newton method may have found local minimum.');
					return
				end;
			elseif max(abs(change)) < precision
				return
			end;

			approximation = solution;
		end;
	end;
end;
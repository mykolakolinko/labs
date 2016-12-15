function [] = main()
% main - main function.
%
% Solves a system of non-linear equations

	% Multiple experiments have shown that 1e-5 is a very good offset for this operation
	differentiate = @(func, point)(Diff(func, point, 1e-5));

	% First and last equations in the systems are different, so they have their own functions
	% There's a linear (as a function of y) part that has coefficient that depends on point
	[firstEquationFunction, lastEquationFunction, func, coefficient, pointsCount, interval, precision, maxIterations]...
	 = Init('params.mat');
	subintervalLength = (interval(2) - interval(1)) / (pointsCount - 1);
	points = interval(1) : subintervalLength : interval(2);
	solution = zeros(pointsCount, 1);
	
	% Solving first and last equation separately, as they are different
	solution(1) = Newton(firstEquationFunction, interval);
	solution(pointsCount) = Newton(lastEquationFunction, interval);

	% Making starting approximation for other points
	solution(2 : end - 1) = solution(1) + (solution(pointsCount) - solution(1)) .* (subintervalLength:subintervalLength:1 - subintervalLength)';
	linearPart = -diag(coefficient(points')(2 : end - 1) + 2 / subintervalLength ^ 2) +...
	 (diag(ones(1, pointsCount - 3), 1) + diag(ones(1, pointsCount - 3), -1)) / subintervalLength ^ 2;
	constants = zeros(pointsCount - 2, 1);
	constants(1) = solution(1) / subintervalLength ^ 2;
	constants(pointsCount - 2) = solution(pointsCount) / subintervalLength ^ 2;
	mainFunc = @(point)(func(points(2 : end - 1)', point) + constants);
	[solution(2 : end - 1), iterationsElapsed] = Newton(mainFunc, zeros(pointsCount - 2, 2), 1e-5, solution(2 : end - 1), linearPart, maxIterations);
	clf;
	disp(sprintf('Solution found in %d steps', iterationsElapsed))
	showMe(solution, 1/pointsCount);
end;

function [firstEquationFunction, lastEquationFunction, func, coefficient, pointNumber, interval, precision, maxIterations] = Init(fileName)
% Initialises parameters

	load(fileName);
	disp(sprintf('Initiating with parameters: group number = %d, student number = %d, birth date = %d', groupNumber, studentNumber, gamma2))
	firstEquationFunction = @(t)(phi(t, groupNumber, studentNumber) - gamma1);
	lastEquationFunction = @(t)(xi(t, studentNumber) - gamma2);
	func = f;
	coefficient = @(t)(p(t, groupNumber, intervalStart, groupNumber));
	interval = [intervalStart, groupNumber];
	pointNumber = n;
end;

function [] = showMe(func, scale = 1)
	if ~strcmp(class(func),'function_handle')
		y = func;
		x = ((1 : length(func)) - 1) * scale;
	else
		x = 0:scale:1;
		y = arrayfun(func, x);
	end;
	plot(x, y);
	grid on;
	axis square;
	print -deps result.eps;
end;
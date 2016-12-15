function [points, coefficients] = GetInterpolationCoefficients(interval, degree, weightFunction, integrationPrecision = 1e-5)
	moments = zeros(1, 2*degree);
	for i = 0:2*degree - 1;
		moments(i + 1) = SimpsonsMethod(interval, @(t)(weightFunction(t) * (t^i)), integrationPrecision);
	end;

	matrix = [ones(degree, 1) * (degree:-1:1) + (0:degree-1)' * ones(1, degree), (1:degree)' + degree];
	matrix = moments(matrix);
	matrix(:, end) *= -1;

	ortPolynomial = matrix(:, 1:end - 1) \ matrix(:, end);
	ortPolynomial = [1, ortPolynomial'];
	points = sort(roots(ortPolynomial));

	polynomial = @(t, coef)(prod(t - coef));
	coefficients = zeros(degree, 1);
	for i = 1:degree
		denominator = polynomial(points(i), points(1:end ~= i));
		coefficients(i) = SimpsonsMethod(interval, @(t)(polynomial(t, points(1:end ~= i)) / denominator * weightFunction(t)), integrationPrecision);
	end;
end;
function result = Interpolate(func, weight, points, coefficients, interpolationInterval, approximationInterval)
	coef = [(interpolationInterval(2) - interpolationInterval(1)) \ (approximationInterval(2) - approximationInterval(1)), approximationInterval(1) - interpolationInterval(1)];
	coefficients = coef(1) * coefficients ./ arrayfun(weight, points);
	points = coef(1) * points + coef(2);
	coefficients = coefficients .* arrayfun(weight, points);

	result = sum(coefficients .* arrayfun(func, points));
end;
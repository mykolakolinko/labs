function [] = main()
	[func, weight, interpolationInterval, approximationInterval, degree] = Init('params.mat');

	[points, coefficients] = GetInterpolationCoefficients(interpolationInterval, degree, weight)
	
	interpolatedIntegral = Interpolate(func, weight, points, coefficients, interpolationInterval, approximationInterval)
	approximatedIntegral = SimpsonsMethod(approximationInterval, @(t)(func(t) * weight(t)), 1e-10)
	printf('difference is %e\n', interpolatedIntegral - approximatedIntegral)
end;

function [func, weight, interpolationInterval, approximationInterval, degree] = Init(fileName)
	load(fileName);
	weight = @(t)(weight(t, g));
	func = @(t)(func(t, g, k));
	degree = min(g + 6, max(d, k));
	approximationInterval = [min(k, d), max(k, d)];
end;
function result = SimpsonsMethod(interval, func, precision, maxIterations = 20)
	divisionNumber = 2;
	divisionLength = (interval(2) - interval(1)) / 2;
	oddSumElements = divisionLength / 3 * (func(interval(1) + divisionLength));
	evenSumElements = 0;
	endpointsValue = divisionLength / 3 * (func(interval(1)) + func(interval(2)));
	result = endpointsValue + 4 * oddSumElements; %+ 2 * evenSumElements, but it's 0
	for i = 1:maxIterations
		approximation = result;
		evenSumElements = (evenSumElements + oddSumElements) / 2;
		endpointsValue /= 2;
		oddSumElements = divisionLength / 6 * sum(arrayfun(func, interval(1) + divisionLength / 2 + (0:divisionNumber - 1) * divisionLength ));
		divisionLength /= 2;
		divisionNumber *= 2;
		result = endpointsValue + 4 * oddSumElements + 2 * evenSumElements;
		if abs(result - approximation) < precision
			return;
		end;
	end; 
end;
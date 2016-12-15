function [coefficients, approximationDegree] = GetCollatzCoefficients(operatorCoefficients, intervalDivision, pointNumber)
	operatorDegree = length(operatorCoefficients);
	divisionNumber = length(intervalDivision) - 1;
	intervalLength = (intervalDivision(end) - intervalDivision(1)) / divisionNumber;
	approximationDegree = divisionNumber + 1 - operatorDegree;
	matrix = (ones(divisionNumber + 1, 1) * ((0:divisionNumber) - pointNumber)) .^ ((ones(divisionNumber + 1, 1) * (0:divisionNumber))');
	rightSide = zeros(divisionNumber + 1, 1);
	rightSide(1) = 1;
	for i = 1:operatorDegree
		rightSide(i + 1) = rightSide(i) * i / intervalLength;
	end;
	rightSide = rightSide .* ([operatorCoefficients, zeros(1, approximationDegree)]');
	coefficients = matrix \ rightSide;
end;
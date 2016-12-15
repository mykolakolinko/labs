function [] = main()
	[operatorCoefficients, divisionNumber, pointNumber, interval] = Init('params.mat');
	intervalDivision = interval(1) + (0:divisionNumber) * (interval(2) - interval(1)) / divisionNumber;
	[coefficients, approximationDegree] = GetCollatzCoefficients(operatorCoefficients, intervalDivision, pointNumber)
end;

function [operatorCoefficients, divisionNumber, pointNumber, interval] = Init(fileName)
	load(fileName);
end;
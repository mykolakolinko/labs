function res = Diff(func, point, sideOffset)
% Differentiate vector function func

	if isrow(point)
		point = point';
	end;
	rows = length(point);
	res = zeros(length(func(point)), rows);
	for i = 1 : rows
		up = down = point;
		up(i) += sideOffset;
		down(i) -= sideOffset;
		res(:, i) = (func(up) - func(down)) / (2 * sideOffset);
	end;
end;
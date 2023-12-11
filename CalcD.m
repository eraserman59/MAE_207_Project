function [D] = CalcD(oeChief, const)
%CALCD Calcs constant D from cheif orbit OE and constants

a = oeChief(1);
e = oeChief(2);
i = deg2rad(oeChief(3));
L = sqrt(a/const.R);
eta = sqrt(1-e^2);
temp1 = const.J2 / (4 * L^4 * eta^5);
temp2 = (4+3*eta);
temp3 = 1 + 5 * cos(i)^2;

D = temp1 * temp2 * temp3;

end
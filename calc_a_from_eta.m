function [delta_a] = calc_a_from_eta(oeChief,const, delta_eta)
%CALC_A_F_ETA Summary of this function goes here
%   Detailed explanation goes here
D = CalcD(oeChief, const);
a = oeChief(1);
delta_a = 2 * D * a * delta_eta;

end
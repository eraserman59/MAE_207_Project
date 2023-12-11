function [delta_eta] = calc_eta_from_a(oeChief,const, delta_a)
%CALC_ETA_F_A Summary of this function goes here
%   Detailed explanation goes here
D = CalcD(oeChief, const);
a = oeChief(1);
delta_eta = delta_a / (2 * D * a);
end
function [delta_eta] = calc_eta_from_i(oeChief, delta_i)
%CALC_ETA_FROM_I Summary of this function goes here
%   Detailed explanation goes here
e = oeChief(2);
i = deg2rad(oeChief(3));
eta = sqrt(1-e^2);
delta_eta = - eta/4 * tan(i) * deg2rad(delta_i);


end
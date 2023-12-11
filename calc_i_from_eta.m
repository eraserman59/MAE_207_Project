function [delta_i] = calc_i_from_eta(oeChief, delta_eta)
%CALC_I_F_ETA Summary of this function goes here
%   Detailed explanation goes here
e = oeChief(2);
eta = sqrt(1-e^2);
i = deg2rad(oeChief(3));
temp1 = - eta/4 * tan(i);

temp2 = delta_eta / temp1;
delta_i = rad2deg(temp2);


end
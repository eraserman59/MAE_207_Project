function [delta_eta] = calc_eta_from_e(oeChief,delta_e)
%CALC_ETA_FROM_E Summary of this function goes here
%   Detailed explanation goes here
e = oeChief(2);
eta = sqrt(1-e^2);
delta_eta = delta_e * (- e/eta);
end
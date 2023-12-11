function [delta_e] = calc_e_from_eta(oeChief, delta_eta)
%CALC_E_FROM_ETA Summary of this function goes here
%   Detailed explanation goes here
e = oeChief(2);
eta = sqrt(1-e^2);
if (e ~=0)
  delta_e = - eta/e * delta_eta;
else
  eta_d = delta_eta + 1;
  delta_e = sqrt(1-eta_d^2);
end


end
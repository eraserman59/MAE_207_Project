function [delta_struct] = calc_change_from_input(oeChief , const, initialDelta, type)
%CALC_CONSTRAINTS_FROM_INPUTS calcs a delta struct [da, de, di]
%   type is string input of a, e, or i. Depending on what initial delta is

if (oeChief(2) > 1)
    error('not an ellipical or circular orbit, invalid')
end


if (oeChief(3) == 90)
    error('polar orbit, calc will error with undefined')
end


if(strcmp(type, 'a'))
    delta_a = initialDelta;
    delta_eta = calc_eta_from_a(oeChief, const, delta_a);
    delta_i = calc_i_from_eta(oeChief, delta_eta);
    delta_e = calc_e_from_eta(oeChief, delta_eta);
end
if(strcmp(type, 'i'))
    delta_i = initialDelta;
    delta_eta = calc_eta_from_i(oeChief, delta_i);
    delta_a = calc_a_from_eta(oeChief, const, delta_eta);
    delta_e = calc_e_from_eta(oeChief, delta_eta);
end

if(strcmp(type, 'e'))
    delta_e = initialDelta;
    delta_eta = calc_eta_from_e(oeChief, delta_e);
    delta_i = calc_i_from_eta(oeChief, delta_eta);
    delta_a = calc_a_from_eta(oeChief, const, delta_eta);
end


delta_struct = [delta_a, delta_i, delta_e];

end
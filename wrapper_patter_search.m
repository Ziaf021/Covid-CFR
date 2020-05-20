function wrapper_pattern_search (country_name)

days_vec = [9];
%country_name = country_name
for day_id = 1: length(days_vec)
    cfr_pattern_search(country_name, days_vec(day_id))
end
end
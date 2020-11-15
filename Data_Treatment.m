function [metM_hour_Data,ref_hour_Data,WS_full_60]= Data_Treatment(metM_hour_Data,ref_hour_Data,ref_data)

%% Ref 2012 site data 60m extrap. with shear
% Fill out following variables
shear_exp = 0.2; % Shear exponent of the site (changes from site to site)
h_metmast = 60; % Height of met-mast measurements
h_ref     = 10; % Height of reference measurements


% Fill out rest of the equation below for Power Law
ref_hour_Data.wind_speed_60 = ref_hour_Data.wind_speed_10.*(h_metmast/h_ref )^shear_exp;

%% Filter out the 0s
% Going back to a), one can see that there are 0 m/s wind speed data which
% is not realistic.
% This usually means that there were not recordings during this period.
% We need to filter out these measurements and time stamps.
bool_filter = (metM_hour_Data.wind_speed_60 == 0) | (ref_hour_Data.wind_speed_60 == 0); % Boolean to find 0's in both data set

metM_hour_Data.wind_speed_60_t = metM_hour_Data.wind_speed_60(~bool_filter); % filter wind speed
metM_hour_Data.wind_dir_58_t = metM_hour_Data.wind_dir_58(~bool_filter); % filter wind dir.
metM_hour_Data.time_stamp_t = metM_hour_Data.time_stamp(~bool_filter); % filter time stamp

ref_hour_Data.wind_speed_60_t = ref_hour_Data.wind_speed_60(~bool_filter); % filter wind speed
ref_hour_Data.wind_dir_10_t = ref_hour_Data.wind_dir_10(~bool_filter); % filter wind dir.


%% Predict for the full range of ref site data
% Transform 33 years of wind speed data to 60m and m/s
WS_full_60 = ref_data(:,5).*0.514.*(h_metmast/h_ref)^shear_exp; % At 60m


end


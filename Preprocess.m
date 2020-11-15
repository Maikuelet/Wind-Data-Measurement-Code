%% DATA PREPROCESSING

function [metM_hour_Data,ref_hour_Data,ref_data] = Preprocess()

clc
clear all
close

%% Create 1 hour average data for met-mast 2012 data

pathh     = pwd;                             % Path Where Saved main.m
myfolder  = 'Data';                          % Folder where Saved
file_name = fullfile(pathh , myfolder,'01_MCP_mast_data.xlsx');      % Generate Adress
%file_name = '01_MCP_mast_data.xlsx';

[met_mast_data_2012,txt,raw] =xlsread(file_name);

num_data = numel(met_mast_data_2012(:,1));
hours_year = (num_data-5)/6;      % Substract 5 for correcting the data set

for i= 1:hours_year
     
   % Since 1 hour is made of six 10 minutes. There are 6 data points to add and average.
   % The first data point is row 6, the first column is the 60m wind speed.
   metM_hour_Data.wind_speed_60(i,1) =  mean((met_mast_data_2012(i*6:i*6+5,1)));
   metM_hour_Data.wind_dir_58(i,1)   =  mean((met_mast_data_2012(i*6:i*6+5,8)));
   metM_hour_Data.time_stamp(i,1) = datetime(string(txt(12+i*6,1)),'InputFormat','dd/MM/yyyy HH:mm:SS');
 
end

%% Acquire the ref site data for 2012

myfolder  = 'Data';                          % Folder where Saved
file_name = fullfile(pathh , myfolder,'01_MCP_reference_site_wind_speed_dir_1980_2013.xlsx');      % Generate Adress
[ref_data,ref_txt,ref_raw] =xlsread(file_name);

%% Find the dates corresponding to met mast measurement duration
[~,i_start,~] = intersect(ref_data(:,1:4), [2012 1 1 1],'rows'); % Finds first index of intersection of dates
[~,i_end,~] = intersect(ref_data(:,1:4), [2012 12 12 23],'rows'); % Finds last index of intersection of dates

%% Create 1 hour average data for ref 2012 data
% Fill the equation below to convert wind speed of ref. data
ref_hour_Data.wind_speed_10 = ref_data(i_start:i_end,5)*0.514; % Convert knots to m/s

ref_hour_Data.wind_dir_10 = ref_data(i_start:i_end,6);

clearvars -except ref_hour_Data metM_hour_Data ref_data





%% Data Storage
pathh     = pwd;
myfolder = 'Workspace';
f = fullfile(pathh , myfolder);

mkdir(f);       % Creates Folder
rmdir(f,'s');   % Deletes folder for new storage
mkdir(f);       % Creates Folder


f = fullfile(pathh , myfolder, 'metM_hour_Data');
save(f,'metM_hour_Data');
f = fullfile(pathh , myfolder, 'ref_hour_Data');
save(f,'ref_hour_Data');
f = fullfile(pathh , myfolder, 'ref_data');
save(f,'ref_data');


end
%% WEN II - Uebung 1: MCP
%  27.11.2019, Umut Özinan
clc
clear
close all

%% How to use this Matlab script
% Fill out sections with empty spaces to answer questions on the exercise
% sheet.
% Only run sections and not the whole script until you are done with all
% of the sections. To run only 1 section, click on the section and press
% 'Ctrl + Enter'.
% If you get an error, it means you need to fill out empty space in that
% section.

%% Acquire the met-mast data
% This is a yearly data with 10 minute average intervals. Please look in the xlsx document for further information.

file_name = '01_MCP_mast_data.xlsx'; % Put this file to the same folder as the code

[met_mast_data_2012,txt,raw] =xlsread(file_name) ; % This reads the excel and separates it into types of data

%% Create 1 hour average data for met-mast 2012 data
% The 10 minute average data is averaged into 1 hour data for easier comparison

num_data = numel(met_mast_data_2012(:,1));
hours_year = (num_data-5)/6; % First 5 data points are excluded, the time stamp of record is important.
                             % It could be at the beginning/middle/end of a measurement.

for i= 1:hours_year
     
   % Since 1 hour is made of six 10 minutes. There are 6 data points to add and average.
   % The first data point is row 6, the first column is the 60m wind speed.
   metM_hour_Data.wind_speed_60(i,1) =  mean((met_mast_data_2012(i*6:i*6+5,1)));
   metM_hour_Data.wind_dir_58(i,1)   =  mean((met_mast_data_2012(i*6:i*6+5,8)));
   metM_hour_Data.time_stamp(i,1) = datetime(string(txt(12+i*6,1)),'InputFormat','dd/MM/yyyy HH:mm:SS');
end

%% Plot averaged wind speed at 60m
figure('name','Averaged wind speed at 60m');
% Edit the following plot function to answer a)
plot(metM_hour_Data.time_stamp, metM_hour_Data.wind_speed_60 ,'x','color','b');
ylabel('Hourly WS [m/s]');
xtickformat('dd-MM-yyyy HH:mm:SS')
grid on

%% Acquire the ref site data for 2012
file_name = '01_MCP_reference_site_wind_speed_dir_1980_2013.xlsx' % Put this file to the same folder as the code
[ref_data,ref_txt,ref_raw] =xlsread(file_name) ;

%% Find the dates corresponding to met mast measurement duration
[~,i_start,~] = intersect(ref_data(:,1:4), [2012 1 1 1],'rows'); % Finds first index of intersection of dates
[~,i_end,~] = intersect(ref_data(:,1:4), [2012 12 12 23],'rows'); % Finds last index of intersection of dates

%% Create 1 hour average data for ref 2012 data
% Fill the equation below to convert wind speed of ref. data
ref_hour_Data.wind_speed_10 = ref_data(i_start:i_end,5)*0.514; % Convert knots to m/s

ref_hour_Data.wind_dir_10 = ref_data(i_start:i_end,6);

clearvars -except ref_hour_Data metM_hour_Data ref_data

%% Ref 2012 site data 60m extrap. with shear
% Fill out following variables
shear_exp = 0.2; % Shear exponent of the site (changes from site to site)
h_metmast = 60; % Height of met-mast measurements
h_ref     = 10; % Height of reference measurements

% Fill out rest of the equation below for Power Law
ref_hour_Data.wind_speed_60 = ref_hour_Data.wind_speed_10.*(h_metmast/h_ref )^shear_exp;
%

%% Correlate WS met-mast with ref. site data
figure('name','Averaged wind speed correlation at 60m');
% Edit the following plot function to answer c)
plot(ref_hour_Data.wind_speed_10,  metM_hour_Data.wind_speed_60,'d','MarkerEdgeColor','b','MarkerFaceColor','b');
ylabel('Met-mast WS [m/s]');
xlabel('Ref Site WS [m/s]');
grid on

%% Filter out the 0s
% Going back to a), one can see that there are 0 m/s wind speed data which
% is not realistic.
% This usually means that there were not recordings during this period.
% We need to filter out these measurements and time stamps.
bool_filter = (metM_hour_Data.wind_speed_60 == 0) | (ref_hour_Data.wind_speed_60 == 0); % Boolean to find 0's in both data set

metM_hour_Data.wind_speed_60 = metM_hour_Data.wind_speed_60(~bool_filter); % filter wind speed
metM_hour_Data.wind_dir_58 = metM_hour_Data.wind_dir_58(~bool_filter); % filter wind dir.
metM_hour_Data.time_stamp = metM_hour_Data.time_stamp(~bool_filter); % filter time stamp

ref_hour_Data.wind_speed_60 = ref_hour_Data.wind_speed_60(~bool_filter); % filter wind speed
ref_hour_Data.wind_dir_10 = ref_hour_Data.wind_dir_10(~bool_filter); % filter wind dir.

%% Correlate filtered met-mast with ref. site data
figure('name','Averaged wind speed correlation at 60m');
% Edit the following plot function to answer c) correctly
plot(ref_hour_Data.wind_speed_60,metM_hour_Data.wind_speed_60 ,'d','MarkerEdgeColor','b','MarkerFaceColor','b');
ylabel('Met-mast WS [m/s]');
xlabel('Ref Site WS [m/s]');
grid on
hold on

%% Linear best fit & Pearson coeff.
% Fill out the following two functions for a linear fit to answer d)
% Use 'help polyfit' in command window to understand the function
p = polyfit( ref_hour_Data.wind_speed_60,metM_hour_Data.wind_speed_60 , 1);
% Use 'help polyval' in command window to understand the function
fit1 = polyval(p, ref_hour_Data.wind_speed_60);

% Fill out the function below for a linear fit to answer e)
% Use 'help corrcoef' in command window to understand the function
R = corrcoef(ref_hour_Data.wind_speed_60 , metM_hour_Data.wind_speed_60);
R_sqr = R(1,2)*R(2,1);

plot(ref_hour_Data.wind_speed_60,fit1,'color','k','LineWidth',1.5);
legend({'Correlation',[' y = ',num2str(p(1)),'x + ',num2str(p(2)),char(10),'R^{2} = ',num2str(R_sqr)]})

%% Plot averaged wind direction at 58m
figure('name','Averaged wind direction at 58m');
% Edit the following plot function to answer g)
plot(metM_hour_Data.time_stamp  , metM_hour_Data.wind_dir_58,'x','color','b');
ylabel('Met-mast averaged direction [deg]');
xtickformat('dd-MM-yyyy HH:mm:SS')
grid on

%% Correlate WD met-mast with ref. site data
figure('name','Averaged wind direction correlation');
% Edit the following plot function to answer h)
plot(ref_hour_Data.wind_dir_10, metM_hour_Data.wind_dir_58,'d','MarkerEdgeColor','b','MarkerFaceColor','b');
ylabel('Met-mast averaged direction [deg]');
xlabel('Ref site direction [deg]');
grid on
hold on

%% Predict for the full range of ref site data
% Transform 33 years of wind speed data to 60m and m/s
WS_full_60 = ref_data(:,5).*0.514.*(h_metmast/h_ref)^shear_exp; % At 60m

% Filter the 33 years of data
bool_filter2 = (ref_data(:,5) == 0); % Filter
WS_full_60_filtered = WS_full_60(~bool_filter2);

% Fill out the function below to answer i)
% Use linear fit values to predict the 33 years
y = polyval(p, WS_full_60_filtered); % Predict

years = [1980:2013];
% Yearly average wind speed of prediction vs. measured
for i = 1:numel(years)
    Yearly_WS_predict(i) = mean(y(ref_data(~bool_filter2,1) == years(i)));
    Yearly_WS(i) = mean(WS_full_60_filtered(ref_data(~bool_filter2,1) == years(i)));
end

figure('name','Yearly predicted averaged wind speed at 60m');
plot(years,Yearly_WS,'x','color','b');
hold on
plot(years,Yearly_WS_predict,'x','color','k');
ylabel('Yearly predicted WS [m/s]');
xlabel('Years')
legend({'Ref','Prediction'})
ylim([0 12])
grid on

%% Weibull Curve from met-mast data
% Plot histogram (binned wind speeds)
figure
% Fill the following function to answer j)
% Use 'help histogram' in command window to understand the function
histogram(metM_hour_Data.wind_speed_60 ,'BinWidth', 1); % Distribution of wind speeds with 1m/s bins
xlabel('Met-mast WS [m/s]');
ylabel('Number of observations [-]');
hold on
grid on

% This fits the histogram to a Weibull distribution
pd = fitdist(metM_hour_Data.wind_speed_60,'Weibull');
% This finds A and B of Weibull distribution (you will learn this in
% following lectures)
w1 = wblpdf([0:0.5:26],pd.A,pd.B);

% Plot the Weibull
yyaxis right
plot([0:0.5:26],w1,'LineWidth',1.5)
ylabel('Probability [%]');
text(12, 0.06, ['  Weibull A & B: ', num2str(pd.A), ' & ', num2str(pd.B)]);

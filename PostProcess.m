% POSTPROCESSOR


function PostProcess(metM_hour_Data,ref_hour_Data,ref_data,WS_full_60)

set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultaxesticklabelinterpreter','latex');
set(groot,'defaultlegendinterpreter','latex');

%% Plot averaged wind speed at 60m

figure('name','Averaged wind speed at 60m');
% Edit the following plot function to answer a)
plot( metM_hour_Data.time_stamp , metM_hour_Data.wind_speed_60 ,'x','color','b');
ylabel('Hourly WS [m/s]');
xtickformat('dd-MM-yyyy HH:mm:SS')
grid on


%% Correlate WS met-mast with ref. site data
figure('name','Averaged wind speed correlation at 60m');
% Edit the following plot function to answer c)
plot(ref_hour_Data.wind_speed_10,  metM_hour_Data.wind_speed_60,'d','MarkerEdgeColor','b','MarkerFaceColor','b');
ylabel('Met-mast WS [m/s]');
xlabel('Ref Site WS [m/s]');
grid on

%% Correlate filtered met-mast with ref. site data
figure('name','Averaged wind speed correlation at 60m');
% Edit the following plot function to answer c) correctly
plot(ref_hour_Data.wind_speed_60_t, metM_hour_Data.wind_speed_60_t,'d','MarkerEdgeColor','b','MarkerFaceColor','b');
ylabel('Met-mast WS [m/s]');
xlabel('Ref Site WS [m/s]');
grid on
hold on

%% Linear best fit & Pearson coeff.
% Fill out the following two functions for a linear fit to answer d)
% Use 'help polyfit' in command window to understand the function
p = polyfit( ref_hour_Data.wind_speed_60_t,metM_hour_Data.wind_speed_60_t , 1);
% Use 'help polyval' in command window to understand the function
fit1 = polyval(p, ref_hour_Data.wind_speed_60_t);

% Fill out the function below for a linear fit to answer e)
% Use 'help corrcoef' in command window to understand the function
R = corrcoef(ref_hour_Data.wind_speed_60_t , metM_hour_Data.wind_speed_60_t);
R_sqr = R(1,2)*R(2,1);

plot(ref_hour_Data.wind_speed_60_t,fit1,'color','k','LineWidth',1.5);
legend({'Correlation',[' y = ',num2str(p(1)),'x + ',num2str(p(2)),char(10),'R^{2} = ',num2str(R_sqr)]})

%% Plot averaged wind direction at 58m
figure('name','Averaged wind direction at 58m');
% Edit the following plot function to answer g)
plot(metM_hour_Data.time_stamp_t  , metM_hour_Data.wind_dir_58_t,'x','color','b');
ylabel('Met-mast averaged direction [deg]');
xtickformat('dd-MM-yyyy HH:mm:SS')
grid on

%% Correlate WD met-mast with ref. site data
figure('name','Averaged wind direction correlation');
% Edit the following plot function to answer h)
plot(ref_hour_Data.wind_dir_10_t, metM_hour_Data.wind_dir_58_t,'d','MarkerEdgeColor','b','MarkerFaceColor','b');
ylabel('Met-mast averaged direction [deg]');
xlabel('Ref site direction [deg]');
grid on
hold on

%% Predict for the full range of ref site data

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
histogram(metM_hour_Data.wind_speed_60_t ,'BinWidth', 1); % Distribution of wind speeds with 1m/s bins
xlabel('Met-mast WS [m/s]');
ylabel('Number of observations [-]');
hold on
grid on

% This fits the histogram to a Weibull distribution
pd = fitdist(metM_hour_Data.wind_speed_60_t,'Weibull');
% This finds A and B of Weibull distribution (you will learn this in
% following lectures)
w1 = wblpdf([0:0.5:26],pd.A,pd.B);

% Plot the Weibull
yyaxis right
plot([0:0.5:26],w1,'LineWidth',1.5)
ylabel('Probability [%]');
text(12, 0.06, ['  Weibull A & B: ', num2str(pd.A), ' & ', num2str(pd.B)]);


end
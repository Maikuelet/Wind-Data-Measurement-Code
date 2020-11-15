%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   WEN II -  MCP EXERCISE 1    %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Miquel Altadill Llasat  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2:         06.11.2020


clc
clear
close all

ReadData = 0;

if ReadData == 1
    [metM_hour_Data,ref_hour_Data,ref_data] = Preprocess();
else
    [metM_hour_Data,ref_hour_Data,ref_data] = Data_Loading();
end

[metM_hour_Data,ref_hour_Data,WS_full_60]= Data_Treatment(metM_hour_Data,ref_hour_Data,ref_data);
PostProcess(metM_hour_Data,ref_hour_Data,ref_data,WS_full_60);
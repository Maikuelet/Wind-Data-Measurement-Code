%% DATA LOADING

function [metM_hour_Data,ref_hour_Data,ref_data] = Data_Loading()


    
pathh     = pwd;                                  % Path Where Saved main.m
myfolder  = 'Workspace';                          % Folder where Saved

% -----------------       metytM_hour_Data          ----------------- %
FrameFolder = fullfile(pathh , myfolder, 'metM_hour_Data.mat'); % Generate Adress
load(FrameFolder);                                              % Load Adress

% -----------------       Ref_hour_Data          ----------------- %
FrameFolder = fullfile(pathh , myfolder, 'ref_hour_Data.mat');     
load(FrameFolder);                                      

% -----------------       Ref_data          ----------------- %
FrameFolder = fullfile(pathh , myfolder, 'ref_data.mat');      
load(FrameFolder);                                        
end
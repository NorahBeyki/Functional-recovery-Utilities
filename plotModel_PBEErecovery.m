% Plot Functional Recovery Plots For a Single Model and Single Intensity
clear all
close all
clc
rehash

%% Define User inputs
model_name = 'Desmond Building Retrofitted - Structural - Office'; % Name of the model;
% inputs are expected to be in a directory with this name
% outputs will save to a directory with this name
model_dir = ['outputs' filesep model_name]; % Directory where the simulated inputs are located
p_gantt = 50; % percentile of functional recovery time to plot for the gantt chart
% e.g., 50 = 50th percentile of functional recovery time
crew = [10,30,50,60];

for j=4:4
    result_dir = ['outputs' filesep model_name filesep strcat('Crew_',num2str(crew(j)))]; % Directory where the simulated inputs are located
    
    for i=6:6
        plot_dir = [result_dir filesep strcat('plots',num2str(i))]; % Directory where the plots will be saved        
        load([result_dir filesep strcat('recovery_outputs_intensity_',num2str(i),'.mat')]);
        %% Import Packages
        import plotters.main_plot_functionality
        
        %% Load Assessment Output Data
        % load([outputs_dir filesep 'recovery_outputs_intensity_4.mat'])
        
        %% Create plot for single intensity assessment of PBEE Recovery
        main_plot_functionality( functionality, plot_dir, p_gantt )
    end
end

% for i=1:1
%     plot_dir = [model_dir filesep strcat('plots',num2str(i))]; % Directory where the plots will be saved
%     load([model_dir filesep strcat('recovery__Nolifeline_outputs_intensity_',num2str(i),'.mat')]);
%     %% Import Packages
%     import plotters.main_plot_functionality
%     
%     %% Load Assessment Output Data
%     % load([outputs_dir filesep 'recovery_outputs_intensity_4.mat'])
%     
%     %% Create plot for single intensity assessment of PBEE Recovery
%     main_plot_functionality( functionality, plot_dir, p_gantt )
% end

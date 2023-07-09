% This script facilitates the performance based functional recovery and
% reoccupancy assessment of a single building for a single intensity level

% Input data consists of building model info and simulated component-level
% damage and conesequence data for a suite of realizations, likely assessed
% as part of a FEMA P-58 analysis. Inputs are read in as matlab variables
% direclty from matlab data files, as well as loaded from csvs in the
% static_tables directory.

% Output data is saved to a specified outputs directory and is saved into a
% single matlab variable as at matlab data file.

clear
close all
clc
rehash
Crew = [10 30 50 60];
RP = [72, 108, 224, 475, 975, 2475, 4975];
for j=1:7
    for i=2:2%length(Crew)
        %% Define User Inputs
        model_name = 'Example 1'; % Name of the model;
        % inputs are expected to be in a directory with this name
        % outputs will save to a directory with this name

        %% Define I/O Directories
        model_dir = ['inputs' filesep model_name filesep strcat('Crew_',num2str(Crew(i)))]; % Directory where the simulated inputs are located
        outputs_dir = ['outputs' filesep model_name filesep strcat('Crew_',num2str(Crew(i)))]; % Directory where the assessment outputs are saved

        %% Load FEMA P-58 performance model data and simulated damage and loss
        load([model_dir filesep strcat('intensity_',num2str(j),'.mat')])
        load([model_dir filesep strcat('Utilities_',num2str(RP(j)),'.mat')])
        %% Some additional translation of SP3 inputs
        repair_time_options = repair_time_options_atc_138.repair_time_options;
        functionality_options = repair_time_options_atc_138.functionality_options;
        tenant_units = repair_time_options_atc_138.tenant_units;

        %% Load required static data
        systems = readtable(['static_tables' filesep 'systems.csv']);
        subsystems = readtable(['static_tables' filesep 'subsystems.csv']);
        impeding_factor_medians = readtable(['static_tables' filesep 'impeding_factors.csv']);
        tmp_repair_class = readtable(['static_tables' filesep 'temp_repair_class.csv']);
        functionality.utilities=Output.utilities;
        %% Run Recovery Method
        [functionality] = main_PBEErecovery(damage, damage_consequences, ...
            building_model, tenant_units, systems, subsystems, tmp_repair_class, ...
            impedance_options, impeding_factor_medians,  regional_impact, ...
            repair_time_options, functionality, functionality_options);
        %% Save Outputs
        if ~exist(outputs_dir,'dir')
            mkdir(outputs_dir)
        end
        save([outputs_dir filesep strcat('recovery_outputs_intensity_',num2str(j),'.mat')],'functionality')
        fprintf('Recovery assessment of model %s complete\n',model_name)
    end
end

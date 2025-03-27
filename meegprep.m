function meegprep(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Automatic MEEG cleaning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Scripted leadfield pipeline for Freesurfer anatomy files
% Brainstorm (25-Sep-2019) or higher
%


% Authors
% - Ariosky Areces Gonzalez
% - Deirel Paz Linares
%
%    November 15, 2019


%% Preparing WorkSpace
clc;
close all;
clearvars -except varargin;
disp('-->> Starting process');
% restoredefaultpath;

%%
%------------ Preparing properties --------------------
import app.*
import app.functions.*
import functions.*
import guide.*
import tools.*

%%
%% Init processing
%%
try
    properties = jsondecode(fileread(fullfile(pwd,'+app','properties.json')));
catch EM
    fprintf(2,"\n ->> Error: The app/properties file do not have a correct format \n");
    disp("-->> Message error");
    disp(EM.message);
    disp('-->> Process stopped!!!');
    return;
end
%% Printing data information
disp(strcat("-->> Name:",properties.generals.name));
disp(strcat("-->> Version:",properties.generals.version));
disp(strcat("-->> Version date:",properties.generals.version_date));
disp("==========================================================================");

%%
%% Starting mode
%%
prep_init();
setGlobalGuimode(true);
for i=1:length(varargin)
    if(isequal(varargin{i},'nogui'))
        setGlobalGuimode(false);
    end
end
if(getGlobalGuimode())
    MEEGprepUI
else
    %% ------------  Checking app properties --------------------------
    properties  = get_properties();
    if(isequal(properties,'canceled'))
        return;
    end
    [status, reject_subjects]    = check_properties(properties);
    if(~status)
        fprintf(2,strcat('\nBC-V-->> Error: The current configuration files are wrong \n'));
        disp('Please check the configuration files.');
        return;
    end

    %%
    %% Starting EEGLAB
    %%
    addpath(properties.general_params.eeglab.base_path);
    eeglab nogui;   
    PLUGINLIST = evalin('base', 'PLUGINLIST');
    isInstalled = find(ismember({PLUGINLIST.plugin},{'Cleanline'}),1);
    if(isempty(isInstalled) || ~isInstalled )
        plugin_askinstall('Cleanline',[],1);
    end

    %%
    %% Calling dataset function to analysis
    %%
    process_error = process_interface(properties, reject_subjects);
end
restoredefaultpath;
disp('-->> Process finished...');
disp("=================================================================");
close all;
clear all;
end




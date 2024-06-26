function [status,reject_subjects] = check_properties(properties)
%CHECK_PROPERTIES Summary of this function goes here
%   Detailed explanation goes here
status = true;
reject_subjects = {};
disp("-->> Checking properties");

%%
%% Checking general params
%%
disp('-->> Checking general params');
general_params = properties.general_params;
if(isempty(general_params.modality) && ~isequal(general_params.modality,'EEG') && ~isequal(general_params.modality,'MEG'))
    status = false;
    fprintf(2,'\n-->> Error: The modality have to be EEG or MEG.\n');
    disp('-->> Process stoped!!!');
    return;
end
if(~isfolder(general_params.workspace.base_path))
    status = false;
    fprintf(2,'\n-->> Error: The output path is not a folder.\n');
    disp(general_params.ciftistorm.base_path);
    disp('-->> Process stoped!!!');
    return;
end
if(~isfolder(general_params.eeglab.base_path) || ~isfile(fullfile(general_params.eeglab.base_path,'eeglab.m')))
    status = false;
    fprintf(2,'\n-->> Error: The EEGLAB path is not correct.\n');
    disp(general_params.eeglab.base_path);
    disp('-->> Process stoped!!!');
    return;
end

%%
%% Checking MEEG data configuration
%%
if(~isfolder(general_params.meeg_data.base_path))
    status = false;
    fprintf(2,'\n-->> Error: The MEEG path is not a folder.\n');
    disp(general_params.meeg_data.base_path);
    disp('Please type a correct MEEG folder in the general_params.json configuration file.');
    disp('-->> Process stoped!!!');
    return;
end

%%
%% Checking preprocessed data params
%%
% disp('-->> Checking meeg data configuration');
% prep_params = properties.prep_data_params;
% prep_config = prep_params.data_config;
% base_path = strrep(prep_config.base_path,'SubID','');
% 
% if(prep_config.isfile)
%     [path,name,ext] = fileparts(prep_config.reference_file);
%     if(~isequal(strcat('.',prep_config.format),ext) &&  ~isequal(lower(prep_config.format),'matrix') &&  ~isequal(lower(prep_config.format),'crosspec'))
%         fprintf(2,'The preprocessed data format and the file location extension do not match.\n');
%         disp('Please check the process_prep_data.json configuration file.');
%         status = false;
%         disp('-->> Process stoped!!!');
%         return;
%     end
%     structures = dir(base_path);
%     structures(ismember( {structures.name}, {'.', '..','derivatives'})) = [];  %remove . and ..
%     structures([structures.isdir] == 0) = [];  %remove . and ..
%     count_data = 0;
%     for i=1:length(structures)
%         structure = structures(i);
%         data_file = dir(fullfile(base_path,structure.name,'**',strrep(prep_config.reference_file,'SubID',structure.name)));
%         if(isempty(data_file))
%             count_data = count_data + 1;
%             reject_subjects{length(reject_subjects)+1} = structure.name;
%             continue;
%         end
%         data_file = fullfile(data_file.folder,data_file.name);
%         if(~isfile(data_file))
%             count_data = count_data + 1;
%             reject_subjects{length(reject_subjects)+1} = structure.name;
%         end
%     end
%     if(~isequal(count_data,0))
%         if(isequal(count_data,length(structures)))
%             fprintf(2,'Any folder in the Prep_data path have a specific file location.\n');
%             fprintf(2,'We can not find the Prep_data file in this address:\n');
%             fprintf(2,strcat(prep_config.reference_file,'\n'));
%             disp('Please check the Prep_data configuration.');
%             status = false;
%             disp('-->> Process stoped!!!');
%             return;
%         else
%             warning('One or more of the Prep_data file are not correct.');
%             warning('We can not find at least one of the Prep_data file in this address:');
%             warning(strcat(prep_config.reference_file));
%             warning('Please check the Prep_data configuration.');
%         end
%     end
% end



% 
% reject_subjects = unique(reject_subjects);
% disp("--------------------------------------------------------------------------");
% disp("-->> Subjects to reject");
% warning('-->> Some subject do not have the correct structure');
% warning('-->> The following subjects will be rejected for analysis');
% disp(reject_subjects);
% warning('Please check the folder structure.');
% 
% disp('-->> All properties checked.');


end

                                                                                                                                                            
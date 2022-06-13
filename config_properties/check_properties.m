function status = check_properties(properties)
%CHECK_PROPERTIES Summary of this function goes here
%   Detailed explanation goes here
status = true;
disp("-->> Checking properties");

%%
%% Checking general params
%%
disp('-->> Checking general params');
general_params = properties.general_params.params;
if(isempty(general_params.modality) && ~isequal(general_params.modality,'EEG') && ~isequal(general_params.modality,'MEG'))
    status = false;
    fprintf(2,'\n-->> Error: The modality have to be EEG or MEG.\n');
    disp('-->> Process stoped!!!');
    return;
end

if(~isempty(general_params.colormap) && ~isequal(general_params.colormap,'none') && ~isfile(general_params.colormap))
    status = false;
    fprintf(2,'\n-->> Error: Do not exist the colormap file defined in selected dataset configuration file.\n');
    disp(general_params.colormap);
    disp('-->> Process stoped!!!');
    return;
end

%%
%% Checking preprocessed data params
%%
disp('-->> Checking preprocessed data params');
prep_params = properties.prep_data_params.params;
prep_config = prep_params.data_config;
base_path = strrep(prep_config.base_path,'SubID','');
if(~isfolder(fullfile(base_path)))
    fprintf(2,'The prerpocessed_data base path is not a folder.\n');
    disp('Please type a correct prerpocessed_data folder in the process_prep_data.json configuration file.');
    status = false;
    disp('-->> Process stoped!!!');
    return;
end
if(isempty(prep_config.format))
    fprintf(2,'The preprocessed data format can not be empty.\n');
    disp('Please type a correct preprocessed data format in the process_prep_data.json configuration file.');
    status = false;
    disp('-->> Process stoped!!!');
    return;
end
if(prep_config.isfile)
    [path,name,ext] = fileparts(prep_config.file_location);
    if(~isequal(strcat('.',prep_config.format),ext) &&  ~isequal(lower(prep_config.format),'matrix'))
        fprintf(2,'The preprocessed data format and the file location extension do not match.\n');
        disp('Please check the process_prep_data.json configuration file.');
        status = false;
        disp('-->> Process stoped!!!');
        return;
    end
    structures = dir(base_path);
    structures(ismember( {structures.name}, {'.', '..'})) = [];  %remove . and ..
    count_data = 0;
    for i=1:length(structures)
        structure = structures(i);
        data_file = fullfile(base_path,structure.name,strrep(prep_config.file_location,'SubID',structure.name));
        if(~isfile(data_file)); count_data = count_data + 1; end
    end
    if(~isequal(count_data,0))
        if(isequal(count_data,length(structures)))
            fprintf(2,'Any folder in the Prep_data path have a specific file location.\n');
            fprintf(2,'We can not find the Prep_data file in this address:\n');
            fprintf(2,strcat(prep_config.file_location,'\n'));
            disp('Please check the Prep_data configuration.');
            status = false;
            disp('-->> Process stoped!!!');
            return;
        else
            warning('One or more of the Prep_data file are not correct.');
            warning('We can not find at least one of the Prep_data file in this address:');
            warning(strcat(prep_config.file_location));
            warning('Please check the Prep_data configuration.');
        end
    end
end
disp('-->> All preoperties checked.');


end

                                                                                                                                                            
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
if(isequal(prep_params.process_type.type,1))
    
elseif(isequal(prep_params.process_type.type,2))
    prep_config = prep_params.process_type.type_list{2};
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
if(isequal(prep_params.process_type.type,1) || isequal(prep_params.process_type.type,2))
    % Checking clean data params
    clean_data = prep_params.clean_data;
    if(clean_data.run)
        if(isempty(clean_data.toolbox))
            fprintf(2,'The clean data toolbox can not be empty.\n');
            disp('Please type a correct clean data toolbox in the process_prep_data.json configuration file.');
            status = false;
            disp('-->> Process stoped!!!');
            return;
        end
        if(isequal(clean_data.toolbox,'eeglab'))
            if(isempty(clean_data.toolbox_path) || ~isfile(fullfile(clean_data.toolbox_path,'eeglab.m')))
                fprintf(2,'The clean data toolbox path is wrong.\n');
                disp('Please type a correct clean data toolbox path in the process_prep_data.json configuration file.');
                status = false;
                disp('-->> Process stoped!!!');
                return;
            end
        end
        if(isempty(clean_data.max_freq) || clean_data.max_freq < 20 || clean_data.max_freq > 90)
            fprintf(2,'The Clean_data max_frequency have be between 20 and 90 vertices.\n');
            disp('Please check the Clean_data max_frequency configuration in the process_prep_data.json file.');
            status = false;
            disp('-->> Process stoped!!!');
            return;
        end
        select_events = clean_data.select_events;
        if(~isempty(select_events.by) && ~isequal(select_events.by,'segments') && ~isequal(select_events.by,'marks'))
            fprintf(2,"\n ->> Error: The select_events type have to be <<empty>>, <<segments>>, or <<marks>>. \n");
            disp('empty: For use all data and do not extract events.');
            disp('segments: Get the data events from the good segments.');
            disp('marks: Get the data events from all segments.');
            status = false;
            disp('-->> Process stoped!!!');
            return;
        end
    end
end
disp('-->> All preoperties checked.');


end

                                                                                                                                                            
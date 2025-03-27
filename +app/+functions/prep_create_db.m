function prep_create_db()
MEEGprepDir = fullfile(getUserDir(),'.MEEGprep');
if(~isfolder(MEEGprepDir))
    mkdir(MEEGprepDir);
end
%% Defaults
% if(~isfolder(fullfile(MEEGprepDir,'defaults')))
%     mkdir(fullfile(MEEGprepDir,'defaults'));
% end
% if(~isfolder(fullfile(MEEGprepDir,'defaults','anatomy')))
%     mkdir(fullfile(MEEGprepDir,'defaults','anatomy'));
% end
% if(~isfolder(fullfile(MEEGprepDir,'defaults','eeg')))
%     mkdir(fullfile(MEEGprepDir,'defaults','eeg'));
%     mkdir(fullfile(MEEGprepDir,'defaults','eeg','Colin27'));
%     mkdir(fullfile(MEEGprepDir,'defaults','eeg','ICBM152'));
%     mkdir(fullfile(MEEGprepDir,'defaults','eeg','NotAligned'));
% end
% if(~isfolder(fullfile(MEEGprepDir,'defaults','meg')))
%     mkdir(fullfile(MEEGprepDir,'defaults','meg'));
% end

%% Datasets
if(~isfolder(fullfile(MEEGprepDir,'Datasets')))
    mkdir(fullfile(MEEGprepDir,'Datasets'));
end
if(~isfile(fullfile(MEEGprepDir,'Datasets','Datasets.json')))
    saveJSON([],fullfile(MEEGprepDir,'Datasets','Datasets.json'));
end
end


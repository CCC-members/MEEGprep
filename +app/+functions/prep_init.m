function  prep_init()
import app.*
import app.functions.*
import functions.*
import guide.*
import tools.*
homedir = char(java.lang.System.getProperty('user.home'));
MEEGprepDir  = fullfile(homedir,".MEEGprep");
if(~isfolder(MEEGprepDir))
    mkdir(MEEGprepDir);
end
MEEGprepDatasetsdir = fullfile(MEEGprepDir,'Datasets');
if(~isfolder(MEEGprepDatasetsdir))
    mkdir(MEEGprepDatasetsdir);
end

MEEGprepDatasetsfile = fullfile(MEEGprepDir,'Datasets','Datasets.json');
if(~isfile(MEEGprepDatasetsfile))
    Datasets = struct([]);
    saveJSON(Datasets,MEEGprepDatasetsfile);
end

end


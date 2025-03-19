function [Intensity_SC,GTposes] = Load_Data(pose_dir,down_shape,max_range)
%%
global data_path;
data_save_path = fullfile('./data/'); 
%%
% newly make
if ~exist(data_save_path,'dir')
    % make 
    [Intensity_SC,GTposes] = make_descriptor(data_path, pose_dir,down_shape,max_range);      
    % save
    mkdir(data_save_path);

    filename = strcat(data_save_path, 'Intensity_SC', '.mat');
    save(filename, 'Intensity_SC');
    filename = strcat(data_save_path, 'GTposes', '.mat');
    save(filename, 'GTposes');
 
% or load 
else
    filename = strcat(data_save_path, 'Intensity_SC', '.mat');
    load(filename);
    
    filename = strcat(data_save_path, 'GTposes', '.mat');
    load(filename);
    
    disp('- successfully loaded.');
end

end
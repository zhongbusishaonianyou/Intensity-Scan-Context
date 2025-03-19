function [Intensity_SC, xy_poses] = make_descriptor(data_dir,pose_dir, shape,max_range)

num_rings = shape(1);
num_sectors =shape(2);
%% Read 
lidar_data_dir = strcat(data_dir, 'velodyne/');
data_names = osdir(lidar_data_dir);
%%
num_data = length(data_names);
save_counter = 1;

Intensity_SC = cell(1, num_data);
xy_poses = zeros(num_data, 2);

%% gps to xyz
gtpose = csvread(strcat(data_dir, pose_dir));
gtpose_xy = gtpose(:, [4,12]);


for data_idx = 1:num_data
    file_name = data_names{data_idx};
    data_path = strcat(lidar_data_dir, file_name);
    
    ptcloud =read_intensity(data_path);
    intensity_sc = Ptcloud2_ISC(ptcloud,num_sectors,num_rings,max_range); 
    xy_pose = gtpose_xy(data_idx, :);
    
    % save 
    Intensity_SC{save_counter} = intensity_sc;
    xy_poses(save_counter, :) = xy_pose;
    save_counter = save_counter + 1;
    
    % log
    if(rem(data_idx, 100) == 0)
        message = strcat(num2str(data_idx), " / ", num2str(num_data));
        disp(message); 
    end
end
end
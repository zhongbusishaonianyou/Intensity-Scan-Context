function [ img ] = Ptcloud2_ISC( ptcloud, sectors, rings, max_dis )

%% Preprocessing 

% Downsampling for fast search
% gridStep = 0.5; % 0.5m cubic grid downsampling is applied in the paper.
% ptcloud = pcdownsample(ptcloud, 'gridAverage', gridStep);

% point cloud information 
num_points = ptcloud.Count;
img = zeros(rings, sectors);
ring_step = max_dis / rings; 
sector_step = 2*pi/sectors;

for ith_point =1:num_points
    
    ith_point_xyz = ptcloud.Location(ith_point,:);
    distance = sqrt(ith_point_xyz(1)^2 + ith_point_xyz(2)^2);
        if(distance>=max_dis)
            continue;
        end
        angle = pi + atan2(ith_point_xyz(2),ith_point_xyz(1));
        ring_id = floor(distance/ring_step)+1;
        sector_id = floor(angle/sector_step)+1;
        if(ring_id>rings)
            continue;
        end
        if(sector_id>sectors)
            continue;
        end

        intensity_temp = floor(255*ptcloud.Intensity(ith_point,1));
       
        if(img(ring_id,sector_id)<intensity_temp)
           img(ring_id,sector_id)=intensity_temp;
        end
end


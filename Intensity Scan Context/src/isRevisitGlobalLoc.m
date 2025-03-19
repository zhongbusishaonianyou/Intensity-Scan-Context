function [is_revisit, loop_index] = isRevisitGlobalLoc(query_pose, db_poses, thres)

num_dbs = size(db_poses, 1);

min_dist=10000000;
for ii=1:num_dbs
    dist = norm(query_pose - db_poses(ii, :));
    if(dist<min_dist)
    min_dist = dist; 
    min_index=ii;
    end
end

if (min_dist < thres ) 
    is_revisit = 1;
else
    is_revisit = 0;
end

loop_index =min_index;

end


clear; clc;
addpath(genpath('src'));
global data_path; 
%  directory structure 
% - 00
%   - 00.csv (gtpose)
%   - velodyne
%      - <00001.bin>
%      - <00002.bin>
%% data path setting
data_path =  '../02/'; 
GTposes_file='02.csv';
%% loading ground-truth poses and creating Intensity scan context
resolution = [20, 60];Range=50;
[Intensity_SC, GT_poses] = Load_Data(GTposes_file,resolution,Range);
%% loop parameter setting
 revisit_criteria = 4; 
 num_node_enough_apart = 300; 
%% main 
num_queries = length(GT_poses);
results=zeros(num_queries-num_node_enough_apart,2);
is_revisit=zeros(num_queries-num_node_enough_apart,1);
exp_poses=[];
for query_idx = 1:num_queries 
    
    query_isc = Intensity_SC{query_idx};
    query_pose = GT_poses(query_idx,:);
    exp_poses=[exp_poses;query_pose];
    if( query_idx <= num_node_enough_apart )
       continue;
    end  
     revisitness= isRevisitGlobalLoc(query_pose, exp_poses(1:query_idx-num_node_enough_apart, :), revisit_criteria);
     is_revisit(query_idx-num_node_enough_apart,1)=revisitness;
    % find candidates 
     best_score=1;   
    for candidate_idx=1:query_idx-num_node_enough_apart 
        similarity_score=is_loop_pair(query_isc,Intensity_SC{candidate_idx},resolution);   
        if ( similarity_score<best_score)
           best_score =similarity_score;
           matched_id =candidate_idx;
        end
         
    end
    
    results(query_idx-num_node_enough_apart,:)=[matched_id,best_score];
    
    if( rem(query_idx, 100) == 0)
        disp( strcat(num2str(query_idx/num_queries * 100), ' % processed') );
    end
    
end
%% Entropy thresholds 
min_thres=min(results(:,2))+0.01;
max_thres=max(results(:,2))+0.01;
thresholds = linspace(min_thres, max_thres,100); 
num_thresholds = length(thresholds);

% Main variables to store the result for drawing PR curve 
num_hits=zeros(1, num_thresholds);
Precisions = zeros(1, num_thresholds); 
Recalls = zeros(1, num_thresholds); 
true_positive=sum(is_revisit);
%% prcurve analysis 
for thres_idx = 1:num_thresholds
  threshold = thresholds(thres_idx);
  predict_postive=0;num_hits=0;
    for frame_idx=1:length(is_revisit)
        min_dist=results(frame_idx,2);
        matching_idx=results(frame_idx,1);
        revisit=is_revisit(frame_idx,1); 
            if( min_dist <threshold)
                predict_postive=predict_postive+1;
                if(dist_btn_pose(GT_poses(frame_idx+num_node_enough_apart,:), GT_poses(matching_idx, :)) < revisit_criteria)
                    %TP
                    num_hits= num_hits + 1;
                end     
            end
    end
  
    Precisions(1, thres_idx) = num_hits/predict_postive;
    Recalls(1, thres_idx)=num_hits/true_positive;
    
end
%% save the log 
savePath = strcat("pr_result/within ", num2str(revisit_criteria), "m/");
if((~7==exist(savePath,'dir')))
    mkdir(savePath);
end
save(strcat(savePath, 'nPrecisions.mat'), 'Precisions');
save(strcat(savePath, 'nRecalls.mat'), 'Recalls');
%% visiualize GT path
figure(1);hold on;
plot(GT_poses(:,1), GT_poses(:,2),'LineWidth',2);
axis equal; grid on;
legend('Groud-Truth');

%%  save the loop information
data_save_path = fullfile('./data/'); 
filename = strcat(data_save_path, 'results', '.mat');
save(filename, 'results');

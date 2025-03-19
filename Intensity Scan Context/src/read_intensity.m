function ptcloud = read_intensity(bin_path)
%% Read 
fid = fopen(bin_path, 'rb'); raw_data = fread(fid, 'float32'); fclose(fid);
count=0;
for index=3:4:length(raw_data)/4-1
  if (raw_data(index,1)<-1.5)||(raw_data(index,1)>30)
      continue;
  else
      count=count+1;
      points(count,:)=raw_data(index-2:index+1)';
  end
end
ptcloud = pointCloud(points(:,1:3),'Intensity',points(:,4));
end
function ply2mat(path,fname)
%% 载入数据 (TXT格式变为MAT格式  便于后续load data使用)
pointCloud1 = pcread(join([path,fname]));
%pointCloud2=pcread('H:\配准\数据集\office\s2.ply');
% 显示DData
figure
pcshow(pointCloud1 );
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Original pointCloud1 ');
%% 将DData转化为矩阵
DData1(:,1)= double(pointCloud1.Location(1:5:end,1));
DData1(:,2)= double(pointCloud1.Location(1:5:end,2));
DData1(:,3)= double(pointCloud1.Location(1:5:end,3));
% %% 将MData转化为矩阵
% MData1(:,1)= double(pointCloud2.Location(1:5:end,1));
% MData1(:,2)= double(pointCloud2.Location(1:5:end,2));
% MData1(:,3)= double(pointCloud2.Location(1:5:end,3));
%% 保存点云数据
office(1,1)={DData1};
office(1,2)={'001'};
% office(2,1)={MData1};
% office(2,2)={'002'};
%[filepath,name,ext] = fileparts(join([path,fname]))
file=join([path(1:end-4),'\mat\',fname(1:end-4),'.mat'])
save(file)

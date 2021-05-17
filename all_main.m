%% 批量处理数据
clc; 
clear; 
close all;
path='F:\GitFile\IntrA\data\IntrA\generated\aneurysm\ply\';
f1=dir(fullfile(path,'*.ply'));
n1=length(f1);
for i=1:n1
    fname=f1(i).name;
    ply2mat(path,fname);
end

%% 批量提取骨架
clc; 
clear; 
close all;
path='F:\GitFile\IntrA\data\IntrA\generated\aneurysm\mat\';
f1=dir(fullfile(path,'*.mat'));
n1=length(f1);
for i=1:n1
    fname=f1(i).name;
    main(path,fname);
end
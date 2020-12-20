clc,clear
% % ��ȡ����
    load ('./data/leaf');
    Datapoints = (points(:,:)-min(min(points)))/(max(max(points))-min(min(points)));%��һ��
    
    Pc = Datapoints;
    figure;
    plot3(Pc(:,1),Pc(:,2),Pc(:,3),'.','color',[0 0 0],'MarkerSize',3);
    axis off,axis equal
    view(0,90);
    title('ԭʼ����')
% %�Ӹ�˹����
%     ratio=1.2; %������
%     [noisepoints]=addGaussianNoise(Pc,ratio);
%     Datapoints=noisepoints;
    P =Datapoints;
    figure;
    plot3(P(:,1),P(:,2),P(:,3),'.','color',[0 0 0],'MarkerSize',5);
    axis off,axis equal
    view(0,90);
% ���Ƶ���� 
    dn = size(P,1);
% ���ѡȡ���������
    N = floor(dn/10); %10%
% �����㼯��
    r = randi([1 dn],1,N); %�������
%     r=[409,319,43,326,618,456,546,689,240,550,643,319,384,481,346,135,167,304,12,553,46,318,400,450,322,60,209,54,538,255,481,355,282,241,76,273];
    skel = P(r,:); %��ʼ���Ǽܵ�
% ��ʾ������
    hold on
    plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
    title('����');
% OT����
    mass_p = ones(size(P,1),1) ./ size(P,1);     %�����ʼ����p
%     [mass_p]=ComputeMass(P);                  %�����ܶȷֲ������ʼ����
    mass_s = ones(size(skel,1),1)./size(skel,1); % ��ʼ���Ǽܵ������
    lambda =200;    %Important Parameter
% ƽ������
    n=0; % ��ֵ���� n=0����ֵ
    lamda=200;  %Smooth Parameter
    weightValue = 0.3;  %Smooth Parameter
% ��ͼ����
    % ���ű���
    pscale=50000;  % ��ʼ�Ǽ�
    mscale=50000; % ƽ���Ǽ�
    % �ߴ�
    Dsize=5; %���ƴ�С
    Linewidth=3; %�߿�
% ���Ŵ������Ǽܵ�
    [mass_s,skel,OT,mergep,nonskelpoints]=ComputeSkeleton(Datapoints,skel,mass_p,mass_s,lambda);
% ȷ�����ӹ�ϵ
    lianjie = showSkel(Datapoints,skel,OT);
    PlotSkeleton(Datapoints,Dsize,mass_s,skel,lianjie,pscale,Linewidth);
    title('�����Ǽ�');
%     [skel,lianjie,OT,mass_s,lambda]=NewComputeSkeleton(Datapoints,skel,lianjie,OT,mass_s,mass_p,lambda);


% ���չǼ�
    figure;
    plot3(P(:,1),P(:,2),P(:,3),'.','color',[0 0 0],'MarkerSize',5);
    for i=1:size(skel,1)
        hold on;
        plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[1 0 0],'MarkerSize',50);
    end
    axis off,axis equal;
    view(0,90);
    for i=1:size(skel,1)
        for j=i:size(skel,1)
            if lianjie(i,j) == 1
                hold on
                plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0],'LineWidth',5);
            end
        end
    end
   title('�ֲڹǼ�');

% �����������Ǽ�+����
    PlotSkeleton(Datapoints,Dsize,mass_s,skel,lianjie,pscale,Linewidth);
    title('�ֲڹǼ�');

% ȥ��
    [OT,skel,lianjie,mass_s]=deloop(r,OT,skel,lianjie,mass_s,Datapoints);
    PlotSkeleton(Datapoints,Dsize,mass_s,skel,lianjie,pscale,Linewidth);
    title('ȥ��');

% �Ǽ�ƽ��
    [newskel,newlianjie,newmass_s]=smooth(Datapoints,lianjie,skel,mass_s,lamda,weightValue,n);
    PlotSmoothSkeleton(Datapoints,Dsize,newmass_s,newskel,newlianjie,mscale,Linewidth);
    title('ƽ���Ǽ�');

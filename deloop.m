function [OT,skel,lianjie,mass_s]=deloop(r,OT,skel,lianjie,mass_s,Datapoints)
P=Datapoints;
% r=r;
% OT=OT;
% skel=skel;

%������ֵ
classNumValue=0.15;
%tmpA�Ǹ��º�����Ӿ���,ClassA��a��Ľڵ���ͼ��ClassAA�ǶԽڵ㰴�����
%(boolClassNum=0��ʾ�����࣬boolClassNum=1��ʾֻ��һ��)
conditionRefine = true;
while(conditionRefine)
    result=testSymmetry(P,skel,OT);
    [tmpA,ClassA,ClassAA,boolClassNum]=subGraphs2(lianjie,result,classNumValue,skel);

    %�һ� ���ر���:�Ƿ��л�(��������)���л����������л��Ľڵ㣬�Ƿ�����޻���֧(��������)���޻��������޻��ڵ�
    [boolcircle,circleindex,circle,boolnocircle,nocircleindex,nocircle]=findcircle(ClassAA,skel,lianjie);
    if  ~boolcircle
        conditionRefine = false;
    end

%     figure
%     plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
    ClassANum=length(ClassA);
%     ÿһ����ͨ��ͼ��ͼ
%     for i=1:size(skel,1)
%         for j=i:size(skel,1)
%             if lianjie(i,j) == 1 
%                 hold on
%                 plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0]);
%             end
%         end
%     end
    %
    if boolcircle || boolnocircle
        [ skel,mass_s ] = mergingCircle( skel, mass_s,nocircle,circle ,boolcircle,boolnocircle, OT);
        condition_OT = true;
        TPOne = 9999999; % ǰһ�εĴ������
        TPTwo = 0;
        thresholdTP = 0.0001; % ���������ֵ
        lambda =500;
        mass_p = ones(size(P,1),1) ./ size(P,1); 
        while (condition_OT)
                    TPone = TPTwo;
                    [OT,OTValue] = ot(P,skel,mass_p,mass_s,lambda);   % ���㴫��ƻ�
                    skel = center(P,skel,OT);
                    TPTwo = OTValue;
                    if abs(TPone - TPTwo) < thresholdTP 
                        condition_OT =false;
                    end           
        end
        lianjie = showSkel(P,skel,OT);
    end
end
        
end
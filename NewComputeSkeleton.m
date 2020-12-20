function[skel,lianjie,OT,mass_s,lambda]=NewComputeSkeleton(Datapoints,skel,lianjie,OT,mass_s,mass_p,lambda)
if lambda-100>0
    lambda=lambda-100;
end
    P=Datapoints;
    classNumValue=0.25; %�Գ��Է�����ֵ
    result=testSymmetry(P,skel,OT);
    [~,ClassA,ClassAA,~]=subGraphs2(lianjie,result,classNumValue,skel);
    [~,~,loop,~,~,~]=findcircle(ClassAA,skel,lianjie);
    circle=[];
    for i=1:size(loop,2)
        xx=loop{i};
        circle=[circle xx];
    end
if isempty(circle)
    lambda=0;
end
if~isempty(circle)&&lambda>0
         figure;
            axis off,axis equal;
            view(0,90);
            hold on;
             plot3(P(:,1),P(:,2),P(:,3),'.','color',[0 0 0],'MarkerSize',8);
            for i=1:size(skel,1)
                hold on;          
                    plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[0 1 0],'MarkerSize',80);%��ɫ-�Ǽܵ�     
            end
            for i=1:size(skel,1)
                for j=i:size(skel,1)
                    if lianjie(i,j) == 1
                        hold on
                        plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0],'LineWidth',5);
                    end
                end
            end
%             set(gca,'position',[0 0 1 1]);
        if ~isempty(circle)
            for i=1:size(circle,2)
                hold on
                plot3(skel(circle(1,i),1),skel(circle(1,i),2),skel(circle(1,i),3),'.','color',[0 0 1],'MarkerSize',80);  %��ɫ-�ǹǼܵ�
            end
        end
        if ~isempty(ClassA)
            for i=1:size(ClassA,2)
    %             if find(circle==ClassA(1,i))
                hold on
                plot3(skel(ClassA(1,i),1),skel(ClassA(1,i),2),skel(ClassA(1,i),3),'.','color',[1 0 1],'MarkerSize',80);  %��ɫ-�ǹǼܵ�
    %             end
            end
        end
        title('���Գ���');
    TPTwo = 0;
    condition_OT = true;
    thresholdTP = 0.0001;
    while (condition_OT)
                TPone = TPTwo;
                [OT,OTValue] = ot(Datapoints,skel,mass_p,mass_s,lambda);   % ���㴫��ƻ�
                skel = center(Datapoints,skel,OT);
                TPTwo = OTValue;
                if abs(TPone - TPTwo) < thresholdTP 
                    condition_OT =false;
                end           
    end
    skelOne=skel;
    nonskelpoints=circle';
    relationSkeleton=lianjie;
    M = pdist2(skelOne,P);
    Tcost=OT.*M;
      cost(size(skelOne,1),1) = 0;
      for i = 1 : size(skelOne, 1)
          massSkel(i ,1) = sum(OT(i,:));
          cost(i,1)=sum(Tcost(i,:));
    %       if lineNumberSkel(i,1)/maxNumberSkel(i,1) > thresholdSkeletonPoint
    %            skeletonIndex(i,1) = 1;  %�ǹǼܵ�Ϊ1���ǹǼܵ�Ϊ0
    %       end      
      end

      %%%�ں��㷨
    %   nonskelpoints=find(skeletonIndex==0); %�ǹǼܵ�
      needDelete=false;
      indexSkel = 1;
      deletePoint=[];
      mergepoint=[];
      mergepair=[];
      [massC,nonskel]=sort(massSkel(nonskelpoints,:),'ascend');  %������С
    %   [massC,nonskel]=sort(cost(nonskelpoints,:),'ascend');     %���������С
      if ~isempty(nonskelpoints)
          IfNoMerge=true;  %�Ƿ�δ�ں�=true
          while (IfNoMerge)
    %         [massC,nonskel]=min(massSkel(nonskelpoints,:)); %ѡ��ǹǼܵ��д��������С�ĵ���ΪCandidate,  P1
            Candidate=nonskelpoints(nonskel(indexSkel),:);
            P1=skelOne(Candidate,:);
            if isempty(P1)
                break;
            end
            P2s=find(relationSkeleton(Candidate,:)==1); %��Candidate�������ӹ�ϵ�ĹǼܵ�
            deleteindex=[];
            for i=1:size(P2s,2)
                if isempty(find(nonskelpoints==P2s(i)))
                    deleteindex=[deleteindex i];
                end
            end
            P2s(deleteindex)=[];            %��Candidate�������ӹ�ϵ�ķǹǼܵ�
                if ~isempty(P2s)
                    P2i=skelOne(P2s,:);
                    P2index=P2s(findNei(P1,P2i));       %P2������
                    p2_p1=find(deletePoint==P2index);   
                    if ~isempty(p2_p1)
    %                     break;
                        temp=P2index;
                        P2index=Candidate;
                        Candidate=temp;
                    end
                    P2=skelOne(P2index,:);         %ѡ����Candidate�������ӹ�ϵ������ǹǼܵ� P2
                    m1=massSkel(Candidate,:);       %P1���ܵ�����
                    m2=massSkel(P2index,:);     %P2���ܵ�����
                    P2=(P1 * m1 + P2 * m2)/(m1 + m2);   %   �����µĹǼܵ�λ��
                    skelOne(P2index,:)=P2;
                    massSkel(P2index,:)=m1+m2;  
                    deletePoint=[deletePoint;Candidate];  %ɾ����P1
                    mergepoint=[mergepoint;P2index];      %��P1��Ӧ���ںϵ�P2
                    mergepair=[mergepair;Candidate P2index]; %�ںϵĹǼܵ��
                    needDelete=true;
                end
                indexSkel = indexSkel + 1;
                if indexSkel > size(nonskel, 1)
                    IfNoMerge=false;
                end
          end
      end

    deletePoint=unique(deletePoint);
     if needDelete

         for k=1:size(deletePoint)
              m = deletePoint(k);
              t1 = OT(m,:);%m���Ӧ�Ĵ���ƻ�
              X = find(t1>0);%���д��䵽�Ǽܵ�m����������0�Ĳ����㼯X 
              for i =1 : length(X)
                  tt = find(OT(:,X(i)) == max(OT(:,X(i))));
                  if tt(1) == m
                      [B,IX] = sort(OT(:,i),'descend');
                      if IX(1) == m
                        OT(IX(2),X(i)) = OT(IX(2),X(i)) + OT(m,X(i));
                      else
                          OT(IX(1),X(i)) = OT(IX(1),X(i)) + OT(m,X(i));
                      end
                  else
                      OT(tt,X(i)) = OT(tt,X(i))+ OT(m,X(i));
                  end
              end
         end
            m=deletePoint;
            OT(m,:) = [];
            OTTwo = OT;
            massSkel(m,:) = [];
            skelOne(m,:)=[];
            skelTwo = skelOne;
            for i=1:size(OT,1)
                massSkel(i,1) = sum(OT(i,:));
            end   
            sumMassSkel = sum(massSkel);
            for i=1:size(OT,1)
                massSkel(i,:) = massSkel(i,:)/sumMassSkel;
            end 

     else
            OTTwo = OT;
            skelTwo = skelOne;
            for i=1:size(OT,1)
                massSkel(i,1) = sum(OT(i,:));
            end   
            sumMassSkel = sum(massSkel);
            for i=1:size(OT,1)
                massSkel(i,:) = massSkel(i,:)/sumMassSkel;
            end 

     end
     skel=skelTwo;
     OT=OTTwo;
     mass_s=massSkel;
     lianjie = showSkel(Datapoints,skel,OT);
end
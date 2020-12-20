% ����Ŀǰ��ʵ�����Ļ���˼��Ӧ��û���⣬������Ƚ�����������Ҫ��һ���Ľ���
% 1. Ŀǰ�ڹǼܵ��ں��У�ÿ��ֻ�ں�һ���㣬������Ҫһ���ںϺܶ�㣺
%    ���ڵ�˼·��ÿ�����������������ĵ�����ں�
%     ��Ϊ�Ǽܵ���������С�ĵ� �����㣩��������������ӹ�ϵ�Ҿ�����������ķǹǼܵ�
%    
%    ���ٵ�˼·��
%    ��ԭ��˼·�Ļ����ϣ���������ֻ�ҵ�����������ںϣ�����һֱ����ȥ�����ҵ���һ�Ե��Ժ󣬼���Ѱ��ʣ����У�������С�Ĳ�Ϊ�Ǽܵ�ĵ㣨���㣩��
%     ��ͬʱѰ�������ںϵĵ㣬����һֱѭ����ȥ��ֱ������������ԣ�
%    ÿһ�԰���ԭ���ķ��������ںϣ���
% 
% 2. Ŀǰ�ķ������У�ÿ���ں����Ժ󣬶�Ҫ���³�ʼ������ƻ�����Լ������Ŵ���ƻ��Ƿǳ���ʱ�ģ������޸�˼·���£�
%     ÿ���ں����A B �����ں�Ϊ A�㣬���ڴ���ƻ��޸�Ϊ��ԭ�����д��䵽 A B����������޸�Ϊ�ںϺ�ȫ�����䵽A���޸ĺ�Ĵ���ƻ���Ϊ��һ�μ�����λ��
%     �����Ŵ���ƻ��ĳ�ʼ����ƻ���


function[skelTwo,massSkel, OTTwo,mergepair,nonskelpoints] = ImMerge(P,OT,skelOne,mass_p)
  
  
  massSkel(size(skelOne,1),1) = 0;  %�Ǽܵ�����
  maxNumberSkel(size(skelOne, 1),1 ) = 0; % ��¼���䵽�Ǽܵ�Ϊ��������Ĳ����������
  lineNumberSkel(size(skelOne, 1),1 ) = 0; % ������������Ǽܵ�Ϊ���ԵĲ���������� ���� ֻ���������
  skeletonIndex(size(skelOne,1),1) = 0; %�ǹǼܵ�Ϊ1������Ϊ0
  thresholdSkeletonPoint = 0.92; % �����д�����Ǽܵ�Ĳ������У�ÿ�������㱻��Ϊ�Ǵ��䵽�Ǽ��ϵĵ�
  relationSkeleton(size(skelOne,1),size(skelOne,1))=0;  %�Ǽܵ����ӹ�ϵ
  needDelete = false;
 % thresholdTransport = 1/size(OT,2)*0.001; %ÿ��������������ж��ٴ�����������ĵ�
  
  %%%ԭ���㷨���ж��Ƿ�Ϊ�Ǽܵ��ȷ�����ӹ�ϵ����
     for i = 1:size(OT,2)
          thresholdTransport=mass_p(i)*0.001;
          t = OT(:,i);
          len = find(t>thresholdTransport);
          mass = [];
          for j = 1 : length(len)
              mass = [mass;len(j),t(len(j))];
          end
          if length(len) <3  && length(len) > 1
              [maxValue maxValueIndex] = max(mass(:,2));
              maxCurrentIndex = len(maxValueIndex);
              maxNumberSkel(maxCurrentIndex,1) = maxNumberSkel(maxCurrentIndex,1)+1;
              lineNumberSkel(maxCurrentIndex,1) = lineNumberSkel(maxCurrentIndex,1)+1;
              if length(len) > 1
                  if len(1)== maxCurrentIndex 
                      relationSkeleton(maxCurrentIndex,len(2)) =1;
                      relationSkeleton(len(2),maxCurrentIndex) =1;
                  else
                      relationSkeleton(maxCurrentIndex,len(1)) =1;
                      relationSkeleton(len(1),maxCurrentIndex) =1;
                  end

              end
          else if length(len) >2 
              [B,IX] = sort(mass(:,2),'descend');
              maxNumberSkel(mass(IX(1),1),1) =  maxNumberSkel(mass(IX(1),1),1) +1;

              lengthSideA = 0.0;
              lengthSideB = 0.0;
              lengthSideC = 0.0;

              for k = 1 : 3
                  lengthSideC = lengthSideC + (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(3),1),k)) * (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(3),1),k));
                  lengthSideA = lengthSideA + (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(1),1),k)) * (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(1),1),k));
                  lengthSideB = lengthSideB + (skelOne(mass(IX(3),1),k) - skelOne(mass(IX(1),1),k)) * (skelOne(mass(IX(3),1),k) - skelOne(mass(IX(1),1),k));
              end

              cosAngle = (lengthSideA + lengthSideB - lengthSideC)/2/sqrt(lengthSideA)/sqrt(lengthSideB);
              if cosAngle < -0.9
                  lineNumberSkel(mass(IX(1),1),1) = lineNumberSkel(mass(IX(1),1),1)+1;
              end
              relationSkeleton(mass(IX(1),1),mass(IX(2),1)) =1;
              relationSkeleton(mass(IX(1),1),mass(IX(3),1)) =1;
              end
          end
     end
     
  M = pdist2(skelOne,P);
  Tcost=OT.*M;
  cost(size(skelOne,1),1) = 0;
  for i = 1 : size(skelOne, 1)
      massSkel(i ,1) = sum(OT(i,:));
      cost(i,1)=sum(Tcost(i,:));
      if lineNumberSkel(i,1)/maxNumberSkel(i,1) > thresholdSkeletonPoint
           skeletonIndex(i,1) = 1;  %�ǹǼܵ�Ϊ1���ǹǼܵ�Ϊ0
      end      
  end
  
  %%%�ں��㷨
  nonskelpoints=find(skeletonIndex==0); %�ǹǼܵ�
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
                    break;
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
%                 IfNoMerge=false;    %�Ƿ�δ�ں�= false
            end
            indexSkel = indexSkel + 1;
            if indexSkel > size(nonskel, 1)
                IfNoMerge=false;
            end
%             deletePoint=Candidate;  %ɾ����P1
%             needDelete=true;
%             if IfNoMerge==true;
%                  break;
%             end
      end
  end
  
   %ԭ���㷨��ɾ������㷨
 if needDelete
%      SortdeletePoint=sort(deletePoint,'ascend');
     for k=1:size(deletePoint)
          m = deletePoint(k);
%           m=SortdeletePoint(k)-(k-1);
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
end
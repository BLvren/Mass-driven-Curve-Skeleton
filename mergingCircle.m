function [ skelTwo,massSkelTwo ] = mergingCircle( skel, massSkel,nonCircle,circle ,boolCircle,boolNonCircle, OT)
% skel �Ǽܵ�λ��
% massSkel �Ǽܵ������
% nonCircle  �����ڻ���ȱʧ��
% circle ���ڻ���ȱʧ��
% skelTwo  ������ĹǼܵ�λ��
% massSkelTwo ������ĹǼܵ�����
skelTwo = skel;
massSkelTwo = massSkel;

if boolCircle
    deletePoint = circle{1}(1);
    minMass = massSkelTwo(circle{1}(1));
    for i=1:size(circle,2)           
       for j = 1 : size(circle{i},2) 
           if minMass > massSkelTwo(circle{i}(j))
               minMass = massSkelTwo(circle{i}(j));
               deletePoint = circle{i}(j);
           end           
       end
    end
    
         m = deletePoint;
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

        OT(m,:) = [];
        massSkelTwo(m,:) = [];
        skelTwo(m,:)=[];       
        for i=1:size(OT,1)
            massSkelTwo(i,1) = sum(OT(i,:));
        end   
        sumMassSkel = sum(massSkelTwo);
        for i=1:size(OT,1)
            massSkelTwo(i,:) = massSkelTwo(i,:)/sumMassSkel;
        end    
   
else
%     if boolNonCircle
%         for i=1:size(nonCircle,2)
%             tempSumMass = 0;
%             for j = 1 : size(nonCircle{i},2)
%                 tempSumMass = tempSumMass + massSkelTwo(nonCircle{i}(j));
%             end
%             averageMass = tempSumMass / size(nonCircle{i},2);
%             for j = 1 : size(nonCircle{i},2)
%                 massSkelTwo(nonCircle{i}(j)) = averageMass;
%             end            
%         end
%     end
   
end

end


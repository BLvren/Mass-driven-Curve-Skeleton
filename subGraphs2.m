function [tmpA,ClassA,ClassAA,boolClassNum] = subGraphs2(A,result,classNumValue,skel)
    tmpA=zeros(size(A));
    lianjie=A;
    %����洢
    ClassAA={};ClassA=[];ClassB=[];
    %��ȡά��
    n=length(result);
    %��ȱ���
    saveNode=[1];num=0;
%     figure
%     plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
%     for i=1:size(skel,1)
%         for j=i:size(skel,1)
%             if lianjie(i,j) == 1 
%                 hold on
%                 plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0]);
%             end
%         end
%     end
    while(saveNode~=0) 
        saveNode=[];
        num=num+1;
        %��ȱ����õ���ͨ��ͼ
        [re,solute]=dfs(A,result,classNumValue);
        if re~=0       
            tmpre=re;
            ind1=tmpre(:,1);
            ind2=tmpre(:,2);
            tmpA(ind1(1),ind2(1))=1;
            tmpA(ind2(1),ind1(1))=1;
            saveNode=[saveNode,ind1(1),ind2(1)];
            ClassA=[ClassA,ind1(1),ind2(1)];
            ClassAA{num}=saveNode;
            for i=1:length(tmpre)
                                                            if i>length(ind2)
                                                                break;
                                                            end
                if length(find(ind2(i)==saveNode))==0
                    tmpA(ind1(i),ind2(i))=1;
                    tmpA(ind2(i),ind1(i))=1;
                    %��һ�������洢�ù��ڵ�
                    saveNode=[saveNode,ind2(i)];
                    ClassA=[ClassA,saveNode];
                    ClassAA{num}=saveNode;
                end
            end
            %�жϵ������Ƿ�����
            for i=1:length(saveNode)
                for j=1:length(saveNode)
                    if A(saveNode(i),saveNode(j))==1
                        tmpA(saveNode(i),saveNode(j))=1;
                        tmpA(saveNode(j),saveNode(i))=1;
                    end
                end
            end
            %�������ù��Ľڵ�������Ϊ0
            for i=1:length(saveNode)
                result(saveNode(i))=0;
            end
        else
            saveNode=[saveNode,solute];
            ClassA=[ClassA,solute];
            ClassAA{num}=saveNode;
            result(solute)=0;
        end
        %��ͼ����
%         hold on
%         plot3(skel(saveNode,1),skel(saveNode,2),skel(saveNode,3),'.','color',[0 0 1],'MarkerSize',20);
%         NodeColor=rand(1,3);
%         for i=1:size(skel,1)
%             for j=i:size(skel,1)
%                 if tmpA(i,j) == 1 
%                     hold on
%                     plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',NodeColor,'LineWidth',2);
%                 end
%             end
%         end
    end
%����ڵ�--�����ǣ�1���������b(���Ȩֵ>=0.2)��2������Ϊ1,��ֻ��һ��������ĵ�
    %���������ж��Ƿ��������һ��(boolClassNum=0��ʾ�����࣬boolClassNum=1��ʾֻ��һ��)
    %���ҵ�a��(��ǰֵ==1)�ڵ�
    ClassA=unique(ClassA);
    boolClassNum=0;
    if length(ClassA)==length(result) || length(ClassA)==0
        boolClassNum=1;
    end
    
    ClassANum=length(ClassA);
    if ClassANum~=0
        %�������ӹ�ϵ�ҵ���a��ڵ������ӵ�b��ڵ�
        for i=1:ClassANum
            for j=1:n
                if A(ClassA(i),j)~=0 && result(j)<classNumValue && (length(find(j==ClassB))==0) && result(j)>0
                   ClassB=[ClassB,j];
                end
            end
        end
        %����b��ڵ�ȷ�����ӹ�ϵ
        %tmpA=zeros(size(tmpA));
        for i=1:length(ClassB)
            for j=1:n
                if A(ClassB(i),j)~=0 &&  result(j)==0
                %����һ��Ψһ�����ӹ�ϵ������ڵ�
                    %�ҵ�����ڵ�
                    thisNode=ClassB(i); 
                    tmpA(ClassB(i),j)=1;
                    tmpA(j,ClassB(i))=1;

%                     hold on
%                     plot3(skel(thisNode,1),skel(thisNode,2),skel(thisNode,3),'.','color',[0 1 0],'MarkerSize',20);
%                     NodeColor1=rand(1,3);
%                     for s1=1:size(skel,1)
%                         for s2=s1:size(skel,1)
%                              if tmpA(s1,s2) == 1 
%                                  hold on
%                                  plot3([skel(s1,1) skel(s2,1)],[skel(s1,2) skel(s2,2)],[skel(s1,3) skel(s2,3)],'color',NodeColor1,'LineWidth',2);
%                              end
%                         end
%                     end  

                end
            end
        end  
        %����A����������ڵ㣬�������ͬһ��Ļ���������õ�����ڵ�
        %�����ͬһ���Ļ�����������������з�ͬ�����ڵ㣬�Դ�����
        %�����ֵ
        tmpClassAA={};
        for i=1:length(ClassAA)
            if length(ClassAA{i})~=0
                tmpClassAA=[tmpClassAA,ClassAA{i}];
            end
        end
        ClassAA=tmpClassAA;
        for i=1:length(ClassAA)
            addNode=[];
            for j=1:length(ClassAA{i})
                tmp=ClassAA{i}(j);
                for k=1:n
                    if tmpA(tmp,k)~=0 && result(k)<classNumValue &&result(k)>0
                        addNode=[addNode,k];
                    end
                end
            end
            ClassAA{i}=[ClassAA{i},addNode];
        end
    end
end
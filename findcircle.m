function [boolcircle,circleindex,circle,boolnocircle,nocircleindex,nocircle]= findcircle(ClassAA,skel,lianjie)
    %�һ�
lj=zeros(size(skel,1),size(skel,1));
ll=lianjie;
lip=1;
flag=1;
nocircleindex=[];
circle={};
nocircle={};
circleindex=[];
for k=1:size(ClassAA,2)
    nocircleindex=[nocircleindex k];
    for i=1:length(ClassAA{k})
        for j=1:length(ClassAA{k})
            a=ClassAA{k}(i);
            b=ClassAA{k}(j);
            if ll(a,b)==1
                lj(a,b)=1;
            end
        end
    end
    loop=[]; %��ʼ����
    for i=1:size(lianjie,1)
        lj=deletetwo(loop,lj);  %ɾ�����ж���Ϊ2�Ľڵ�ı�
        lj=deleteone(lj);   %ɾ������Ϊ1�Ľڵ�ı�
        if lj==0
            break; %�ڽӾ���Ϊ�����ʱֹͣ����
        end
        d=findd(lj);    %���ҷ���Ƚڵ�
        loop=findloop(d,lj);   %�ҳ���
        if ~isempty(loop)
            disp('�л�');
            disp(k);
        end
        disp(loop);   %������Ľڵ�
        circle{lip}=loop;
        circleindex=[circleindex k];
        lip=lip+1;
    end
end
%     if isempty(circle)
%         boolcircle=0;
%     else
%         boolcircle=1;
%     end
    boolcircle=~isempty(circle);
    for i=1:size(circleindex,2)
        x=find(nocircleindex==circleindex(i));
        nocircleindex(x)=[];
    end
    for i=1:length(nocircleindex)
        nocircle{flag}=ClassAA{nocircleindex(i)};
        flag=flag+1;
    end
    boolnocircle=~isempty(nocircle);
end
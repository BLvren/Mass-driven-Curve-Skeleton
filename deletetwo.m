%ɾ���ҵ��Ļ��ж�Ϊ2�Ľڵ�ı�
function [ lj ] = deletetwo( loop,lj )
two=[];
for i=1:length(loop)
    len=find(lj(loop(i),:)>0);
    if length(len)==2
    two=[two,loop(i)];   
    end
end
for k=1:length(two)
        lj(two(k),:)=0;
        lj(:,two(k))=0;
end
end
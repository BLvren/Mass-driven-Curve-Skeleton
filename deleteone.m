%ɾ����Ϊ1�Ľڵ�ı�
function [ lj ] = deleteone( lj )
for m=1:size(lj,1)
    for i=1:size(lj,1)
     adj=find(lj(i,:)>0);
        if length(adj)==1
            lj(i,adj)=0;
            lj(adj,i)=0;
        end
    end
end
end
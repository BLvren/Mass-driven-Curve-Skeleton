%������ȱ���
function [ loop ] = findloop( d,lj )
top=1;                  %��ջ��
stack(top)=d(1);           %����һ���ڵ���ջ
flag=1;                 %���ĳ���ڵ��Ƿ���ʹ���
re=[];                  
result=[];
loop=[];            %�ҳ��Ļ�
while top~=0            %�ж϶�ջ�Ƿ�Ϊ��
    pre_len=length(stack);    %��Ѱ��һ���ڵ�ǰ�Ķ�ջ����
    i=stack(top);             %ȡ��ջ���ڵ�
    for j=1:length(d)
       if  lj(i,d(j))==1 && ~isempty(find(flag==j,1)) %����ڵ��������ұ����ʹ�
           ind=find(stack==d(j));   %��ջ���ҵ������ʵĽڵ�����
           if ind~=top-1    %��ǰһ���ӽڵ�
            loop= stack(1,ind:length(stack));   %�γɻ�
           end
           continue;
       end
       if lj(i,d(j))==1 && isempty(find(flag==j,1))    %����ڵ���������û�з��ʹ� 
            top=top+1;                          %��չ��ջ
            stack(top)=d(j);                       %�½ڵ���ջ
%             disp(stack);
            flag=[flag j];                      %���½ڵ���б��
            re=[re;i d(j)];                        %���ߴ�����
            break;   
        end
    end    
     if lj(i,stack(top))==1
           result=stack;
     end
    if length(stack)==pre_len   %�����ջ����û�����ӣ���ڵ㿪ʼ��ջ
        stack(top)=[];
        top=top-1;
    end    
end
end
function [re,solute] = dfs(A,result,classNumValue)
    %��ȡά��
    n=length(result);
    %���������
    solute=[];
    %��ջ��
    top=1;
    %���a�������ϣ����˳�
    if length(find(result>=classNumValue))==0
        re=[];
        solute=[];
        return
    end
    %��a���һ���ڵ���ջ
    for i=1:length(result)
        if result(i)>=classNumValue
            stack(top)=find(result(i)== result);
            break;
        end
    end
    %���ĳ���ڵ��Ƿ���ʹ���
    flag=1;
    %%Ϊ���b��ڵ�����ս��
    re=[];
    %�ж϶�ջ�Ƿ�Ϊ��
    while top~=0
        %��Ѱ��һ���ڵ�ǰ�Ķ�ջ����
        pre_len=length(stack);
        %ȡ��ջ���ڵ�
        i=stack(top);
        for j=1:n
            %����ڵ���������û�з��ʹ�������ͬһ��a(ֵ>=classNumValue)
            if A(i,j)==1 && isempty(find(flag==j,1)) && result(j)>=classNumValue
                %��չ��ջ
                top=top+1;
                %�½ڵ���ջ
                stack(top)=j;
                %���½ڵ���б��
                flag=[flag j];
                %���ߴ�����
                re=[re; i j];
                break;
            end
        end
        %������ʱ
        if isempty(re)
            result(stack(top))=0;
            solute=[solute,stack(top)];
        end
        %�����ջ����û�����ӣ���ڵ㿪ʼ��ջ
        if length(stack)==pre_len
            stack(top)=[];
            top=top-1;
        end

    end
end
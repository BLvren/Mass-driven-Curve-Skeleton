function [ adj ] = showSkel( P,skel, OT )
%SHOWSKEL Summary of this function goes here
%   Detailed explanation goes here
    % P���� skel�Ǽ�
    
 %    idx = findNei(P,skel);  %nei N*1����
  %   adj = zeros(size(skel,1),size(skel,1));
  %   for i=1:size(skel,1)
   %      nei = find(idx == i);   %����
   %      p = P(nei,:);
    %     d = pdist2(p,p);    %���֮��ľ���
     %    pingjunzhi = mean(d(:));
      %   for j=1:size(skel,1)
  %           if i ~= j
  %               nei2 = find(idx == j);
  %               p2 = P(nei2,:);
  %               d = pdist2(p,p2);
  %               l = length(find(d <= pingjunzhi * 0.8));
  %               if l > 0
  %                   adj(i,j) = 1;
 %                end
 %            end
 %        end
 %    end
 connectRelationValue = 0.12;
 adj = zeros(size(skel,1),size(skel,1));
 sumMass = zeros(size(skel,1),size(skel,1));
 for i = 1:size(OT,2)
    t=OT(:,i);	%��ǰ��Ĵ���ƻ�
    [B,IX] = sort(t,'descend');
    if IX(1) < IX(2)  %�����������������Ǽܵ�
	     sumMass(IX(1),IX(2))=sumMass(IX(1),IX(2))+OT(IX(1),i)+OT(IX(2),i);
    else
         sumMass(IX(2),IX(1))=sumMass(IX(2),IX(1))+OT(IX(1),i)+OT(IX(2),i);
    end 

 end
 
 
 for i = 1 :  size(skel,1)-1
     for j = i+1:  size(skel,1)
         if sumMass(i,j) > connectRelationValue * ( sum(OT(i,:)) + sum(OT(j,:)))
             adj(i,j) = 1;
             adj(j,i) = 1;
         end
     end
 end    
 
 
 %   for j=1:size(skel,1)
  %           if i ~= j
  %               nei2 = find(idx == j);
  %               p2 = P(nei2,:);
  %               d = pdist2(p,p2);
  %               l = length(find(d <= pingjunzhi * 0.8));
  %               if l > 0
  %                   adj(i,j) = 1;
 %                end
 %            end
 %        end
 %    end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

end
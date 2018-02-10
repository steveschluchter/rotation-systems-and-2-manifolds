function [theta1,theta2] = AddEdge(X,alltvecs,i,j)
%Return theta1 = A(i,j) and theta2 = A(j,i) given data set and tangent
%vectors along with indices i,j to add the edge

        itvecs=squeeze(alltvecs(:,:,i));
        jtvecs=squeeze(alltvecs(:,:,j));
        twisted = sign(det(itvecs\jtvecs));
        x = sum((X(:,j)-X(:,i)).*(itvecs(:,1))./sqrt(sum((X(:,i)-X(:,j)).^2)));
        y = sum((X(:,j)-X(:,i)).*(itvecs(:,2))./sqrt(sum((X(:,i)-X(:,j)).^2)));
        theta1 = twisted*(atan2(x,y)+pi);
        x = sum((X(:,i)-X(:,j)).*(jtvecs(:,1))./sqrt(sum((X(:,i)-X(:,j)).^2)));
        y = sum((X(:,i)-X(:,j)).*(jtvecs(:,2))./sqrt(sum((X(:,i)-X(:,j)).^2)));  
        theta2 = twisted*(atan2(x,y)+pi);

end


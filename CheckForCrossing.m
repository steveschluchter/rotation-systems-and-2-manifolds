function [intersect,s,t,Xi] = CheckForCrossing(X,tangentvectors,i1,i2,i3,i4)
%CheckForCrossing does the (i1,i2) edge intersect the (i3,i4) edge when
%projected into the "tangentvectors" space
% t = percentage along (i1,i2) edge
% s = percentage along (i3,i4) edge
% Xi = interpolated intersection point
    
    NbhrCoord1 = sum((X(:,i1)-X(:,i2)).*(tangentvectors(:,1))./sqrt(sum((X(:,i1)-X(:,i2)).^2)));
    NbhrCoord2 = sum((X(:,i1)-X(:,i2)).*(tangentvectors(:,2))./sqrt(sum((X(:,i1)-X(:,i2)).^2)));  

    Nbhr2Coord1 = sum((X(:,i1)-X(:,i3)).*(tangentvectors(:,1))./sqrt(sum((X(:,i1)-X(:,i3)).^2)));
    Nbhr2Coord2 = sum((X(:,i1)-X(:,i3)).*(tangentvectors(:,2))./sqrt(sum((X(:,i1)-X(:,i3)).^2)));

    NbhrNbhrCoord1 = sum((X(:,i1)-X(:,i4)).*(tangentvectors(:,1))./sqrt(sum((X(:,i1)-X(:,i4)).^2)));
    NbhrNbhrCoord2 = sum((X(:,i1)-X(:,i4)).*(tangentvectors(:,2))./sqrt(sum((X(:,i1)-X(:,i4)).^2)));
    
    intersect = SegmentsIntersect([0 0],[NbhrCoord1 NbhrCoord2],[Nbhr2Coord1 Nbhr2Coord2],[NbhrNbhrCoord1 NbhrNbhrCoord2]);
   
    x1=NbhrNbhrCoord1-Nbhr2Coord1;y1=NbhrNbhrCoord2-Nbhr2Coord2;
    x2=NbhrCoord1-Nbhr2Coord1;y2=NbhrCoord2-Nbhr2Coord2;
    x3=-Nbhr2Coord1;y3=-Nbhr2Coord2;
    s=(y2*x3-y3*x2)/(y1*x3-y1*x2-y3*x1+y2*x1);

    x1=NbhrCoord1;y1=NbhrCoord2;
    x2=Nbhr2Coord1;y2=Nbhr2Coord2;
    x3=NbhrNbhrCoord1;y3=NbhrNbhrCoord2;
    t=(y2*x3-y3*x2)/(y1*x3-y1*x2-y3*x1+y2*x1);
    %x=x1*t;y=y1*t;
    
    Xi = (X(:,i1)+(X(:,i2)-X(:,i1))*t)/2 + (X(:,i3)+(X(:,i4)-X(:,i3))*s)/2;

end


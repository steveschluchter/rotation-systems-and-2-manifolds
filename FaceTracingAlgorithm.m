function [] = FaceTracingAlgorithm( RotationScheme )
%This is code that determines the Euler characteristic of a 2-complex given
%in terms of a rotation scheme enconding a 1-vertex graph embedding.

%entryVal is a row-vector that is the transpose of the RotationScheme
%column vector, which is how the rotation scheme comes to this method.
entryVal=transpose(RotationScheme);

%The corners row vector consists of corners that we will match together to
%form the facial boundaries of the embedding.
corners=zeros(1,2*length(entryVal));

faces = zeros(2*length(entryVal),2*length(entryVal)+1);

for i =0:(length(entryVal)-1)
    corners(1,2*i+1) = entryVal(i+1);
end

faceRowIndex = 0;




while (ismember([0],corners)==1)
   faceRowIndex = faceRowIndex+1;
   orientationPreservingWalk=1;%This will be used to keep track of a facial boundary walk being orientation preserving
   faceColumnIndex=1;%this will be reset for each new face
   position = find(corners==0);% find returns a horizontal list
   i=position(1,1)-1;%the nonzero edge number just to the left of zero
   firstPosition=i;%this is the keeper of the beginning corner
   faces(faceRowIndex,faceColumnIndex)=corners(1,i);
   faceColumnIndex = faceColumnIndex+1;
   i=i+1;
   corners(1,i)=1/2;
   faces(faceRowIndex,faceColumnIndex)=corners(1,i);
   
   if (i==length(corners))
       i=1;
   else i = i+1;
   end
   
   faceColumIndex=faceColumnIndex+1;
   faces(faceRowIndex,faceColumnIndex)=corners(1,i);
   if (faces(faceRowIndex,faceColumnIndex)<0)
       orientationPreservingWalk=orientationPreservingWalk*-1
   end
   
   repeatCorner = false;
   
   nextSearchVec = find(corners==corners(1,i));
   nextSearchVal =-1/2;
    if (i==nextSearchVec(1,1))
        nextSearchVal = nextSearchVec(1,2);
    else nextSearchVal=nextSearchVec(1,1);
    end
    
    
    
    if (nextSearchVal==firstPosition)
        repeatCorner = true;
    end
   
   while(faces(faceRowIndex,faceColumnIndex)~=faces(faceRowIndex,1) || orientationPreservingWalk==-1 || repeatCorner == false)
     
     x = find(corners==corners(1,i));
     if (i==x(1,1));
     i=x(1,2);
     else i=x(1,1); 
     end
       
     faceColumnIndex=faceColumnIndex+1;
   
       if orientationPreservingWalk>0
           %Rotate Clockwise and add numbers
           
           i=i+1;
           corners(1,i)=1/2;
           if i ==length(corners)
               i=1;
           else
               i=i+1;
           end
           faces(faceRowIndex,faceColumnIndex)=corners(1,i);
           
           if(faces(faceRowIndex,faceColumnIndex)<0)
               orientationPreservingWalk=orientationPreservingWalk*-1;
           end
           
           
       else
           %Rotate counterclockwise and add numbers
           if i==1
               i=length(corners);
           else i=i-1;
           end
           corners(1,i)=1/2;
           i=i-1;
           faces(faceRowIndex,faceColumnIndex)=corners(1,i);
           
           if(faces(faceRowIndex,faceColumnIndex)<0)
               orientationPreservingWalk=orientationPreservingWalk*-1;
           end
     
       end
       
    %this code block and the next will look ahead to tell if we're
    %repeating a corner that must not be repeated
    nextSearchVec = find(corners==corners(1,i));
    nextSearchVal =-1/2;
    if (i==nextSearchVec(1,1))
        nextSearchVal = nextSearchVec(1,2);
    else nextSearchVal=nextSearchVec(1,1);
    end

    
    if (nextSearchVal==firstPosition)
        repeatCorner = true;
    end   
    
   end
end

disp('The face-tracing algorithm has terminated.  Here are your results.')
disp(['Your 2-complex has one vertex (of course), ' num2str(length(entryVal)/2) ' edges, and ' num2str(faceRowIndex) ' faces.']) 

orientable = true
eulerChar = 1 - length(entryVal)/2 + faceRowIndex


for i = 1:length(entryVal)
    if entryVal(i)<0
        orientable = false
        break
    end
end

if orientable
    handles = (eulerChar-2)/-2;
    disp(['Your 2-complex is homeomorphic to an orientable surface having ' num2str(handles) ' handles.'])
else 
    crosscaps = -(eulerChar-2);
    disp(['Your 2-complex is homeomorphic to an nonorientable surface having ' num2str(crosscaps) ' crosscaps.'])
end

end


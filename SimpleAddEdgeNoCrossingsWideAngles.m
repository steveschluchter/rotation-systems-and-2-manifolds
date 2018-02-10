function [X,A,alltvecs,allbestepsilons,iflag] = SimpleAddEdgeNoCrossingsWideAngles(X,A,alltvecs,allbestepsilons,root,target)
%Return theta1 = A(i,j) and theta2 = A(j,i) given data set and tangent
%vectors along with indices i,j to add the edge

        smallestangleallowed = pi/8;
        influenceRadius = 12;

        connNodes = find(sum(abs(A),2)'~=0);
        ds = sum((X(:,connNodes) - repmat(X(:,root),1,length(connNodes))).^2);
        RootNbhrs = connNodes(ds<=influenceRadius*allbestepsilons(root));
        RootNbhrs = RootNbhrs(RootNbhrs~=root);
        RootNbhrs = RootNbhrs(RootNbhrs~=target);
        
        tangentvectors = squeeze(alltvecs(:,:,root));
        
        NN = length(RootNbhrs);
        iflag = 0;
        for i = 1:NN
            
            if (iflag == 1)
                break;
            end
            i3 = RootNbhrs(i);
            
            for j = i+1:NN
                
                if (iflag == 1)
                    break;
                end
                i4 = RootNbhrs(j);
                
                if ((A(i3,i4)~=0)||(A(i4,i3)~=0))
                    
                    [intersect,~,~,~] = CheckForCrossing(X,tangentvectors,root,target,i3,i4);

                    if (intersect)
                        iflag = 1;
                    end
                    
                end
                
            end
        end
        
        if (iflag == 0)
            [theta1,theta2] = AddEdge(X,alltvecs,root,target);
            
            angles = abs(A(root,A(root,:)~=0));
            m1 = min(abs(angles - abs(theta1)));
            mintheta1 = m1;
            
            angles = abs(A(target,A(target,:)~=0));
            m1 = min(abs(angles - abs(theta2)));
            mintheta2 = m1;
            
            if (isempty(mintheta1))
                mintheta1=2*pi;
            end
            if (isempty(mintheta2))
                mintheta2=2*pi;
            end
            
            if ((mintheta1>=smallestangleallowed).*(mintheta2>=smallestangleallowed))
                A(root,target) = theta1;
                A(target,root) = theta2;
            else
                iflag = 1;
            end
        end

end


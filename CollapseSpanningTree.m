function [E,visited,A] = CollapseSpanningTree(A,currentNode,visited,prevtwist,E,sourceNode)
% Given a connectivity matrix A containing +/-theta where the angles theta
% order the edges and +/- indicates untwisted/twisted, collapse a spanning
% tree to form an ordered list of edges E (rotation scheme)

N=size(A,1);

if (nargin<2)
    currentNode = 1;
    visited = zeros(N,1);
    visited(1)=1;
    prevtwist=1;
    E = [];  
    targets = find(A(currentNode,:)~=0);
    [~,order] = sort(abs(A(currentNode,targets)));
    targets = targets(order);
    
else
    
    targets = find(A(currentNode,:)~=0);
    A(currentNode,targets) = prevtwist*A(currentNode,targets);
    A(targets,currentNode) = prevtwist*A(targets,currentNode);
    if (prevtwist<0)
        [~,order] = sort(abs(A(currentNode,targets)),'descend');
    else
        [~,order] = sort(abs(A(currentNode,targets)));
    end
    targets = targets(order);
    %%% start to the `left' of the source edge
    targets = circshift(targets,-find(targets==sourceNode),2);
    %%% don't return along the source edge
    targets = targets(1:end-1);
    
end

for i = 1:length(targets)
    
    target = targets(i);
    twisted = sign(A(currentNode,target));
    
    if (visited(target) == 0)
        
        visited(target)=sum(visited~=0)+1;
        
        [E,visited,A] = CollapseSpanningTree(A,target,visited,sign(twisted),E,currentNode);
        
    else
        %%% Create a unique label N(i-1)+j for the (i,j) edge and add to
        %%% the rotation scheme
        edgeLabel = (N*(min(currentNode,target)-1)+max(currentNode,target));
        %E = [E;sign(pushedtwist*up)*edgeLabel];
        if (edgeLabel==0)
            keyboard;
        end
        E = [E;edgeLabel];
        %E(abs(E)==edgeLabel)=sign(twisted*prevtwist)*edgeLabel;
        
    end
    
end


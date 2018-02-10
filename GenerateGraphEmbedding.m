function [A,nodes,reps,alltvecs,allbestepsilons] = GenerateGraphEmbedding(X,A,nodes,reps,root,alltvecs,allbestepsilons)
%%% X       d-by-N data set of N points in R^d which lie on submanifold M
%%%         (this is the only input to the function, the others are only
%%%         used for recursive call).
%%% A       sparse N-by-N connectivity matrix of the graph - the entries in
%%%         this matrix are numbers between -2pi and 2pi.  The absolute
%%%         value represents the angle of the edge relative to the tangent
%%%         vectors stored in alltvecs.  If the entry is negative that
%%%         indicates that the edge is `twisted', meaning that the
%%%         orientations of the source and target tangent vectors are
%%%         flipped.
%%% nodes   N-by-1 vector of zeros and ones indicated which data points are
%%%          nodes in the graph
%%% reps    N-by-1 vector containing the index of the representative of
%%%          non-node data points
%%% alltvec d-by-2-by-N tensor storing the two d-dimensional tangent
%%%         vectors of each of representative data points.

[d,N] = size(X);

if (nargin < 6)     alltvecs = zeros(d,2,N);            end
if (nargin < 5)     root = ceil(rand*N);                end
if (nargin < 4)     reps = zeros(N,1);                  end
if (nargin < 3)     nodes = zeros(N,1);                 end
if (nargin < 2)     A = sparse([],[],[],N,N,N);         end

while (sum(nodes)<N)
    
    nodes(root)=1;      %%% root is now a node in the graph
    reps(root)=root;    %%% root is his own representative

    x = X(:,root);

    %%% find the tangent space at x, 'ds' is the squared distances to all
    %%% points from x
    [tangentvectors,~,~,~,bestepsilon,ds] = findTangentSpaceSurfaceFast(X,x);
    
    alltvecs(:,:,root) = tangentvectors;
    allbestepsilons(root) = bestepsilon;
    
    %bestepsilon = 2*bestepsilon;
    
    %%% set all the points within the epsilon ball to visited
    nodes(ds<bestepsilon)=1;

    %%% any points within the epsilon ball that do not have a representative
    %%% graph point are now represented by the current 'root' point
    reps((ds'<bestepsilon)&(reps==0))=root;

    %%% look for points beyond epsilon but less than 4*epsilon
    
    validinds = find((ds>=bestepsilon)&(ds<=4*bestepsilon));  
    
    %%% compute the dot product of each data vector originating from root
    %%% agains the current tangent vector
    dotprods = zeros(size(tangentvectors,2),length(validinds));
    for i = 1:size(tangentvectors,2)
        dotprods(i,:) = sum((X(:,validinds)-repmat(x,1,length(validinds))).*repmat(tangentvectors(:,i),1,length(validinds)))./sqrt(ds(validinds));
    end
    
    
    for i = 1:size(tangentvectors,2)
        
        %%% find the valid point closest to the tangent direction
        [~,ind1] = min(abs(dotprods(i,:)-1));
        ind = validinds(ind1); %%% get the data index
        
        if (nodes(ind) == 0) %%% if the node at 'ind' is not covered
            %%% Recursively add the node at 'ind' to the graph
            [A,nodes,reps,alltvecs,allbestepsilons] = GenerateGraphEmbedding(X,A,nodes,reps,ind,alltvecs,allbestepsilons);
        end

        %%% Once the target point has been covered, draw an edge from the
        %%% root to its representative
        [X,A,alltvecs,allbestepsilons] = SimpleAddEdgeNoCrossingsWideAngles(X,A,alltvecs,allbestepsilons,root,reps(ind));

        %%% find the valid point closest to the negative tangent direction
        [~,ind1] = min(abs(dotprods(i,:)+1));
        ind = validinds(ind1); %%% get the data index

        if (nodes(ind) == 0) %%% if the node at 'ind' is not covered
            %%% Recursively add the node at 'ind' to the graph
            [A,nodes,reps,alltvecs,allbestepsilons] = GenerateGraphEmbedding(X,A,nodes,reps,ind,alltvecs,allbestepsilons);
        end
        
        %%% Once the target point has been covered, draw an edge from the
        %%% root to its representative
        [X,A,alltvecs,allbestepsilons] = SimpleAddEdgeNoCrossingsWideAngles(X,A,alltvecs,allbestepsilons,root,reps(ind));
            

    end
    
    root = find(nodes==0,1);
    
end



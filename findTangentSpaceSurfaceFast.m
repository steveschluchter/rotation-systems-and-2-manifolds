function [tangentvectors,normalvectors,dimension,directeddims,bestepsilon,ds] = findTangentSpaceSurfaceFast(X,x)
%%% Find the tangent space at the point x (n-by-1 vector) from a data set 
%%% of N points in R^n represented by an n-by-N matrix X.

    N=size(X,2);
    n=size(X,1);

    ds = sum((X - repmat(x,1,N)).^2);

    dss = sort(ds);
    bestepsilon=dss(20);

    %%%%%%%%%% Find the singular vectors %%%%%%%%%%%%%

    weights = exp(-ds./bestepsilon/2);
    D = sum(weights);
    weights = sqrt(weights/D);
    weightedVectors = repmat(weights,n,1).*(X - repmat(x,1,N));
    [singularVectors,~] = svd(weightedVectors,'econ');

    directeddims = 0;
    dimension = 2;

    tangentvectors = singularVectors(:,1:2);
    if (size(singularVectors,2)>2)
        normalvectors = singularVectors(:,3:end);
    else
        normalvectors = 0;
    end

  
end
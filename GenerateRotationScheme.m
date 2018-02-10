function [RotationScheme,AdjMat,goodinds] = GenerateRotationScheme(A)
%GENERATEROTATIONSCHEME clean up adjacency matrix A (remove empty columns and
% dangling vertices) then collapse a spanning tree and push twists out of
% the spanning tree to generate a rotation scheme

    %%%%%%%%%%%% Remove unconnected and dangling vertices %%%%%%%%%%%%%%%

    AdjMat = A;
    AdjMat( ~any(AdjMat,2), : ) = [];  %rows
    AdjMat( :, ~any(AdjMat,1) ) = [];  %columns

    goodinds = find(any(A,2));
    danglingEdges = find(sum(AdjMat~=0,1)<=1);
    while (~isempty(danglingEdges))
        goodinds = goodinds(setdiff(1:length(goodinds),danglingEdges));
        AdjMat(danglingEdges,:)=[];
        AdjMat(:,danglingEdges)=[];
        danglingEdges = find(sum(AdjMat~=0,1)<=1);
    end
    AdjMat = full(AdjMat);




    %%%%%%%%%%%%%%%%%% Generate the rotation scheme %%%%%%%%%%%%%%%%%%%%%

    [E,visited,A] = CollapseSpanningTree(AdjMat);

    %%% find final orientations (A contains the orientations after pushing
    %%% twists out of the spanning tree, E is the unoriented rotation scheme)
    NN=size(A,1);
    for i = 1:length(E)
        label=E(i); %%% Untangle the unique label to find the edge
        source = ceil(label/NN)-1;
        target = label-NN*source;
        source = source+1;
        %%% Look up the final orientation of the edge and add it to E.
        E(i) = sign(A(source,target)+A(target,source))*E(i);
    end 

    [~,~,RotationScheme] = unique(abs(E)); %%% relabel the edges

    RotationScheme = sign(E).*RotationScheme;

end


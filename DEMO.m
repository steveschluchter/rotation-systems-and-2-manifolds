clear;clc;close all;

%%%%%%%%%%%%%%%%%% Generate data %%%%%%%%%%%%%%%%%%%%

% Deep dive rotation scheme and spanning tree collapse
% spanning tree + rotation scheme + original graph

N=5000;
noiselevel=1e-5; %%% some non-generic behavior with 0 noise!
surfaces = {'sphere','torus','mobius','rp2','kleinbottle','doubletorus'};

[data,intrinsic] = GenerateDataSet(N,surfaces{1},noiselevel);

%%%%%%%%%%%%%%%%%%%% Convert data set into a graph %%%%%%%%%%%%%%%%%%%%%

tic;
[A,nodes,reps,alltvecs,allbestepsilons] = GenerateGraphEmbedding(data);
toc;

%%%%%%%%%%%%%%%%%%%%%% Generate Rotation Scheme %%%%%%%%%%%%%%%%%%%%%%%

[RotationScheme,AdjMat,goodinds] = GenerateRotationScheme(A);

NumEdges = sum(sum(AdjMat~=0))/2; 
NumVertices = size(AdjMat,1);
NumEdgesSpanningTree = max(RotationScheme);


%%%%%%%%%%%%%%%%%% Face Tracing, Euler Characteristic %%%%%%%%%%%%%%%%%%%%%

FaceTracingAlgorithm(RotationScheme);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





allreps = unique(reps);
allreps = allreps(allreps~=0);

figure(4);
plot3(data(1,:),data(2,:),data(3,:),'.','color',[.9 .9 .9])
hold on;
plot3(data(1,goodinds),data(2,goodinds),data(3,goodinds),'.k','markersize',20);

for i = 1:size(AdjMat,1)
   for j = i+1:size(AdjMat,2)
      if (AdjMat(i,j)<0)
          line([data(1,goodinds(i)) data(1,goodinds(j))],[data(2,goodinds(i)) data(2,goodinds(j))],[data(3,goodinds(i)) data(3,goodinds(j))],'color','r');
      end
      if (AdjMat(i,j)>0)
          line([data(1,goodinds(i)) data(1,goodinds(j))],[data(2,goodinds(i)) data(2,goodinds(j))],[data(3,goodinds(i)) data(3,goodinds(j))],'color','b');
      end
   end
end







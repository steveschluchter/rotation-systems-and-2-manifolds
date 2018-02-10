# rotation-schemes-and-2-manifolds

9.Feb.2018

By: Tyrus Berry (tyrus.berry@gmail.com) and Steve Schluchter (steven.schluchter@gmail.com).

This code has been tested on Matlab 2015-2017.

An implementation of a manifold learning method that uses techniques from topological graph theory.

The code can be executed by running the "Demo.m" script.

The initial part of the DEMO.m script (shown below) generates a data set and can be easily edited.

  N=5000;
  noiselevel=13-5;
  surfaces={'sphere','torus'mobius','rp2','kleinbottle','doubletorus'};
  
The variable N can be reset to change the number of data points generated.
The variable "noiselevel" determines the standard deviation of Gaussian noise (normally distributed) added to each data point in the ambient space.  The direction of the noise is random.
The "surfaces" list includes 6 embeddings of surfaces from which we can generate data and test our algorithm.

The remaining code in DEMO.m uses the data to generate a graph embedding and a rotation scheme.  This code can be applied to data on other surfaces.

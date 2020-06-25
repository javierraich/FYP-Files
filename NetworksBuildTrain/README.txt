Files to train and build all of the different networks.

Note that you must load AlexNet (standard network included in MATLAB already) and then save the network's weights.
These weights are used to initialise the layers of all networks and are necessary for the scripts to be able to execute.

The networks take as input a datastore for training. This datastore returns 2x1 cells. 
In 1,1 the 227x227x5 (or 227x227x6 in the case of 2 RGB images) data is read. 
In 2,1 the label for this data is read.

You may use the analyzeNetwork command to view the structure of the networks that have been built.
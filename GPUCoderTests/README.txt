To run GPUCoderTest you must copy the .mat file with the trained neural network (DAGNetwork variable type).
Make sure -args also has the correct size that the network takes as input.
In the loop testing execution time, just load new rgb + optical flow matrix per iteration and test from your datastore.


Distance VS Error can be run at the end to generate 90% confidence intervals for predicted distances vs. true distances.
MakeXImgs can be run to rewrite dataset into 3 sub datasets for each window.
This increases disk space but allows faster training of networks (no resize operation needed at training time).

renameFiles is used to change all names of files to start with 00. 
This is for the datastore object in MATLAB to be able to take the correct order of files in the PC.

writeTxtFiles was simply used to have the names of the pairs of images needed for optical flow from datastore.
This was read by a python script that loaded these pairs of images into Flownet2 and PWCNet.
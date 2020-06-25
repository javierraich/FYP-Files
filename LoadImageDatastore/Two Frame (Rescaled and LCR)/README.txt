Run loadIMDSTwoFrameLCR to create datastore objects.

Then Run rescaleAndSplitDataTwoFrame with either optical flow or 2x RGB configuration. 
This transforms dataset into a form that can be read by the network (from 2 inputs to one single 5/6 channel input).
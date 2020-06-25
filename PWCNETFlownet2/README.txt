Scripts that read pair of txt files and call PWCNET and Flownet2 implementations to create all optical flow pairs.

Please refer to original implementations at:
https://github.com/NVIDIA/flownet2-pytorch

and
https://github.com/sniklaus/pytorch-pwc

These files just modify the main scripts provided in these implementations and loop them for a number of image pairs.
Also they write the optical flow as .mat files for easier reading in MATLAB.
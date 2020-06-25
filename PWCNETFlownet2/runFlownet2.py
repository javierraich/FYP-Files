import torch
import numpy as np
import argparse
from PIL import Image, ImageOps
import scipy.io
import os


from models import FlowNet2  # the path is depended on where you create this module
from utils.frame_utils import read_gen  # the path is depended on where you create this module
    

if __name__ == '__main__':
    # obtain the necessary args for construct the flownet framework
    parser = argparse.ArgumentParser()
    parser.add_argument('--fp16', action='store_true', help='Run model in pseudo-fp16 mode (fp16 storage fp32 math).')
    parser.add_argument("--rgb_max", type=float, default=255.)
    parser.add_argument("--path1", type=str)
    parser.add_argument("--path2", type=str)
    
    args = parser.parse_args()
    
    #create lists with pairs of images
    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\pastListValidateLeft.txt") as f:
        listPast = f.read().splitlines() 
    
    #print(listPresent)

    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\presentListValidateLeft.txt") as f:
        listPresent = f.read().splitlines() 
    

    # initial a Net
    net = FlowNet2(args).cuda()
    # load the state_dict
    dict = torch.load(r"C:\Users\Javier R\Downloads\FlowNet2_checkpoint.pth.tar")
    net.load_state_dict(dict["state_dict"])
    
    #Constant Values
    imHeight = 227
    imWidth = 227
    targetHeight = 256;
    targetWidth = 256;
    frameColor = (0,0,0)
    
        # save flow, I reference the code in scripts/run-flownet.py in flownet2-caffe project
    def writeFlow(name, flow):
        f = open(name, 'wb')
        f.write('PIEH'.encode('utf-8'))
        np.array([flow.shape[1], flow.shape[0]], dtype=np.int32).tofile(f)
        flow = flow.astype(np.float32)
        flow.tofile(f)
        f.flush()
        f.close()

    listLength = len(listPast)
    
    for i in range(listLength):
        print("Image " + str(i) + " out of " + str(listLength))
        #Scale image input and load it appropriately
        
        
        unscaledImage = read_gen(listPast[i])
        #pim1 = unscaledImage
        pim1 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim1[0:imHeight, 0:imWidth] = unscaledImage
        #print(type(pim1))
        #print(pim1.shape)
        
        unscaledImage = read_gen(listPresent[i])
        #pim2 = unscaledImage
        pim2 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim2[0:imHeight, 0:imWidth] = unscaledImage  
        
        images = [pim1, pim2]
        #print(type(images))
        images = np.array(images).transpose(3, 0, 1, 2)
        #print(type(images))
        #print(images.shape)
        im = torch.from_numpy(images.astype(np.float32)).unsqueeze(0).cuda()
        #print(type(im))

        # process the image pair to obtian the flow
        result = net(im).squeeze()
        
        print("Beep")
        for lh in range(1000):
            result = net(im).squeeze()
        print("Boop")
        

        data = result.data.cpu().numpy().transpose(1, 2, 0)
        writeFlow(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", data)
        
        head, tail = os.path.split(listPast[i])
        baseName = os.path.splitext(tail)[0]
        
        fullName = 'C:\\Users\\Javier R\\Desktop\\FYPFiles\\Flownet2\\CalculatedFlows\\ValidationLeft\\' + baseName + '.mat'

        with open(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", 'rb') as f:
            magic, = np.fromfile(f, np.float32, count=1)
            if 202021.25 != magic:
                print('Magic number incorrect. Invalid .flo file')
            else:
                w, h = np.fromfile(f, np.int32, count=2)
                #print(f'Reading {w} x {h} flo file')
                data = np.fromfile(f, np.float32, count=2*w*h)
                # Reshape data into 3D array (columns, rows, bands)
                data2D = np.resize(data, (w, h, 2))
                #print(data2D.shape)

                horizontalComponent = data2D[:targetWidth , :targetHeight , 0]
                verticalComponent = data2D[:targetWidth , :targetHeight , 1]

                scipy.io.savemat(fullName, {'X':horizontalComponent , 'Y':verticalComponent })
                
        #del pim1
        #del pim2
        #del images
        #del im
        
        #create lists with pairs of images
    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\pastListValidateCenter.txt") as f:
        listPast = f.read().splitlines() 
    
    #print(listPresent)

    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\presentListValidateCenter.txt") as f:
        listPresent = f.read().splitlines() 
        
    
    listLength = len(listPast)
       
    for i in range(listLength):
        print("Image " + str(i) + " out of " + str(listLength))
        #Scale image input and load it appropriately
        unscaledImage = read_gen(listPast[i])
        #pim1 = unscaledImage
        pim1 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim1[0:imHeight, 0:imWidth] = unscaledImage
        #print(type(pim1))
        #print(pim1.shape)

        unscaledImage = read_gen(listPresent[i])
        #pim2 = unscaledImage
        pim2 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim2[0:imHeight, 0:imWidth] = unscaledImage  

        images = [pim1, pim2]
        #print(type(images))
        images = np.array(images).transpose(3, 0, 1, 2)
        #print(type(images))
        #print(images.shape)
        im = torch.from_numpy(images.astype(np.float32)).unsqueeze(0).cuda()
        #print(type(im))

        # process the image pair to obtian the flow
        result = net(im).squeeze()

        data = result.data.cpu().numpy().transpose(1, 2, 0)
        writeFlow(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", data)

        head, tail = os.path.split(listPast[i])
        baseName = os.path.splitext(tail)[0]

        fullName = 'C:\\Users\\Javier R\\Desktop\\FYPFiles\\Flownet2\\CalculatedFlows\\ValidationCenter\\' + baseName + '.mat'

        with open(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", 'rb') as f:
            magic, = np.fromfile(f, np.float32, count=1)
            if 202021.25 != magic:
                print('Magic number incorrect. Invalid .flo file')
            else:
                w, h = np.fromfile(f, np.int32, count=2)
                #print(f'Reading {w} x {h} flo file')
                data = np.fromfile(f, np.float32, count=2*w*h)
                # Reshape data into 3D array (columns, rows, bands)
                data2D = np.resize(data, (w, h, 2))
                #print(data2D.shape)

                horizontalComponent = data2D[:targetWidth , :targetHeight , 0]
                verticalComponent = data2D[:targetWidth , :targetHeight , 1]

                scipy.io.savemat(fullName, {'X':horizontalComponent , 'Y':verticalComponent })
                
        #del pim1
        #del pim2
        #del images
        #del im
    
        #create lists with pairs of images
    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\pastListValidateRight.txt") as f:
        listPast = f.read().splitlines() 
    
    #print(listPresent)

    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\presentListValidateRight.txt") as f:
        listPresent = f.read().splitlines() 
        
    
    listLength = len(listPast)
       
    for i in range(listLength):
        print("Image " + str(i) + " out of " + str(listLength))
        #Scale image input and load it appropriately
        unscaledImage = read_gen(listPast[i])
        #pim1 = unscaledImage
        pim1 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim1[0:imHeight, 0:imWidth] = unscaledImage
        #print(type(pim1))
        #print(pim1.shape)
        
        unscaledImage = read_gen(listPresent[i])
        #pim2 = unscaledImage
        pim2 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim2[0:imHeight, 0:imWidth] = unscaledImage  
        
        images = [pim1, pim2]
        #print(type(images))
        images = np.array(images).transpose(3, 0, 1, 2)
        #print(type(images))
        #print(images.shape)
        im = torch.from_numpy(images.astype(np.float32)).unsqueeze(0).cuda()
        #print(type(im))

        # process the image pair to obtian the flow
        result = net(im).squeeze()

        data = result.data.cpu().numpy().transpose(1, 2, 0)
        writeFlow(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", data)
        
        head, tail = os.path.split(listPast[i])
        baseName = os.path.splitext(tail)[0]
        
        fullName = 'C:\\Users\\Javier R\\Desktop\\FYPFiles\\Flownet2\\CalculatedFlows\\ValidationRight\\' + baseName + '.mat'

        with open(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", 'rb') as f:
            magic, = np.fromfile(f, np.float32, count=1)
            if 202021.25 != magic:
                print('Magic number incorrect. Invalid .flo file')
            else:
                w, h = np.fromfile(f, np.int32, count=2)
                #print(f'Reading {w} x {h} flo file')
                data = np.fromfile(f, np.float32, count=2*w*h)
                # Reshape data into 3D array (columns, rows, bands)
                data2D = np.resize(data, (w, h, 2))
                #print(data2D.shape)

                horizontalComponent = data2D[:targetWidth , :targetHeight , 0]
                verticalComponent = data2D[:targetWidth , :targetHeight , 1]

                scipy.io.savemat(fullName, {'X':horizontalComponent , 'Y':verticalComponent })
                
        #del pim1
        #del pim2
        #del images
        #del im
        
#TRAINING

    #create lists with pairs of images
    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\pastListTrainingLeft.txt") as f:
        listPast = f.read().splitlines() 
    
    #print(listPresent)

    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\presentListTrainingLeft.txt") as f:
        listPresent = f.read().splitlines() 
    

    listLength = len(listPast)
    
    for i in range(listLength):
        print("Image " + str(i) + " out of " + str(listLength))
        #Scale image input and load it appropriately
        unscaledImage = read_gen(listPast[i])
        #pim1 = unscaledImage
        pim1 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim1[0:imHeight, 0:imWidth] = unscaledImage
        #print(type(pim1))
        #print(pim1.shape)
        
        unscaledImage = read_gen(listPresent[i])
        #pim2 = unscaledImage
        pim2 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim2[0:imHeight, 0:imWidth] = unscaledImage  
        
        images = [pim1, pim2]
        #print(type(images))
        images = np.array(images).transpose(3, 0, 1, 2)
        #print(type(images))
        #print(images.shape)
        im = torch.from_numpy(images.astype(np.float32)).unsqueeze(0).cuda()
        #print(type(im))

        # process the image pair to obtian the flow
        result = net(im).squeeze()

        data = result.data.cpu().numpy().transpose(1, 2, 0)
        writeFlow(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", data)
        
        head, tail = os.path.split(listPast[i])
        baseName = os.path.splitext(tail)[0]
        
        fullName = 'C:\\Users\\Javier R\\Desktop\\FYPFiles\\Flownet2\\CalculatedFlows\\TrainingLeft\\' + baseName + '.mat'

        with open(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", 'rb') as f:
            magic, = np.fromfile(f, np.float32, count=1)
            if 202021.25 != magic:
                print('Magic number incorrect. Invalid .flo file')
            else:
                w, h = np.fromfile(f, np.int32, count=2)
                #print(f'Reading {w} x {h} flo file')
                data = np.fromfile(f, np.float32, count=2*w*h)
                # Reshape data into 3D array (columns, rows, bands)
                data2D = np.resize(data, (w, h, 2))
                #print(data2D.shape)

                horizontalComponent = data2D[:targetWidth , :targetHeight , 0]
                verticalComponent = data2D[:targetWidth , :targetHeight , 1]

                scipy.io.savemat(fullName, {'X':horizontalComponent , 'Y':verticalComponent })
                
        #del pim1
        #del pim2
        #del images
        #del im
        
        #create lists with pairs of images
    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\pastListTrainingCenter.txt") as f:
        listPast = f.read().splitlines() 
    
    #print(listPresent)

    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\presentListTrainingCenter.txt") as f:
        listPresent = f.read().splitlines() 
        
    
    listLength = len(listPast)
       
    for i in range(listLength):
        print("Image " + str(i) + " out of " + str(listLength))
        #Scale image input and load it appropriately
        unscaledImage = read_gen(listPast[i])
        #pim1 = unscaledImage
        pim1 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim1[0:imHeight, 0:imWidth] = unscaledImage
        #print(type(pim1))
        #print(pim1.shape)

        unscaledImage = read_gen(listPresent[i])
        #pim2 = unscaledImage
        pim2 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim2[0:imHeight, 0:imWidth] = unscaledImage  

        images = [pim1, pim2]
        #print(type(images))
        images = np.array(images).transpose(3, 0, 1, 2)
        #print(type(images))
        #print(images.shape)
        im = torch.from_numpy(images.astype(np.float32)).unsqueeze(0).cuda()
        #print(type(im))

        # process the image pair to obtian the flow
        result = net(im).squeeze()

        data = result.data.cpu().numpy().transpose(1, 2, 0)
        writeFlow(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", data)

        head, tail = os.path.split(listPast[i])
        baseName = os.path.splitext(tail)[0]

        fullName = 'C:\\Users\\Javier R\\Desktop\\FYPFiles\\Flownet2\\CalculatedFlows\\TrainingCenter\\' + baseName + '.mat'

        with open(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", 'rb') as f:
            magic, = np.fromfile(f, np.float32, count=1)
            if 202021.25 != magic:
                print('Magic number incorrect. Invalid .flo file')
            else:
                w, h = np.fromfile(f, np.int32, count=2)
                #print(f'Reading {w} x {h} flo file')
                data = np.fromfile(f, np.float32, count=2*w*h)
                # Reshape data into 3D array (columns, rows, bands)
                data2D = np.resize(data, (w, h, 2))
                #print(data2D.shape)

                horizontalComponent = data2D[:targetWidth , :targetHeight , 0]
                verticalComponent = data2D[:targetWidth , :targetHeight , 1]

                scipy.io.savemat(fullName, {'X':horizontalComponent , 'Y':verticalComponent })
                
        #del pim1
        #del pim2
        #del images
        #del im
    
        #create lists with pairs of images
    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\pastListTrainingRight.txt") as f:
        listPast = f.read().splitlines() 
    
    #print(listPresent)

    with open(r"C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\CreateFiles\presentListTrainingRight.txt") as f:
        listPresent = f.read().splitlines() 
        
    
    listLength = len(listPast)
       
    for i in range(listLength):
        print("Image " + str(i) + " out of " + str(listLength))
        #Scale image input and load it appropriately
        unscaledImage = read_gen(listPast[i])
        #pim1 = unscaledImage
        pim1 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim1[0:imHeight, 0:imWidth] = unscaledImage
        #print(type(pim1))
        #print(pim1.shape)
        
        unscaledImage = read_gen(listPresent[i])
        #pim2 = unscaledImage
        pim2 = np.full((targetHeight,targetWidth,3), frameColor, dtype=np.uint8)
        pim2[0:imHeight, 0:imWidth] = unscaledImage  
        
        images = [pim1, pim2]
        #print(type(images))
        images = np.array(images).transpose(3, 0, 1, 2)
        #print(type(images))
        #print(images.shape)
        im = torch.from_numpy(images.astype(np.float32)).unsqueeze(0).cuda()
        #print(type(im))

        # process the image pair to obtian the flow
        result = net(im).squeeze()

        data = result.data.cpu().numpy().transpose(1, 2, 0)
        writeFlow(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", data)
        
        head, tail = os.path.split(listPast[i])
        baseName = os.path.splitext(tail)[0]
        
        fullName = 'C:\\Users\\Javier R\\Desktop\\FYPFiles\\Flownet2\\CalculatedFlows\\TrainingRight\\' + baseName + '.mat'

        with open(r"C:\Users\Javier R\Desktop\FYPFiles\testFlo.flo", 'rb') as f:
            magic, = np.fromfile(f, np.float32, count=1)
            if 202021.25 != magic:
                print('Magic number incorrect. Invalid .flo file')
            else:
                w, h = np.fromfile(f, np.int32, count=2)
                #print(f'Reading {w} x {h} flo file')
                data = np.fromfile(f, np.float32, count=2*w*h)
                # Reshape data into 3D array (columns, rows, bands)
                data2D = np.resize(data, (w, h, 2))
                #print(data2D.shape)

                horizontalComponent = data2D[:targetWidth , :targetHeight , 0]
                verticalComponent = data2D[:targetWidth , :targetHeight , 1]

                scipy.io.savemat(fullName, {'X':horizontalComponent , 'Y':verticalComponent })
                
        #del pim1
        #del pim2
        #del images
        #del im

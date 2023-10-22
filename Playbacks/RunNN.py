import tensorflow as tf
import os
from matplotlib import pyplot as plt
import numpy as np
from tensorflow.keras.models import load_model
import sys
import logging
from PIL import ImageGrab

script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))

logging.basicConfig(filename='d:\output.txt')

print('Read serialized model')
new_model = load_model(os.path.join(script_directory,'model.h5'))

print('Start to wait NNIn.txt')

fi = open(os.path.join(script_directory,'NNFromAHK.txt'),'r')

while True:

    try:            
                         
        line = fi.readline()               

        if line != str(''):
            
            print('Detected input')

            indata  = line.split()

            winRect = [int(indata[0]), int(indata[1]), int(indata[2]), int(indata[3])]
            print(winRect)
                    
            img = ImageGrab.grab(winRect)
                    
            resize = tf.image.resize(np.array(img), (256,256))
            np.expand_dims(resize,0)

            # logging.error('Start ' + str(round(time.time() * 1000)))        
            yhat = new_model.predict(np.expand_dims(resize/255,0))        
            # logging.error('End ' + str(round(time.time() * 1000)))

            print(yhat)

            res = yhat[0]        
            ind = np.argmax(res)
                
            print('Write res to file ' + str(ind))
                        
            with open(os.path.join(script_directory,'NNFromPython.txt'), 'a') as fs:
                fs.writelines(str(ind)+'\n')                            
             
    except Exception as e:
        with open('pyout', 'w') as sys.stdout:
            print(e)
            
        
        

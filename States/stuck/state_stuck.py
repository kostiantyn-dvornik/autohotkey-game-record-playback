from PIL import ImageGrab
import pygetwindow as gw
import time
import os

import globals
import tensorflow as tf
import numpy as np
from tensorflow.keras.models import load_model

import win32api
import win32con

import math

params = {    
    "posx" : 464,
    "posy" : 149,
    "grabsize" : 512,
    "nnsize" : 128
}

prev_time = 0
prev_time_move = 0

script_directory = os.path.dirname(__file__)

model = load_model(os.path.join(script_directory, "stuck.h5"))

def on_transit_in():
    global prev_time, prev_time_move
    prev_time = time.time()
    prev_time_move = time.time()

def on_stop():
    print(os.path.basename(__file__) + " stopped")

def is_trainsitin():

    window = gw.getWindowsWithTitle('Skyrim')[0]
    winRect = [window.left+2, window.top+2, window.right-2, window.bottom-2]

    img = ImageGrab.grab(winRect)

    if 'grabsize' in params:
        crop_area = (params['posx'], params['posy'], params['posx'] + params['grabsize'], params['posy'] + params['grabsize'])
        cropped_img = img.crop(crop_area)
        #cropped_img.show()
        resize = tf.image.resize(np.array(cropped_img), (params['nnsize'], params['nnsize']))
    else:
        resize = tf.image.resize(np.array(img), (256,256))

    np.expand_dims(resize,0)

    # print('Start ' + str(round(time.time() * 1000)))        
    yhat = model.predict(np.expand_dims(resize/255,0), verbose = 0)        
    # print('End ' + str(round(time.time() * 1000)))

    # print(yhat)

    res = yhat[0]        
    ind = np.argmax(res)

    print("Stuck " + str(ind))

    return ind == 1

def on_stop():
    print(os.path.basename(__file__) + " stopped")

def start():
    on_transit_in()
           
def update():
    global prev_time, prev_time_move
            
    elapsed_time_move = time.time() - prev_time_move
    if elapsed_time_move > 0.01:        
        win32api.mouse_event(win32con.MOUSEEVENTF_MOVE, 10, int(math.sin(time.time() / 5.0) * 4 ))            
        prev_time_move = time.time()
    
    elapsed_time = time.time() - prev_time
    if elapsed_time > 2:
        prev_time = time.time()
        if not is_trainsitin(): 
            globals.CURRENT_STATE = "stuck_walk"                 
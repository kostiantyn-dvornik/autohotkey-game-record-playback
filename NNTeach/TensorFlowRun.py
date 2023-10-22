import tensorflow as tf
import os
import cv2
import sys
from matplotlib import pyplot as plt
import numpy as np
import time
from tensorflow.keras.models import load_model

print(tf.config.list_physical_devices('GPU'))

script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))
print('Read serialized model')
model = load_model(os.path.join(script_directory,'..\Playbacks\model.h5'))

img = cv2.imread(os.path.join(script_directory, 'test11.png'))

plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
plt.show()

resize = tf.image.resize(img, (256,256))
np.expand_dims(resize,0)

start_time = round(time.time() * 1000)
yhat = model.predict(np.expand_dims(resize/255,0))
end_time = round(time.time() * 1000)

print('Duration ' + str(end_time - start_time))

res = yhat[0]
ind = np.argmax(res)

print(yhat)
print(ind)

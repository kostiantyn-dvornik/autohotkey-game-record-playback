import tensorflow as tf
import os
import cv2
from matplotlib import pyplot as plt
import numpy as np
import sys

data_dir = 'data'

script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))

data = tf.keras.utils.image_dataset_from_directory(os.path.join(script_directory,'data'))

data_iterator = data.as_numpy_iterator()
batch = data_iterator.next()

fig, ax = plt.subplots(ncols=5, figsize=(20,20))
for idx, img in enumerate(batch[0][:5]):
    ax[idx].imshow(img.astype(int))
    ax[idx].title.set_text(batch[1][idx])
plt.show()

data = data.map(lambda x, y: (x/255.0, y))
scaled_iterator = data.as_numpy_iterator()
batch = scaled_iterator.next()

train_size = int(len(data)*.8)
val_size = int(len(data)*.2)+1

train = data.take(train_size)
val = data.skip(train_size).take(val_size)

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout

model = Sequential()
model.add(Conv2D(16, (3,3), 1, activation='relu', input_shape=(256,256,3)))
model.add(MaxPooling2D())

model.add(Conv2D(32, (3,3), 1, activation='relu'))
model.add(MaxPooling2D())

model.add(Conv2D(16, (3,3), 1, activation='relu'))
model.add(MaxPooling2D())

model.add(Flatten())

model.add(Dense(256,activation='relu'))
model.add(Dense(3,activation='softmax'))

model.compile('adam', loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False), metrics=['accuracy'])
print(model.summary() )

logdir=os.path.join(script_directory,'logs')
tensorboard_callback = tf.keras.callbacks.TensorBoard(log_dir=logdir)

hist = model.fit(train, epochs=30, validation_data=val, callbacks=[tensorboard_callback])

fig = plt.figure()
plt.plot(hist.history['loss'], color='teal', label='loss')
plt.plot(hist.history['val_loss'], color='orange', label='val_loss')
fig.suptitle('Loss', fontsize=20)
plt.show()

fig = plt.figure()
plt.plot(hist.history['accuracy'], color='teal', label='accuracy')
plt.plot(hist.history['val_accuracy'], color='orange', label='val_accuracy')
fig.suptitle('Accuracy', fontsize=20)
plt.legend(loc="upper left")
plt.show()

img = cv2.imread(os.path.join(script_directory,'test.png'))
resize = tf.image.resize(img, (256,256))
plt.imshow(resize.numpy().astype(int))
plt.show()

np.expand_dims(resize,0)
yhat = model.predict(np.expand_dims(resize/255,0))

res = yhat[0]
max_val = res.max()
ind = np.argmax(res)

print(yhat)
print(ind)

from tensorflow.keras.models import load_model
model.save(os.path.join(script_directory,'../Playbacks/model.h5'))

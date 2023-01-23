import tensorflow as tf

### Generate data
x_train = []
y_train = []
import numpy as np
from numpy.random import default_rng
rng = default_rng()
for i in range(30000):
    a,b,c,d = rng.uniform(size=4).tolist()
    x_train.append((a, b, c, d,))
    y_train.append((a*b+c/2,1-d,))

### Creating a dataset speeds up the network
train_dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train,)).batch(10).shuffle(buffer_size=1024)

### Neural Network
model = tf.keras.Sequential([
    tf.keras.layers.Dense(18, input_shape=(4,), activation='relu'),
    tf.keras.layers.Dense(2, activation='relu'),
])

model.compile(
    optimizer=tf.keras.optimizers.Adam(),
    loss=tf.keras.losses.MeanSquaredError(),
    metrics=[tf.keras.metrics.MeanAbsoluteError(), tf.keras.metrics.RootMeanSquaredError()])

model.fit(train_dataset, epochs=3)

### Two ways to test the network
print(model(tf.constant([ [0.25,0.25,0.25,0.25],[0.03,0.9,0.03,0.03], ])))
print(model.predict([ [0.25,0.25,0.25,0.25],[0.03,0.9,0.03,0.03], ]))

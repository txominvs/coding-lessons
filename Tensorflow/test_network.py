import tensorflow as tf

### Generate data
x_train = []
y_train = []
import numpy as np
from numpy.random import default_rng
rng = default_rng()
for i in range(10000):
    vals = rng.uniform(size=4)
    x_train.append(vals.tolist())
    y_train.append(np.argmax(vals).tolist())


### Creating a dataset speeds up the network
train_dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train,)).batch(10)

### Neural Network
model = tf.keras.Sequential([
    tf.keras.layers.Dense(15, input_shape=(4,), activation='relu'),
    tf.keras.layers.Dense(4, activation='softmax'),
])

model.compile(
    optimizer=tf.keras.optimizers.SGD(learning_rate=0.01, momentum=0.5),
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
    metrics=['acc'])

model.fit(train_dataset, epochs=1)

### Two ways to test the network
print(model(tf.constant([ [0.25,0.25,0.25,0.25],[0.03,0.9,0.03,0.03], ])))
print(model.predict([ [0.25,0.25,0.25,0.25],[0.03,0.9,0.03,0.03], ]))

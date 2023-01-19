import numpy as np
import tensorflow as tf
from tensorflow import keras

# In this tutorial, we will be training a lot of models. In order to use GPU memory cautiously,
# we will set tensorflow option to grow GPU memory allocation when required.
physical_devices = tf.config.list_physical_devices('GPU') 
if len(physical_devices)>0:
    tf.config.experimental.set_memory_growth(physical_devices[0], True)


train_dataset = tf.data.Dataset.from_tensor_slices(
    (training_images, training_labels))
train_dataset = train_dataset.map(
    lambda image, label: (float(image) / 255.0, label))
print(train_dataset.as_numpy_iterator().next()[0])
train_dataset = train_dataset.batch(batch_size=64).shuffle(500)
print(len(train_dataset.as_numpy_iterator().next()[0]))

ds_train = keras.preprocessing.image_dataset_from_directory(
    data_dir = 'data/PetImages',
    validation_split = 0.2,
    subset = 'training',
    seed = 13,
    image_size = (224,224),
    batch_size = 32
)
ds_test = keras.preprocessing.image_dataset_from_directory(
    data_dir = 'data/PetImages',
    validation_split = 0.2,
    subset = 'validation',
    seed = 13,
    image_size = (224,224),
    batch_size = 32
)

(x_train,y_train),(x_test,y_test) = keras.datasets.mnist.load_data()
x_train = x_train.astype(np.float32) / 255.0
x_test = x_test.astype(np.float32) / 255.0
y_train_onehot = keras.utils.to_categorical(y_train)
y_test_onehot = keras.utils.to_categorical(y_test)


model = keras.models.Sequential([
        keras.layers.Flatten(input_shape=(28,28)), 
        keras.layers.Dense(10,activation='softmax')])
model.summary()
print(model.layers[1].weights)
model.compile(optimizer=keras.optimizers.SGD(momentum=0.5), # or use shorthand optimizer='sgd'
              loss='categorical_crossentropy', metrics=['acc'])
hist = model.fit(x_train, y_train_onehot, validation_data=(
    x_test, y_test_onehot), epochs=3, batch_size=128)
for x in ['acc','val_acc']:
    plt.plot(hist.history[x])


model = keras.models.Sequential()
model.add(keras.layers.Flatten(input_shape=(28,28)))
model.add(keras.layers.Dense(100))     # 784 inputs, 100 outputs
model.add(keras.layers.ReLU())         # Activation Function
model.add(keras.layers.Dense(10))      # 100 inputs, 10 outputs
model.summary()
model.compile(loss=keras.losses.SparseCategoricalCrossentropy(from_logits=True),metrics=['acc'])
hist = model.fit(x_train,y_train, validation_data=(x_test,y_test), epochs=5)


class NeuralNetwork(tf.keras.Model):
    def __init__(self):
        super().__init__()
        self.sequence = tf.keras.Sequential([
            tf.keras.layers.Flatten(input_shape=(28, 28)),
            tf.keras.layers.Dense(20, activation='relu'),
            tf.keras.layers.Dense(10)
        ])

    def call(self, x: tf.Tensor) -> tf.Tensor:
        y_prime = self.sequence(x)
        return y_prime


model = NeuralNetwork()
model.build((1, 28, 28))
model.summary()


model = keras.models.Sequential([
    keras.layers.Conv2D(filters=9, kernel_size=(5,5), input_shape=(28,28,1),activation='relu'),
    keras.layers.Flatten(),
    keras.layers.Dense(10)
])
model.compile(loss=keras.losses.SparseCategoricalCrossentropy(from_logits=True),metrics=['acc'])
model.summary()


(train_dataset, test_dataset) = get_data(batch_size = 64)
model = NeuralNetwork()
model.compile(optimizer=tf.keras.optimizers.SGD(learning_rate=0.1),
              loss_fn=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])
model.fit(train_dataset, epochs=5)
(test_loss, test_accuracy) = model.evaluate(test_dataset)
model.save('outputs/model')


model = tf.keras.models.load_model('outputs/model')
predicted_vector = model.predict(X)
predicted_index = np.argmax(predicted_vector)
predicted_name = labels_map[predicted_index]
probs = tf.nn.softmax(predicted_vector.reshape((-1,)))
for i,p in enumerate(probs):
    print(f'{labels_map[i]} -> {p:.3f}')


import gzip
with gzip.open(path, 'rb') as file:
    data = np.frombuffer(file.read(), np.uint8, offset=16)
    data = data.reshape(num_items, image_size, image_size)

from PIL import Image
with Image.open(image_location) as image:
  X = np.asarray(image, dtype=np.float32).reshape((-1, 28, 28)) / 255.0

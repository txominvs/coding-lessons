import tensorflow as tf
from tensorflow import keras

(x_train,y_train),(x_test,y_test) = tf.keras.datasets.fashion_mnist.load_data()
(x_train,y_train),(x_test,y_test) = tf.keras.datasets.mnist.load_data() 
(x_train,y_train),(x_test,y_test) = tf.keras.datasets.cifar10.load_data()
ds_train = tf.keras.preprocessing.image_dataset_from_directory(
    data_dir = 'folder/',
    validation_split = 0.2,
    subset = 'training', # or = 'validation',
    seed = 13,
    image_size = (224,224),
    batch_size = 64
)

train_dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train)).map(lambda image,label: (image,label)).batch(batch_size=64).shuffle(500)
train_dataset.as_numpy_iterator().next()

model = keras.Sequential([
    keras.layers.Conv2D(filters = 6, kernel_size = 5, strides = 1, activation = 'relu', input_shape = (32,32,3)),
    keras.layers.MaxPooling2D(pool_size = 2, strides = 2),
    keras.layers.Flatten(input_shape=(28, 28)),

    keras.layers.Dense(20, activation='relu'), # 'softmax' 'sigmoid'
    keras.layers.ReLU(),

    keras.applications.VGG16(include_top=False,input_shape=(224,224,3)), # model.layers[0].trainable = False,
])

model.compile(optimizer, loss, metrics)

hist = model.fit( train_dataset,   epochs=3)
hist = model.fit( x_train,y_train, validation_data=(x_test,y_test), epochs=3, batch_size=128)
import matplotlib.pyplot as plt
for x in ['acc','val_acc','loss','val_loss']: plt.plot(hist.history[x], label=x)
plt.legend()

y_pred = model.predict(x)
scores = model.evaluate(test_x, test_y)

# Regression
# ===
keras.losses.MeanSquaredError() # loss='mse'
keras.losses.MeanAbsoluteError() # loss='mae'
# Classification
# ===
# https://towardsdatascience.com/cross-entropy-for-classification-d98e7f974451
# https://stats.stackexchange.com/a/410165/362571
# There are three kinds of classification tasks:
#     Binary classification: two exclusive classes
#     Multi-class classification: more than two exclusive classes
#     Multi-label classification: just non-exclusive classes
# Here, we can say
#     In the case of (1), you need to use binary cross entropy.
#     In the case of (2), you need to use categorical cross entropy.
#     In the case of (3), you need to use binary cross entropy.
loss='binary_crossentropy'
tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
tf.keras.losses.CategoricalCrossentropy(from_logits=True) # 'sparse_categorical_crossentropy' y_train_onehot = keras.utils.to_categorical(y_train)


keras.optimizers.SGD(learning_rate=0.01, momentum=0.5)
optimizer = 'adam'
keras.optimizers.RMSprop(learning_rate=0.003)

metrics = ['acc', 'accuracy', 'sparse_categorical_accuracy']
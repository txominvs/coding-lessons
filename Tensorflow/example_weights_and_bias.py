import tensorflow as tf
import numpy as np


###
### Create and train a Neural Network
###
x_train = []
y_train = []
from numpy.random import default_rng
rng = default_rng()
for i in range(30000):
    a,b,c,d = rng.uniform(size=4).tolist()
    x_train.append((a, b, c, d,))
    y_train.append((a*b+c/2,1-d,))
train_dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train,)).batch(10).shuffle(buffer_size=1024)
model = tf.keras.Sequential([
    tf.keras.layers.Dense(18, input_shape=(4,), activation='relu'),
    tf.keras.layers.Dense(2, activation='relu'),
])
model.compile(optimizer='adam', loss='mse', metrics=['mae', tf.keras.metrics.RootMeanSquaredError()])
model.fit(train_dataset, epochs=5)


###
### Use matrix multiplication to make predictions: Y = X*W + B
###
vector_to_predict = [0.03,0.9,0.13,0.4]

def make_prediction_using_row_vector(input_vec):
    prediction = np.asarray(input_vec) # turn input into ROW vector
    for layer in model.layers:
        weights, bias = layer.get_weights()
        weights, bias = np.asarray(weights), np.asarray(bias)

        prediction = prediction @ weights + bias
        prediction = np.maximum(0, prediction) # apply ReLU activation function

    prediction = prediction.flatten()
    return prediction

def make_prediction_using_column_vector(input_vec):
    prediction = np.asarray(input_vec).reshape((-1,1,)) # turn input into COLUMN vector
    for layer in model.layers:
        weights, bias = layer.get_weights()

        weights = np.asarray(weights)
        bias = np.asarray(bias).reshape((-1,1,)) # reshape bias as column vector

        prediction = np.transpose(weights) @ prediction + bias
        prediction = np.maximum(0, prediction) # apply activation function

    prediction = prediction.flatten()
    return prediction

print("Model predictions:", model.predict([vector_to_predict,])[0])
print("Using row vectors:", make_prediction_using_row_vector(vector_to_predict))
print("Using column vecs:", make_prediction_using_column_vector(vector_to_predict))

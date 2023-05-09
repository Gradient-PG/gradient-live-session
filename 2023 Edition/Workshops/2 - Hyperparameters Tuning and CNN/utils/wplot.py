import matplotlib.pyplot as plt
import numpy as np

def plot_data(x, y, amount):
    plt.figure(figsize=(10,10))
    
    for i in range(amount):
        plt.subplot(5,5,i+1)
        plt.xticks([])
        plt.yticks([])
        plt.grid(False)
        plt.imshow(x[i], cmap=plt.cm.binary)
        plt.xlabel(y[i])
    plt.show()


def plot_data_with_predictions(x, y, predictions, amount):
    plt.figure(figsize=(10,10))
    
    for i in range(amount):
        plt.subplot(5,5,i+1)
        plt.xticks([])
        plt.yticks([])
        plt.grid(False)
        plt.imshow(x[i], cmap=plt.cm.binary)
        plt.xlabel(str(y[i]) + f", P={np.argmax(predictions[i])}")
    plt.show()
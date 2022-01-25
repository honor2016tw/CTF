import matplotlib.pyplot as plt
from PIL import Image
import numpy as np

image = Image.open("corgi-can-fly.png")
pixels = image.load()
data = np.array(image)
extracted = (data[...,0] ^ data[...,1] ^ data[...,2]) & 0x01

plt.imshow(extracted)
plt.show()


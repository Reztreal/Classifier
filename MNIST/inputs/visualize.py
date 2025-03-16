import numpy as np
import matplotlib.pyplot as plt

# Read input.txt
with open('input.txt', 'r') as f:
    lines = f.readlines()
    assert lines[0].strip() == "784 1", "Unexpected dimensions"
    pixels = [int(line.strip()) for line in lines[1:]]

# Reshape to 28x28
image = np.array(pixels).reshape(28, 28)

# Plot and save
plt.imshow(image, cmap='gray')
plt.title("Handwritten Digit")
plt.axis('off')
plt.savefig('digit.png')  # Save to file
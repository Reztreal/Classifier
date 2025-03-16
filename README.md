# RISC-V MNIST Hand Written Digit Classifier

## Project Overview

This project implements a neural network classifier in RISC-V assembly language. The classifier is capable of processing input data through a two-layer neural network to predict categories. The implementation includes fundamental operations such as matrix multiplication, ReLU activation, and argmax functions.

## Core Components

The project consists of several key assembly files:

- **abs.s**: Implements absolute value function
- **relu.s**: Implements the ReLU activation function (max(0,x))
- **argmax.s**: Finds the index of the maximum value in an array
- **dot.s**: Computes the dot product of two vectors with stride support
- **matmul.s**: Implements matrix multiplication
- **read_matrix.s**: Reads binary matrices from files
- **write_matrix.s**: Writes matrices to binary files
- **classify.s**: Implements the neural network classification algorithm

## Classification Algorithm

The `classify` function performs the following steps:
1. Read weight matrices (m0.bin, m1.bin)
2. Read input data
3. Compute the first layer: h = ReLU(input × m0)
4. Compute the output layer: out = h × m1
5. Find the index of the maximum value in the output (class prediction)
6. Write output to a file
7. Return the predicted class

## Testing with MNIST Dataset

### Files Needed

The MNIST test uses:
- `m0.bin`: First layer weight matrix
- `m1.bin`: Second layer weight matrix
- `mnist_input0.bin`: MNIST digit image in flattened binary format

### Running the MNIST Test

#### Option 1: Using the Unit Test

Run the provided unit test to classify an MNIST digit:

```bash
cd /path/to/project
bash test.sh test_classify
```

This will:
- Process the MNIST input using the neural network
- Save the output to "../MNIST/inputs/output.bin"

### Interpreting Results

To convert the binary output to human-readable format:

```bash
python3 convert.py --to-ascii ../MNIST/inputs/output.bin output.txt
```

The output.txt file will contain:
- First line: dimensions of the output (10 1)
- Following lines: scores for each digit (0-9)

The digit with the highest score is the model's prediction. For example, if the 6th value (index 6) has the highest score, the model predicted the digit as "6".

### Example Output

```
10 1    # Matrix dimensions: 10 rows, 1 column
464     # Score for digit 0
0       # Score for digit 1
-365    # Score for digit 2
3643    # Score for digit 3
464     # Score for digit 4
0       # Score for digit 5
53629   # Score for digit 6 (highest score = prediction)
886     # Score for digit 7
-6015   # Score for digit 8
464     # Score for digit 9
```

In this example, the model predicted the input image as the digit "6".

## Experimenting with Other MNIST Images

To test with other MNIST images:
1. Place additional MNIST binary images in the `../MNIST/inputs/` directory
2. Modify the test paths or create new test methods as needed
3. Run the tests and convert the outputs as shown above

You can also update the test_classify_mnist method to use different input files and compare results.
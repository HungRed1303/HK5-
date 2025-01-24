import os
from PLResolution import * 

INPUT_DIR = 'input/'
OUTPUT_DIR = 'output/'

def main():
    inputs = os.listdir(INPUT_DIR)
    for filename in inputs:
        KB, query = PLResolutionAlgorithms.readKB(INPUT_DIR + filename)
        result, check = KB.PL_Resolution(query)
        PLResolutionAlgorithms.writeOutput(result, check, OUTPUT_DIR + 'out-' + filename)

if __name__ == "__main__":
    main()

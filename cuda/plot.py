import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

files = ['01-add', 
         '02-mul', 
         '03-matrix-add', 
         '04-matrix-vector-mul', 
         '05-scalar-mul-sum-plus-reduction', 
         '05-scalar-mul-two-reductions']
for file in files:

    data = pd.read_csv(file + '.csv', header=None, names=['arr_size', 'block_size', 'time']).sort_values(by=['block_size', 'arr_size'])
    block_size_values = np.unique(data['block_size'].to_numpy())

    plt.figure(figsize=(10, 15))

    for ind, block_size in enumerate(block_size_values):
        arr = data[data['block_size'] == block_size][['arr_size', 'time']]

        plt.subplot(len(block_size_values), 1, ind + 1)
        plt.plot(
            arr['arr_size'],
            arr['time']
        )
        plt.title(f'block_size={block_size}')
        plt.xlabel('log2(arr_size)'), plt.ylabel('time')

    plt.savefig(file + '.png')
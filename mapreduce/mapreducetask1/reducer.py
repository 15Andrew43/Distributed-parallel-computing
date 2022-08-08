#!/usr/bin/env python

import sys
from random import randint

cur_n = 0
n = randint(1, 5)

for line in sys.stdin:
    try:
        rand, id = line.strip().split('\t', 1)
    except ValueError:
        continue

    sys.stdout.write(id)
    cur_n += 1
    
    if n <= cur_n:
        sys.stdout.write('\n')
        cur_n = 0
        n = randint(1, 5)
    else:
        sys.stdout.write(',')


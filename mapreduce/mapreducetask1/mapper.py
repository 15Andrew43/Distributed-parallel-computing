#!/usr/bin/env python

import sys
from random import randint


for line in sys.stdin:
    try:
        id = line.strip()
    except ValueError as e:
        continue
    rand = randint(0, 2 ** len(id) - 1)
    sys.stdout.write(str(rand) + '\t' + id + '\n')


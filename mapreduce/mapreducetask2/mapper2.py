#!/usr/bin/env python

import sys

for line in sys.stdin:
    try:
        word, cnt = line.strip().split('\t')
    except ValueError as e:
        continue
    
    sorted_word = ''.join(sorted(list(word)))

    print "%s\t%s\t%s" % (sorted_word, word, cnt)




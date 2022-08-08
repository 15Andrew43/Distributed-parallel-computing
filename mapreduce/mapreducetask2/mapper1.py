#!/usr/bin/env python

import sys
import re

for line in sys.stdin:
    try:
        article_id, text = line.strip().split('\t', 1)
    except ValueError as e:
        continue
    words = re.split(r"[^A-Za-z\\s]+", text)
    for word in words:
        if len(word) < 3:
            continue
        print "%s\t%d" % (word, 1)



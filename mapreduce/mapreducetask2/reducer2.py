#!/usr/bin/env python

import sys

prev_sorted_word = None
sum_cnt = 0

array = []
for line in sys.stdin:
#    print(line)
    try:
        sorted_word, word, cnt = line.strip().split('\t')
#        print "%s\t%s\t%s" % (sorted_word, cnt, "kek")
#        continue
        cnt = int(cnt)
    except ValueError as e:
        continue

    if prev_sorted_word != sorted_word:
        if prev_sorted_word != None:
            array.sort(reverse=True)
            little_array = array[:5]
            str_array = list(map(lambda x: str(x[1])+':'+str(x[0]), little_array))
#            print("esccrrttvybgbygunnmnbyvtrytrc")
#            print "%s\t%d\t%s" % (prev_sorted_word, sum_cnt, ';'.join(str_array)) #';'.join(str_array)
        sum_cnt = 0
        prev_sorted_word = sorted_word
        array = []
    sum_cnt += cnt
    array.append([cnt, word])
   
if prev_sorted_word:
    array.sort(reverse=True)
    little_array = array[:5]
    str_array = list(map(lambda x: str(x[1])+':'+str(x[0]), little_array))
    print "%s\t%d\t%s" % (prev_sorted_word, sum_cnt, ';'.join(str_array))


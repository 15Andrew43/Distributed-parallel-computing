#!/bin/bash

rm 1000.txt 1000000.txt 100000000.txt

for N in 1000 1000000 100000000
do
	echo "-------------------------$N--------------------------------"
	start=$(gdate +%s%N) # %N in macos does not work => gdate
	alone=$(./alone $N)
	end=$(gdate +%s%N)
	time_alone=$(($end - $start))
	echo $time_alone >> $N.txt
	for ((p=1; p <= 4; p++))
	do
		start=$(gdate +%s%N)
		together=$(mpiexec -np $p together $N)
		end=$(gdate +%s%N)
		time_together=$(($end - $start))
		echo $time_together >> $N.txt
	done
done

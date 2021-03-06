#!/bin/bash

set -x

source ../benchmarks/bin/activate

size=29
tasks=( naive composer )
threads=( 1 2 4 8 16 )
runs=${1:-1}

for task in "${tasks[@]}"; do 
  rm -f $task.stdout $task.stderr
  git log | head -1 > $task.stderr
  git log | head -1 > $task.stdout
done

for task in "${tasks[@]}"; do 
  for i in {1..$runs}; do
    for nthreads in "${threads[@]}"; do 
      python data_cleaning.py -m $task -t $nthreads -s $size >> $task.stdout 2>> $task.stderr
    done
  done
done

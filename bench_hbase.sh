#!/bin/bash
workloads=("workloada" "workloadb" "workloadc" "workloadd" "workloade" "workloadf")
operations=("250000" "500000" "1000000" "5000000" "10000000")
repeatrun=3
records=30000000
loadthreads=40
runthreads=400
driver="hbase14"

rm -rf BenchmarkLogs
mkdir BenchmarkLogs

for work in "${workloads[@]}"
do
    #Truncate table and start over
    hbase shell ./hbase_truncate

    echo "Loading data for" "$work"
    ./bin/ycsb load $driver -P workloads/"$work" -p table=usertable -p columnfamily=family -p recordcount=$records -threads $loadthreads -s > BenchmarkLogs/"$work""_load.log"
    echo "Running tests"

    for operation in "${operations[@]}"
    do
        for r in $(seq 1 $repeatrun)
        do
            ./bin/ycsb run $driver -P workloads/"$work" -p table=usertable -p columnfamily=family -p recordcount=$records -p operationcount=$operation -threads $runthreads > BenchmarkLogs/"$work""_op_""$operation""_run_""$r"".log"
        done
    done
done


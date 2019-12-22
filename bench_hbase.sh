#!/bin/bash
workloads=("workloada" "workloadb" "workloadc" "workloadd" "workloade" "workloadf")
operations=("100000" "150000" "200000" "250000" "300000")
repeatrun=3
records=1000000000
threads=400
driver="hbase14"

rm -rf BenchmarkLogs
mkdir BenchmarkLogs

for work in "${workloads[@]}"
do
    echo "Loading data for" "$work"
    ./bin/ycsb load $driver -P workloads/"$work" -p table=usertable -p columnfamily=family -p recordcount=$records -threads $threads > BenchmarkLogs/"$work""_load.log"
    echo "Running tests"

    for operation in "${operations[@]}"
    do
        for r in $(seq 1 $repeatrun)
        do
            ./bin/ycsb run $driver -P workloads/"$work" -p table=usertable -p columnfamily=family -p recordcount=$records -p operationcount=$operation -threads $threads > BenchmarkLogs/"$work""_op_""$operation""_run_""$r"".log"
        done
    done
    #Truncate table and start over
    hbase shell ./hbase_truncate
done


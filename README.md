# hbase-cassandra-bench

HBase

create 'usertable', 'cf', {SPLITS => (1..200).map {|i| "user#{1000+i*(9999-1000)/200}"}, MAX_FILESIZE => 4*1024**3}


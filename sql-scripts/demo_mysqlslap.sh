#!/bin/bash

ALTER TABLE LargeTable ENGINE = InnoDB ROW_FORMAT = DYNAMIC;

show proccesslist;

# 单线程测试。测试做了什么。
mysqlslap -a -uroot -p123456
 
# 多线程测试。使用–concurrency来模拟并发连接。
mysqlslap -a -c 100 -uroot -p123456
 
# 迭代测试。用于需要多次执行测试得到平均值。
mysqlslap -a -i 10 -uroot -p123456
 
mysqlslap ---auto-generate-sql-add-autoincrement -a -uroot -p123456
mysqlslap -a --auto-generate-sql-load-type=read -uroot -p123456
mysqlslap -a --auto-generate-secondary-indexes=3 -uroot -p123456
mysqlslap -a --auto-generate-sql-write-number=1000 -uroot -p123456
mysqlslap --create-schema world -q "select count(*) from City" -uroot -p123456
mysqlslap -a -e innodb -uroot -p123456
mysqlslap -a --number-of-queries=10 -uroot -p123456
 
# 测试同时不同的存储引擎的性能进行对比：
mysqlslap -a --concurrency=50,100 --number-of-queries 1000 --iterations=5 --engine=myisam,innodb --debug-info -uroot -p123456
 
# 执行一次测试，分别50和100个并发，执行1000次总查询：
mysqlslap -a --concurrency=50,100 --number-of-queries 1000 --debug-info -uroot -p123456
 
# 50和100个并发分别得到一次测试结果(Benchmark)，并发数越多，执行完所有查询的时间越长。为了准确起见，可以多迭代测试几次:
mysqlslap -a --concurrency=50,100 --number-of-queries 1000 --iterations=5 --debug-info -uroot -p123456
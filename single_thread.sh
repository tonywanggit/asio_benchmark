#!/bin/sh

#set -x

killall asio_test.exe
timeout=${timeout:-5}
#bufsize=${bufsize:-16384}
nothreads=1

for bufsize in 1024 2048 4096 8192 16384 81920; do
for nosessions in 1 10 100 1000 10000; do
  echo "======================> (test1) Bufsize: $bufsize Threads: $nothreads Sessions: $nosessions"
  sleep 1
  taskset -c 1 ./asio_test.exe server 127.0.0.1 33333 $nothreads $bufsize 1 & srvpid=$!
  sleep 1
  taskset -c 2 ./asio_test.exe client 127.0.0.1 33333 $nothreads $bufsize $nosessions $timeout 1
  sleep 1
  kill -9 $srvpid
  sleep 5
done
done

for bufsize in 1024 2048 4096 8192 16384 81920; do
for nosessions in 1 10 100 1000 10000; do
  echo "======================> (test2) Bufsize: $bufsize Threads: $nothreads Sessions: $nosessions"
  sleep 1
  taskset -c 1 ./asio_test.exe server 127.0.0.1 33333 $nothreads $bufsize 2 & srvpid=$!
  sleep 1
  taskset -c 2 ./asio_test.exe client 127.0.0.1 33333 $nothreads $bufsize $nosessions $timeout 2
  sleep 1
  kill -9 $srvpid
  sleep 5
done
done

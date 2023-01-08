#!/bin/sh
bitcoin-cli stop
now=$(date +"%y%m%d")
sleep 1m
mkdir /root/snapshots/core_snapshot
cp -r /root/.bitcoin/chainstate /root/snapshots/core_snapshot/chainstate
cp /root/.bitcoin/fee_estimates.dat /root/snapshots/core_snapshot/
cp /root/.bitcoin/bitcoin.conf /root/snapshots/core_snapshot/
cp -r /root/.bitcoin/blocks /root/snapshots/core_snapshot/blocks
cp /root/.bitcoin/mempool.dat /root/snapshots/core_snapshot/
bitcoind -disablewallet --daemon
cd /root/snapshots/core_snapshot/
zip -r ../snapshot${now}.zip ./*
cd ..
rm -rf core_snapshot
sha256sum snapshot${now}.zip > snapshot${now}.txt
mv snapshot* /var/www/html/


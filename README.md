This is a private, difficulty 1, testnet-in-a-box for [Litecoin](https://litecoin.info/) - based off [freewil's testnet-box](http://github.com/freewil/bitcoin-testnet-box) for bitcoin.

Use it as follows:

Without docker :
----------------
    $ git clone -b modifyMakefile git@github.com:bajarang/litecoin-testnet-box
    $ cd litecoin-testnet-box/
    $ make start
    litecoind -datadir=1  -daemon
    Litecoin server starting
    litecoind -datadir=2  -daemon
    Litecoin server starting

This will start two nodes. You need two because otherwise the node won't
generate blocks. You now have a private testnet:

    $ make getinfo
    litecoin-cli -datadir=1  -getinfo
    {
      "version": 170100,
      "protocolversion": 70015,
      "walletversion": 169900,
      "balance": 0.00000000,
      "blocks": 1004961,
      "timeoffset": 0,
      "connections": 8,
      "proxy": "",
      "difficulty": 0.0417876053377951,
      "testnet": true,
      "keypoololdest": 1551943572,
      "keypoolsize": 1000,
      "paytxfee": 0.00000000,
      "relayfee": 0.00001000,
      "warnings": ""
    }
    litecoin-cli -datadir=2  -getinfo
    {
      "version": 170100,
      "protocolversion": 70015,
      "walletversion": 169900,
      "balance": 0.00000000,
      "blocks": 1004961,
      "timeoffset": 0,
      "connections": 8,
      "proxy": "",
      "difficulty": 0.0417876053377951,
      "testnet": true,
      "keypoololdest": 1551943572,
      "keypoolsize": 1000,
      "paytxfee": 0.00000000,
      "relayfee": 0.00001000,
      "warnings": ""
    }

To start generating blocks:

    $ make generate-true
  
To stop generating blocks:

    $ make generate-false

OR, point your mining software at the address of the test machine, port 19334 (Server 1) using the username `testnet` and the password `myAmazingRPCPassword`. With a decent GPU, you should find a new block every second or so initially. If you continue to mine, the difficulty of the network will adjust to your miner.

To get the address the mined coins will end up in, run:

    $ make getaccountaddress

That will query just the first node, as that is the one receiving the mining rewards.

<!---
# Mining with `cgminer`

    ./cgminer --scrypt -o http://127.0.0.1:19334 -O testnet:testnet --shaders 2048 --thread-concurrency 8192 -w 256 -g2 -I 13 --auto-gpu --temp-overheat 81 --gpu-vddc 1.030 --temp-cutoff 97 --gpu-fan=100 --gpu-engine 700-1000 --gpu-memclock 1500

Change `127.0.0.1` in the command to the IP of the testnet box if not running on the same server. You should see output like:

    cgminer version 3.1.0 - Started: [2013-05-05 08:08:34]
    --------------------------------------------------------------------------------
    (5s):651.3K (avg):677.5Kh/s | A:12  R:2  HW:0  U:28.1/m  WU:522.7/m
    ST: 4  SS: 0  NB: 15  LW: 0  GF: 0  RF: 0
    Connected to 127.0.0.1 diff 16 without LP as user testnet
    Block: a9e247f0ce19261a...  Diff:16  Started: [08:09:03]  Best share: 514
    --------------------------------------------------------------------------------
    [P]ool management [G]PU management [S]ettings [D]isplay options [Q]uit
    GPU 0:  62.0C 3472RPM | 611.2K/792.4Kh/s | A:15 R:2 HW:0 U: 35.16/m I:13
    --------------------------------------------------------------------------------
    
    [2013-05-05 08:08:40] Accepted 0d79ae19 Diff 18/16 BLOCK! GPU 0
    [2013-05-05 08:08:40] New block detected on network
    [2013-05-05 08:08:41] Found block for pool 0!
    [2013-05-05 08:08:41] Accepted 02d01e0c Diff 91/16 BLOCK! GPU 0
    [2013-05-05 08:08:41] Found block for pool 0!
    [2013-05-05 08:08:42] Rejected 04ebc3f4 Diff 52/16 BLOCK! GPU 0
    [2013-05-05 08:08:42] New block detected on network
    [2013-05-05 08:08:44] Found block for pool 0!
    [2013-05-05 08:08:44] Accepted 0f0c8dfe Diff 17/16 BLOCK! GPU 0
    [2013-05-05 08:08:45] New block detected on network
    [2013-05-05 08:08:47] Found block for pool 0!
    [2013-05-05 08:08:47] Accepted 0ceb555f Diff 19/16 BLOCK! GPU 0
    [2013-05-05 08:08:48] New block detected on network
    [2013-05-05 08:08:48] Found block for pool 0!
    [2013-05-05 08:08:48] Accepted 0a46fc4a Diff 24/16 BLOCK! GPU 0
    [2013-05-05 08:08:48] New block detected on network
    [2013-05-05 08:08:56] Found block for pool 0!
    [2013-05-05 08:08:56] Accepted 02303381 Diff 116/16 BLOCK! GPU 0
    [2013-05-05 08:08:57] New block detected on network
    [2013-05-05 08:08:58] Found block for pool 0!
    [2013-05-05 08:08:58] Accepted 057fa852 Diff 46/16 BLOCK! GPU 0
    [2013-05-05 08:08:58] New block detected on network
    [2013-05-05 08:09:01] Found block for pool 0!
    [2013-05-05 08:09:01] Accepted 0f094309 Diff 17/16 BLOCK! GPU 0
    [2013-05-05 08:09:02] New block detected on network
    [2013-05-05 08:09:02] Found block for pool 0!
    [2013-05-05 08:09:02] Accepted 0da16004 Diff 18/16 BLOCK! GPU 0
    [2013-05-05 08:09:03] New block detected on network
  
---> 

To stop the two nodes:
  
    $ make stop
  
To clean up any files created while running the testnet 
(and restore to the original state)

    $ make clean

Like all testnet nodes, it is listening on port 19333.
The secondary node is listening for RPC connections on port 19343 (but it will not accept connections from other P2P nodes).

When running & generating coin - remember that you'll need the coins to mature before you can use them in a transaction.

With docker :
------------

The provided dockerfile installs litecoid-core and makes docker image litecoin-testnet-box available.
Build the image using :
    $ docker build -t litecoin-testnet-box .
    $ docker ps

Create a container running two accounts 1 and 2 using :
    $ docker run -t -i -p 19334:19334 -p 19344:19344 litecoin-testnet-box



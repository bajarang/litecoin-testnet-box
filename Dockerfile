# litecoin-testnet-box docker image

# Ubuntu 14.04 LTS (Trusty Tahr)
FROM ubuntu:14.04
LABEL maintainer0="Bajarang Sutar <bajarang.sutar@gmail.com>"
      maintainer1="Vishwas Patil <ivishwas@gmail.com>"

# add bitcoind from the official PPA
# install litecoind (from PPA) and make
RUN cd home \
    && mkdir -p landcoin_project \
    && cd landcoin_project \
    && apt-get update \
    && apt-get install git -y \
    && git clone https://github.com/litecoin-project/litecoin.git \
    && cd litecoin \
    && apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 -y \
    && apt-get update \
    && apt-get install wget -y \
    && ./autogen.sh \
    && apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev -y \
    && ./contrib/install_db4.sh `pwd` \
    && export BDB_PREFIX='/home/landcoin_project/litecoin/db4' \
    && ./configure --disable-wallet --enable-hardening BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include" \
    && make \
    && make install

#RUN apt-get update && \
#        apt-get install --yes software-properties-common && \
#        add-apt-repository --yes ppa:litecoin-project/litecoin && \
#        apt-get update && \
#        apt-get install --yes litecoind make
#        apt-get update 

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# copy the testnet-box files into the image
ADD . /home/tester/litecoin-testnet-box

# make tester user own the litecoin-testnet-box
RUN chown -R tester:tester /home/tester/litecoin-testnet-box

# color PS1
RUN mv /home/tester/litecoin-testnet-box/.bashrc /home/tester/ && \
        cat /home/tester/.bashrc >> /etc/bash.bashrc

# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/litecoin-testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19334 19344
CMD ["/bin/bash"]


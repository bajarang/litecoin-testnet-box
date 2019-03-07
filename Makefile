LITECOIND=litecoind
LITECOINGUI=litecoin-qt
LITECOINCLI=litecoin-cli
S1_FLAGS=
S2_FLAGS=
S1=-datadir=1 $(S1_FLAGS)
S2=-datadir=2 $(S2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
ACCOUNT=

start:
	$(LITECOIND) $(S1) -daemon
	$(LITECOIND) $(S2) -daemon
	
generate-true:
	$(LITECOINCLI) $(S1) generate $(BLOCKS)
	
generate-false:
	$(LITECOINCLI) $(S1) generate false
	
getinfo:
	$(LITECOINCLI) $(S1) -getinfo
	$(LITECOINCLI) $(S2) -getinfo
	
getaccountaddress:
	$(LITECOINCLI) $(S1) getaccountaddress ""

stop:
	$(LITECOINCLI) $(S1) stop
	$(LITECOINCLI) $(S2) stop

clean:
	rm -rf 1/testnet*
	rm -rf 2/testnet*

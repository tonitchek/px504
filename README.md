# px504
Repository for the PX504 module "innovation project"

# DEMO1 - Linux Quick Start

## Prerequisites
- The Go Ethereum client **geth** must be installed (https://github.com/ethereum/go-ethereum)
- **npm** and **nodejs** packages must be installed

## Clone the repo
git clone https://github.com/tonitchek/px504.git  
cd px504  
git submodule update --init  
cd demo1  

## Further installation
cd explorer  
npm install

cd ../monitor/eth-netstats  
npm install  
sudo npm install -g grunt-cli  
grunt

cd ../eth-net-intelligence-api  
sudo npm install  
sudo npm install -g pm2  
cd ../..

## Launching script
### Initialize the network
Edit the **nodes.conf** file in order to configure the local private network.  
Syntax:  
\<node name\>,\<RPC port\>,\<listening port\>,\<mining flag\>  
where \<mining flag\> is 1 if the node must mine blocks and 0 (or anything else) if the node must not mine.  
./demo1.sh init

### Start the nodes
./demo1.sh start

### Stop the nodes
./demo1.sh stop

### Launch Explorer or Monitor
The network must be started before running this.  
./demo1.sh explorer  
./demo1.sh monitor  
The ./demo1.sh stop command will stop these tools.  

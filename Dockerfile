FROM puppeth/blockscout:latest

ADD genesis.json /genesis.json

ENV BLOCK_TRANSFORMER clique

RUN \
  echo 'geth --cache 512 init /genesis.json' > explorer.sh && \
  echo $'exec geth --networkid 5 --syncmode "full" --gcmode "archive" --port 30303 --bootnodes enode://573b6607cd59f241e30e4c4943fd50e99e2b6f42f9bd5ca111659d309c06741247f4f1e93843ad3e8c8c18b6e2d94c161b7ef67479b3938780a97134b618b5ce@52.56.136.200:30303 --cache=512 --rpc --rpcapi "net,web3,eth,shh,debug" --rpccorsdomain "*" --rpcvhosts "*" --ws --wsorigins "*" &' >> explorer.sh && \
  echo '/usr/local/bin/docker-entrypoint.sh postgres &' >> explorer.sh && \
  echo 'sleep 5' >> explorer.sh && \
  echo 'mix do ecto.drop --force, ecto.create, ecto.migrate' >> explorer.sh && \
  echo 'mix phx.digest' >> explorer.sh && \
  echo 'mix phx.server' >> explorer.sh

ENTRYPOINT ["/bin/sh", "explorer.sh"]

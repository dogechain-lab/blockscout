
mix phx.digest.clean
mix do deps.get, local.rebar --force, deps.compile, compile
cd apps/block_scout_web/assets; npm install && node_modules/webpack/bin/webpack.js --mode production; cd -
cd apps/explorer && npm install; cd -
mix phx.digest
cd apps/block_scout_web; mix phx.gen.cert blockscout blockscout.local; cd -



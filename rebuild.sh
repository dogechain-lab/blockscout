#!/usr/bin/env bash
set -e -x

MIX_ENV="prod"
RUSTFLAGS="-C target-feature=-crt-static"

mix phx.digest.clean
mix do deps.get, local.rebar --force, deps.compile, compile
cd apps/block_scout_web/assets; npm install && node_modules/webpack/bin/webpack.js --mode production; cd -
cd apps/explorer && npm install; cd -
mix phx.digest



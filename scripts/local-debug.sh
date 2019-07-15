#!/usr/bin/env bash

export SOURCECRED_DIRECTORY=$(pwd)/sourcecred_data
SOURCECRED_GITHUB_TOKEN=`cat secrets/token`
REPOS=`cat repositories.txt`

cd mkweights
yarn
cd ..

cat ./weights.toml | node mkweights > .weights.json

cd sourcecred
yarn install
yarn backend
for repo in $REPOS; do
	SOURCECRED_GITHUB_TOKEN=$SOURCECRED_GITHUB_TOKEN node bin/sourcecred.js load $repo --weights ../.weights.json
done

yarn start

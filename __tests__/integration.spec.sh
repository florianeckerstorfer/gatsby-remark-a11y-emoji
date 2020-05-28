#!/bin/bash

set -e

echo "Clean up previous integration test run..."
sh -c "rm -rf gatsby-integration-test"
sh -c "rm -rf ./scripts/storage"

local_registry="http://localhost:4873"

original_npm_registry_url=`npm get registry`

echo "Starting Gatsby installation..."
mkdir -p ~/.config/gatsby
echo '{ "telemetry": { "enabled": false }, "cli": { "packageManager": "npm" } }' > ~/.config/gatsby/config.json
npx gatsby new gatsby-integration-test https://github.com/gatsbyjs/gatsby-starter-blog

echo "Start local registry..."
tmp_registry_log=`mktemp`
echo "Local registry output file=$tmp_registry_log"
nohup npx verdaccio --config ./scripts/verdaccio.yaml &>$tmp_registry_log &

# Wait for `verdaccio` to boot
grep -q 'http address' <(tail -f $tmp_registry_log)

echo "Login to local registry and publish package..."
npx npm-auth-to-token -u test -p test -e test@test.com --registry $local_registry
npm --registry $local_registry publish

echo "Published package"

echo "Install 'gatsby-remark-a11y-emoji' from local registry..."
cd gatsby-integration-test
npm install gatsby-remark-a11y-emoji --registry $local_registry 

npm set registry "$original_npm_registry_url"

echo "Configure plugin and add emoji to a page..."
sed -i -e 's/gatsby-remark-smartypants/gatsby-remark-a11y-emoji/g' gatsby-config.js
echo '🎸🎤👯‍♂️' >> content/blog/hello-world/index.md

echo "Build Gatsby..."
npx gatsby build

echo "Check if Emoji was been converted..."
if grep -q guitar public/hello-world/index.html; then
  exit 1
else
  exit 0
fi

#!/bin/bash

set -e

# Clean up previous
sh -c "rm -rf gatsby-integration-test"

local_registry="http://0.0.0.0:4873"

echo "hello 1"

# start local registry
tmp_registry_log=`mktemp`
nohup verdaccio --config ./scripts/verdaccio.yaml &>$tmp_registry_log &

echo "hello 2"

# wait for `verdaccio` to boot
grep -q 'http address' <(tail -f $tmp_registry_log)

echo "hello 3"

# login so we can publish packages
npm-auth-to-token -u test -p test -e test@test.com --registry $local_registry

echo "hello 4"

# Run npm command
npm --registry $local_registry publish

echo "hello 5"

# Install Gatsby and
npx gatsby new gatsby-integration-test https://github.com/gatsbyjs/gatsby-starter-blog

echo "hello 6"

cd gatsby-integration-test

npm install gatsby-remark-a11y-emoji -r $local_registry 

echo "hello 7"

sed -i -e 's/gatsby-remark-smartypants/gatsby-remark-a11y-emoji/g' gatsby-config.js

echo "hello 8"

# Add Emoji to a Markdown page
echo '🎸🎤👯‍♂️' >> content/blog/hello-world/index.md

# Build Gatsby
npx gatsby build

echo "hello 9"

# Check if Emoji was been converted
if grep -q guitar public/hello-world/index.html; then
  exit 1
else
  exit 0
fi

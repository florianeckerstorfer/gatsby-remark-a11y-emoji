#!/bin/sh

set -e

# Clean up previous
sh -c "rm -rf gatsby-integration-test"

local_registry="http://0.0.0.0:4873"

# start local registry
tmp_registry_log=`mktemp`
sh -c "nohup verdaccio --config ./scripts/verdaccio.yaml &>$tmp_registry_log &"
# wait for `verdaccio` to boot
sh -c "grep -q 'http address' <(tail -f $tmp_registry_log)"
# login so we can publish packages
sh -c "npm-auth-to-token -u test -p test -e test@test.com --registry $local_registry"
# Run npm command
sh -c "npm --registry $local_registry publish"

# Install Gatsby and
sh -c "npx gatsby new gatsby-integration-test https://github.com/gatsbyjs/gatsby-starter-blog"
sh -c "cd gatsby-integration-test"

sh -c "npm install gatsby-remark-a11y-emoji -r $local_registry "

sh -c "sed -i -e 's/gatsby-remark-smartypants/gatsby-remark-a11y-emoji/g' gatsby-config.js"

# Add Emoji to a Markdown page
sh -c "echo '🎸🎤👯‍♂️' >> content/blog/hello-world/index.md"

# Build Gatsby
sh -c "npx gatsby build"

# Check if Emoji was been converted
if grep -q guitar public/hello-world/index.html; then
  exit 1
else
  exit 0
fi

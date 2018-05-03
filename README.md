# gatsby-remark-a11y-emoji

> Gatsby Plugin to make Emoji in Markdown accessible. Wraps Emoji in a `<span>`-Tag with `role` and `aria-labelledby` attributes.

By [Florian Eckerstorfer](https://florian.ec).

## Installation

First install the plugin with NPM or Yarn:

```
npm install --save gatsby-remark-a11y-emoji
```

Add the plugin to `gatsby-config.js`. Since `gatsby-remark-a11y-emoji` converts Remark *text* nodes into *html* nodes,
I recommend placing it at the very end of the plugins list.

```
module.exports = {
  // ...
  plugins: [
    {
      resolve: `gatsby-transformer-remark`,
      options: {
        plugins: [
          // ...
          'gatsby-remark-a11y-emoji',
        ],
      },
    },
  ],
};
```

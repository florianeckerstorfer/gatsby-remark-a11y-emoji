# gatsby-remark-a11y-emoji

> Gatsby Plugin to make Emoji in Markdown accessible. Wraps Emoji in a `<span>`-Tag with `role` and `aria-label` attributes.

By [Florian Eckerstorfer](https://florian.ec).

## Idea

Everyone loves emoji 💯🎉🔥, but if you use [eslint-plugin-jsx-a11y](https://github.com/evcohen/eslint-plugin-jsx-a11y) to check the accessibility of your JSX you probably know that Emoji need special handling to become accessible. Instead of just writing the emoji, you need to wrap it in a `span` and add `role="img"` and `aria-label` attributes.

```
Gatsby is 💯
```

will turn into

```
Gatsby is <span role="img" aria-label="hundred points">💯</span>
```

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

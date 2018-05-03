const emojiRegex = require('emoji-regex');
const gemoji = require('gemoji');
const visit = require('unist-util-visit');

function visitor(node) {
  node.value = node.value.replace(
    emojiRegex(),
    (match) => {
      node.type = 'html';
      const description = gemoji.unicode[match] ?
        gemoji.unicode[match].description :
        '';
      return `<span role="img" aria-labelledby="${description}">${match}</span>`;
    },
  );
}

module.exports = ({ markdownAST }) => {
  visit(markdownAST, 'text', visitor);

  return markdownAST;
};

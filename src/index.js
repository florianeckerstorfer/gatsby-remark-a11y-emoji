const emojiRegex = require('emoji-regex');
const gemoji = require('gemoji');
const visit = require('unist-util-visit');

function findByEmoji(needle) {
  return gemoji.find(emoji => emoji.emoji === needle);
}

function visitor(node) {
  node.value = node.value.replace(emojiRegex(), match => {
    node.type = 'html';
    const emoji = findByEmoji(match);
    const description = emoji ? emoji.description : '';
    return `<span role="img" aria-label="${description}">${match}</span>`;
  });
}

module.exports = ({ markdownAST }) => {
  visit(markdownAST, 'text', visitor);

  return markdownAST;
};

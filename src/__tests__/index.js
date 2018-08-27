const plugin = require('../index');
const Remark = require('remark');
const visit = require('unist-util-visit');

describe('gatsby-remark-a11y-emoji', () => {
  let remark;

  beforeEach(() => {
    remark = new Remark().data('settings', {
      commonmark: true,
      footnotes: true,
      pedantic: true
    });
  });

  it('test "🎸"', () => {
    const markdownAST = remark.parse('🎸');
    const result = plugin({ markdownAST });

    visit(result, 'html', node => {
      expect(node.value).toBe('<span role="img" aria-label="guitar">🎸</span>');
    });
  });

  it('test "foo 🎸 bar 🎧 qoo"', () => {
    const markdownAST = remark.parse('foo 🎸 bar 🎧 qoo');
    const result = plugin({ markdownAST });

    visit(result, 'html', node => {
      expect(node.value).toBe('foo <span role="img" aria-label="guitar">🎸</span> bar <span role="img" aria-label="headphone">🎧</span> qoo');
    });
  });

  it('test if it keeps other node', async () => {
    const markdownAST = remark.parse('foo **bar**');

    const transformed = await plugin({
      markdownAST: Object.assign({}, markdownAST)
    });

    expect(transformed).toEqual(markdownAST);
  });
});

"use strict";

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

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
    const result = plugin({
      markdownAST
    });
    visit(result, 'html', node => {
      expect(node.value).toBe('<span role="img" aria-label="guitar">🎸</span>');
    });
  });
  it('test "foo 🎸 bar 🎧 qoo"', () => {
    const markdownAST = remark.parse('foo 🎸 bar 🎧 qoo');
    const result = plugin({
      markdownAST
    });
    visit(result, 'html', node => {
      expect(node.value).toBe('foo <span role="img" aria-label="guitar">🎸</span> bar <span role="img" aria-label="headphone">🎧</span> qoo');
    });
  });
  it('test if it keeps other node', _asyncToGenerator(function* () {
    const markdownAST = remark.parse('foo **bar**');
    const transformed = yield plugin({
      markdownAST: Object.assign({}, markdownAST)
    });
    expect(transformed).toEqual(markdownAST);
  }));
});
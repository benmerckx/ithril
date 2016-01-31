# ithril

[![Build Status](https://travis-ci.org/benmerckx/ithril.svg?branch=master)](https://travis-ci.org/benmerckx/ithril)

Templates for haxe. Compiles to HTML or [Mithril](https://github.com/ciscoheat/mithril-hx) views.

Implement `ithril.Ithril` for the macros to do their work.

```haxe
function () [
  (div.class-name)
    ['Any expression can be used here']
  (div+id)
    (ul)
      (li > 'Some')
      (li > 'List items')
    (ul.another-list)
      (list => item)
        (li > item.title)
    (form)
      (input[type="text"] (value = "Text value", onfocus = focus))
      (input[type="checkbox"])
];
```

## Output

Everything gets compiled to simple objects, using [this notation](http://lhorie.github.io/mithril/optimizing-performance.html#compiling-templates) so the output can directly be used with Mithril. Use `HTMLRenderer.render` to render the output to a string.
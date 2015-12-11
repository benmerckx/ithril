package ithril.elements;

import ithril.Component;
import ithril.elements.Field;

typedef TextOptions = {
	>FieldOptions<Text, String>,
	?multiline: Bool
}

class Text extends Field<TextOptions, String> {
  function setupMirror(el, isInitialized, ctx) {
    #if js
    setHeight(el);
    if (!isInitialized) {
      js.Browser.window.addEventListener('resize', setHeight.bind(el));
      ctx.onunload = function() js.Browser.window.removeEventListener('resize', setHeight.bind(el));
		}
    #end
  }

  function setHeight(mirror) {
    var area = mirror.previousSibling;
		mirror.style.width = area.offsetWidth+'px';
		area.style.height = mirror.offsetHeight+'px';
	}

  function textarea() {
    return ithril
      (div)
        (textarea.field, forwardListeners({}), value)
        (div.mirror, {config: setupMirror}, new TrustedHTML(StringTools.htmlEscape(value).split("\n").join('<br>')+'<br>'))
    ;
  }

  function input() {
    return ithril
      (input.field, forwardListeners({value: value}))
    ;
  }

  public function view() {
    return ithril
      (div.ithril)
        [state.multiline ? textarea() : input()]
    ;
  }
}

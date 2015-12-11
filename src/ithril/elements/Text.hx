package ithril.elements;

import ithril.Component;

typedef InputEvent = {
  field: Text
}

typedef InputAttributes = {
  ?onchange: InputEvent -> Void,
  ?key: String
}

typedef TextOptions = {
	>InputAttributes,
	?multiline: Bool,
	?value: String
}

class Text extends Component<{?options: TextOptions}> {
  var value: String = '';

  public function setState(options: TextOptions) {
    //if (options.value != null) value = options.value;
    this.options = options;
  }

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
        (textarea.field, {oninput: function(e) value = e.target.value}, value)
        (div.mirror, {config: setupMirror}, new TrustedHTML(StringTools.htmlEscape(value).split("\n").join('<br>')+'<br>'))
    ;
  }

  function input() {
    return ithril
      (input.field, {oninput: function(e) value = e.target.value, value: value})
    ;
  }

  public function view() {
    return ithril
      (div.ithril)
        [options.multiline ? textarea() : input()]
    ;
  }
}

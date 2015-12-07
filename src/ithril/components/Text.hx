package ithril.components;

import ithril.Component;

typedef InputEvent = {
  field: ComponentAbstract
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
	//el.style = untyped getComputedStyle(el.previousSibling);
  }

  function textarea() {
    return ithril
      (div)
        (textarea, {oninput: function(e) value = e.target.value}, value)
        (div.mirror, {config: setupMirror}, value.split("\n").join('<br>'))
    ;
  }

  function input() {
    return ithril
      (input[type='text'], {oninput: function(e) value = e.target.value, value: value})
    ;
  }

  public function view() {
    return options.multiline ? textarea() : input();
  }
}

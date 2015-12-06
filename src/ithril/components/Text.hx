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
  ?multiline: Bool
}

class Text extends Component<{?options: TextOptions}> {
  var data: String = '';

  function textarea() {
    return ithril
      (div)
        (textarea)
        (div.mirror, {}, data)
    ;
  }

  function input() {
    return ithril
      (input[type='text'])
    ;
  }

  public function view() {
    return options.multiline ? textarea() : input();
  }
}

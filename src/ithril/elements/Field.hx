package ithril.elements;

enum FieldEventType {
  Change;
  Input;
  Focus;
  Blur;
}

typedef FieldEvent<F> = {
  type: FieldEventType,
  field: F
}

typedef FieldEventListener<F> = FieldEvent<F> -> Void;

typedef FieldOptions<F, D> = {
  ?value: D,
  ?onchange: FieldEventListener<F>,
  ?oninput: FieldEventListener<F>,
  ?onfocus: FieldEventListener<F>,
  ?onblur: FieldEventListener<F>,
  ?key: String
}

class Field<Options: FieldOptions<Dynamic, Data>, Data> extends Component<Options> {
  @:isVar public var value(get, set): Data;
  function get_value() {
    return value;
  }
  function set_value(value) {
    return this.value = value;
  }

  function forwardListeners(attrs: Dynamic) {
    attrs.onchange = function(e) {
      value = e.target.value;
      if (state.onchange != null)
        state.onchange({type: FieldEventType.Change, field: this});
    };
    attrs.oninput = function(e) {
      value = e.target.value;
      if (state.oninput != null)
        state.oninput({type: FieldEventType.Input, field: this});
    };
    attrs.onfocus = function(e) {
      if (state.onfocus != null)
        state.onfocus({type: FieldEventType.Focus, field: this});
    };
    attrs.onblur = function(e) {
      if (state.onblur != null)
        state.onblur({type: FieldEventType.Blur, field: this});
    };
    return attrs;
  }

  override public function setState(state: Options) {
    super.setState(state);
    value = state.value;
  }
}

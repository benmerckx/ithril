package ithril;

import ithril.Component;

typedef Constructible = {
  public function new():Void;
}

class ComponentCache {
  static var componentInstances: Map<String, ComponentAbstract> = new Map();
  static var componentCount: Map<String, Int> = new Map();

  static function createKey(key: String, state: Array<Dynamic>) {
    var id = '';
    if (state.length > 0 && Reflect.hasField(state[0], 'key')) {
      id = '__key__'+state[0].key;
    } else {
      var count = componentCount.exists(key) ? componentCount.get(key) : 0;
      componentCount.set(key, count+1);
      id = Std.string(count);
      #if js
      js.Browser.window.setTimeout(function()
        componentCount = new Map()
      , 0);
      #end
    }
    return key + id;
  }

  static function setProps(instance: ComponentAbstract, children: Array<VirtualElement>, state: Array<Dynamic>) {
    instance.setChildren(children);
    Reflect.callMethod(instance, untyped instance.setState, state);
  }

  @:generic
  public static function getComponent<T: Constructible>(
    key: String,
    type: Class<T>,
    children: Array<VirtualElement>,
    state: Array<Dynamic>
  ): ComponentAbstract {
    key = createKey(key, state);

    if (!componentInstances.exists(key))
      componentInstances.set(key, cast new T());

    var instance = componentInstances.get(key);
    setProps(instance, children, state);
    return instance;
  }
}

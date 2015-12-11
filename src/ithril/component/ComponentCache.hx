package ithril.component;

import ithril.Component;

typedef Constructible = {
  public function new():Void;
}

class ComponentCache {
  static var componentInstances: Map<String, Component> = new Map();
  static var componentCount: Map<String, Int> = new Map();
  static var timeout: Null<Int> = null;

  static function createKey(key: String, state: Array<Dynamic>) {
    var id = '';
    if (state.length > 0 && Reflect.hasField(state[0], 'key')) {
      id = '__key__'+state[0].key;
    } else {
      var count = componentCount.exists(key) ? componentCount.get(key) : 0;
      componentCount.set(key, count+1);
      id = Std.string(count);
      #if js
      if (timeout == null)
        timeout = js.Browser.window.setTimeout(function() {
          componentCount = new Map();
          timeout = null;
        }, 0);
      #end
    }
    return key + id;
  }

  static function setProps(instance: Component, children: Array<VirtualElement>, state: Array<Dynamic>) {
    instance.setChildren(children);
    Reflect.callMethod(instance, (cast instance).setState, state);
  }

  static function getInstance<T>(
    key: String,
    type: Class<T>,
    children: Array<VirtualElement>,
    state: Array<Dynamic>,
    create: Void -> T): T {
      key = createKey(key, state);
      if (!componentInstances.exists(key))
        componentInstances.set(key, cast create());
      var instance = componentInstances.get(key);
      setProps(instance, children, state);
      return cast instance;
  }

  @:generic
  public static function getComponent<T: Constructible>(
    key: String,
    type: Class<T>,
    children: Array<VirtualElement>,
    state: Array<Dynamic>
  ): T {
    return getInstance(key, type, children, state, function() return new T());
  }
}

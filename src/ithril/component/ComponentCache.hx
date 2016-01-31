package ithril.component;

import ithril.Component;

typedef ComponentType = {
  public function new():Void;
  //public var state(default, null): S;
}

class ComponentCache {
  static var componentInstances: Map<String, Component> = new Map();
  static var componentCount: Map<String, Int> = new Map();
  static var timeout: Null<Int> = null;

  static function createKey<S: Dynamic>(key: String, state: S) {
    var id = '';
    if (Reflect.hasField(state, 'key')) {
      id = '__key__'+Reflect.field(state, 'key');
    } else {
      var count = componentCount.exists(key) ? componentCount.get(key) : 0;
      componentCount.set(key, count+1);
      id = Std.string(count);
      #if js
      if (timeout == null) {
		timeout = js.Browser.window.requestAnimationFrame(function(_) {
		  componentCount = new Map();
          timeout = null;
		});
	  }
      #end
    }
    return key + id;
  }

  static function getInstance<T>(
    key: String,
    children: Array<VirtualElement>,
    state: Dynamic,
    create: Void -> T): T {
      key = createKey(key, state);
      if (!componentInstances.exists(key))
        componentInstances.set(key, cast create());
      var instance: T = cast componentInstances.get(key);
      //instance.setChildren(children);
      //instance.setState(state);
      return instance;
  }

  @:generic
  public static function getComponent<T: ComponentType>(
    key: String,
    type: Class<T>,
    children: Array<VirtualElement>,
    state: Dynamic
  ): T {
    return getInstance(key, children, state, function() return new T());
  }
}

package ithril;

import ithril.Component;

class ComponentCache {
  static var componentInstances: Map<String, ComponentAbstract> = new Map();
  static var componentCount: Map<String, Int> = new Map();

  public static function getComponent(
    key: String,
    type: Class<Dynamic>,
    children: Array<VirtualElement>,
    state: Array<Dynamic>
  ): ComponentAbstract {
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

    key += id;

    if (!componentInstances.exists(key))
      componentInstances.set(key, Type.createInstance(type, []));

    var instance = componentInstances.get(key);
    instance.setChildren(children);
    Reflect.callMethod(instance, untyped instance.setState, state);
    return instance;
  }
}

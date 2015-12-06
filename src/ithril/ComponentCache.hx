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

  /*
  var children: Array<Dynamic>;
  var parent: Component;
  var componentInstances: Map<String, Component>;
  var componentCount = 0;

  public function new(?parent: Component) {
    this.parent = parent;
    componentInstances = new Map();
  }

  function setChildren(children: Array<Dynamic>) {
    componentCount = 0;
    if (children.length == 1 && Std.is(children[0], Array)) {
      children = children[0];
    }
    this.children = children;
    if (Std.is(children, Array))
      for (child in children) {
        if (Std.is(child, Component)) {
          child.parent = this;
        }
      }
    return this;
  }

  function getComponent(key: String, type: Class<Dynamic>) {
    key = key+componentCount;
    componentCount++;
    if (!componentInstances.exists(key))
      componentInstances.set(key, Type.createInstance(type, [this]));
    return componentInstances.get(key);
  }
  */
}

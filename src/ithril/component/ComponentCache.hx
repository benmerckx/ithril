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
			// mark dirty
			for (component in componentInstances)
			component.dirty = true;
			timeout = js.Browser.window.requestAnimationFrame(function(_) {
				componentCount = new Map();
				timeout = null;
				for (key in componentInstances.keys()) {
					var component = componentInstances.get(key);
					if (component.dirty) {
						component.unmount();
						componentInstances.remove(key);
					}
				}
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
		create: Void -> T): T 
	{
		key = createKey(key, state);
		if (!componentInstances.exists(key)) {
			var c: Component = cast create();
			c.mount();
			componentInstances.set(key, c);
		}
		var component = componentInstances.get(key);
		component.dirty = false;
		return cast component;
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

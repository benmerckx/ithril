package ithril;

class Component implements Ithril {
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
	
	function setAttributes(attrs: Array<Dynamic>) {
		try {
			Reflect.callMethod(this, untyped this.attributes, attrs);
		} catch (e: Dynamic) {}
		return this;
	}
	
	function getComponent(key: String, type: Class<Dynamic>) {
		key = key+componentCount;
		componentCount++;
		if (!componentInstances.exists(key))
			componentInstances.set(key, Type.createInstance(type, [this]));
		return componentInstances.get(key);
	}
}
package ithril;

@:autoBuild(ithril.ComponentBuilder.build())
@:allow(ithril.ComponentCache)
class ComponentAbstract implements Ithril {
	var children: Array<VirtualElement> = [];
	var parent: ComponentAbstract = null;

	public function new() {}

	function setChildren(children: Array<VirtualElement>) {
		if (children.length == 1 && Std.is(children[0], Array)) {
			children = children[0];
		}
		this.children = children;
		if (Std.is(children, Array))
			for (child in children) {
				if (Std.is(child, ComponentAbstract)) {
					child.parent = this;
				}
			}
	}
}

@:genericBuild(ithril.ComponentBuilder.buildGeneric())
class Component<Rest> {}

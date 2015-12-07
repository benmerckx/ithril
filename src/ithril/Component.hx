package ithril;

@:autoBuild(ithril.ComponentBuilder.build())
@:allow(ithril.ComponentCache)
class ComponentAbstract implements Ithril {
	//var children: Array<VirtualElement> = [];
	//var parent: ComponentAbstract = null;

	public function new() {}

	function setChildren(children: Array<VirtualElement>) {
		if (children.length == 1 && Std.is(children[0], Array)) {
			children = children[0];
		}
		untyped this.children = children;
		if (Std.is(children, Array)) {
			children.map(function(child) {
				if (Std.is(child, ComponentAbstract)) {
					child.parent = this;
				}
			});
		}
	}

	public function asHTML(space = ''): String {
		return HTMLRenderer.render(this, space);
	}
}

@:genericBuild(ithril.ComponentBuilder.buildGeneric())
class Component<Rest> {}

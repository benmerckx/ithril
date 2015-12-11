package ithril;

@:genericBuild(ithril.component.ComponentBuilder.buildGeneric())
class Component<Rest> {}

@:autoBuild(ithril.component.ComponentBuilder.build())
@:allow(ithril.component.ComponentCache)
class ComponentAbstract<State, Child: VirtualElement> implements Ithril {
	public var state(default, null): State;
	public var stateFields: Array<String> = [];
	var children: Array<Child>;
	var parent: Component = null;

	public function new() {}

	function setChildren(children: Array<Child>) {
		if (children.length == 1 && Std.is(children[0], Array)) {
			children = untyped children[0];
		}
		this.children = children;
		if (Std.is(children, Array)) {
			children.map(function(child) {
				if (Std.is(child, ComponentAbstract)) {
					(cast child).parent = this;
				}
			});
		}
	}

	public function asHTML(space = ''): String {
		return HTMLRenderer.render(this, space);
	}
}

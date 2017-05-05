package ithril;

@:genericBuild(ithril.component.ComponentBuilder.buildGeneric())
class Component<Rest> {}

@:autoBuild(ithril.component.ComponentBuilder.build())
class ComponentAbstract<T> implements IthrilView {
	@:remove public function oninit(vnode:Vnode<T>) {}
	@:remove public function oncreate(vnode:Vnode<T>) {}
	@:remove public function onupdate(vnode:Vnode<T>) {}
	@:remove public function onbeforeremove(vnode:Vnode<T>) {}
	@:remove public function onremove(vnode:Vnode<T>) {}
	@:remove public function onbeforeupdate(vnode:Vnode<T>) {}

	@:keep public function view(vnode:Vnode<T>):Vnode<Dynamic> return null;
}

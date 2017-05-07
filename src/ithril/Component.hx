package ithril;

@:autoBuild(ithril.IthrilBuilder.buildComponent())
class Component implements IthrilView {
	@:remove public function oninit(vnode:Vnode) {}
	@:remove public function oncreate(vnode:Vnode) {}
	@:remove public function onupdate(vnode:Vnode) {}
	@:remove public function onbeforeremove(vnode:Vnode) {}
	@:remove public function onremove(vnode:Vnode) {}
	@:remove public function onbeforeupdate(vnode:Vnode) {}

	@:keep public function view(vnode:Vnode):Vnode return null;

	public function new(?vnode:Vnode) { }
}

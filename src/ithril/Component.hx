package ithril;

@:autoBuild(ithril.IthrilBuilder.buildComponent())
class Component implements IthrilView {
	public function oninit(vnode:Vnode) {}
	public function oncreate(vnode:Vnode) {}
	public function onupdate(vnode:Vnode) {}
	public function onbeforeremove(vnode:Vnode) {}
	public function onremove(vnode:Vnode) {}
	public function onbeforeupdate(vnode:Vnode) {}

	public function view(vnode:Vnode):Vnode return null;

	static var avoid = [ 'oninit', 'oncreate', 'onupdate', 'onbeforeremove', 'onremove', 'onbeforeupdate' ];

	public function new(vnode:Vnode) { }
}

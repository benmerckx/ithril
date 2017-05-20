package ithril;

@:autoBuild(ithril.Parser.buildComponent())
class Component implements View {
	public function oninit(vnode:Vnode) {}
	public function oncreate(vnode:Vnode) {}
	public function onupdate(vnode:Vnode) {}
	public function onbeforeremove(vnode:Vnode) {}
	public function onremove(vnode:Vnode) {}
	public function onbeforeupdate(vnode:Vnode) {}

	public function view(vnode:Vnode):Vnode return null;

	public function new(vnode:Vnode) { }
}

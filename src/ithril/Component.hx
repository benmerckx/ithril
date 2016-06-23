package ithril;

import haxe.DynamicAccess;
import ithril.component.ComponentCache;

@:genericBuild(ithril.component.ComponentBuilder.buildGeneric())
class Component<Rest> {}

@:autoBuild(ithril.component.ComponentBuilder.build())
@:allow(ithril.component.ComponentCache)
class ComponentAbstract<State, Child: VirtualElement> implements IthrilView {
	public var state(default, null): State;
	public var stateFields: Array<String> = [];
	var children: Array<Child>;
	var parent: Component = null;
	var dirty: Bool = false;

	public function new() {}

	public function setState(state: State) {
		this.state = state;
	}
	
	public function mount() {}
	
	public function unmount() {}

	public function setChildren(children: Array<Child>) {
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
	
	@:keep
	public static function __init__() {
		#if (!nodejs && js)
		// JS client has to be monkey patched, because mithril has no hooks
		function patch(obj, method: String, impl: Dynamic) untyped {
			var store = {}, previous = obj[method];
			Object.keys(previous).map(function(key) store[key] = previous[key]);
			obj[method] = impl.bind(__js__('this'), obj[method]);
			Object.keys(store).map(function (key) obj[method][key] = store[key]);
		}
		
		var window: DynamicAccess<Dynamic> = cast js.Browser.window,
			m: Dynamic = window.get('m'),
			redrawing = false, 
			queue = false, 
			counted = 0,
			next = window.exists('requestAnimationFrame') ? window['requestAnimationFrame'] : window['setTimeout'];
		
			patch(m, 'redraw', function(original, force) {
				if (queue) return;
				if (!redrawing) {
					ComponentCache.invalidate();
					original(force);
					redrawing = true;
					queue = false;
					next(function() {
						ComponentCache.collect();
						redrawing = false;
						if (queue) {
							next(function() {
								m.redraw();
								queue = false;
							}, 16);
						}
					}, 16);
				} else {
					queue = true;
				}
			});
		#end
	}
}

package ithril;

class Ithril {
	public static inline function redraw() untyped m.redraw();
	public static inline function mount(node, view) untyped m.mount(node, view);
	public static inline function route(root, defaultRoute, routes) untyped m.route(root, defaultRoute, routes);
	public static inline function routeLink() #if (js && !nodejs) return untyped m.route.link #else return null #end;
	public static inline function routePrefix(prefix:String) untyped m.route.prefix(prefix);
	public static inline function routeParam(?key:String) return untyped m.route.param(key);
	public static inline function routeGet() return untyped m.route.get();
}

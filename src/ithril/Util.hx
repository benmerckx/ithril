package ithril;

class Util {
	public static inline function makeVnode1(tag:Dynamic):Vnode
		return #if (js && !nodejs) untyped m(tag); #else makeVnode3(tag, null, null); #end

	public static inline function makeVnode2A(tag:Dynamic, attrs:Dynamic):Vnode
		return #if (js && !nodejs) untyped m(tag, attrs); #else makeVnode3(tag, attrs, null); #end

	public static inline function makeVnode2(tag:Dynamic, ?nodes:Dynamic):Vnode
		return #if (js && !nodejs) untyped m(tag, nodes); #else makeVnode3(tag, null, nodes); #end

	public static #if (js && !nodejs) inline #end function makeVnode3(tag:Dynamic, ?attrs:Dynamic, ?nodes:Dynamic):Vnode {
#if (js && !nodejs)
		return untyped m(tag, attrs, nodes);
#else
		var v:Vnode = { tag: tag };

		if (attrs != null) {
			v.attrs = attrs;
			if (Reflect.hasField(v.attrs, "key") && v.attrs.key != null) v.key = attrs.key;
		}

		if (nodes != null) {
			if (tag == '<')
				v.children = nodes;
			else if (Std.is(nodes, String) || Std.is(nodes, Bool) || Std.is(nodes, Int) || Std.is(nodes, Float)) {
				v.text = ithril.Attributes.attrs(nodes);
			}
			else
				v.children = nodes;
		}

		return v;
#end
	}

	public static inline function makeTrust(val:String):Vnode
		return #if (js && !nodejs) untyped m.trust(val); #else makeVnode3('<', null, val); #end
}

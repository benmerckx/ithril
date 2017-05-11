package ithril;

class Util {
	public static inline function makeVnode1(tag:Dynamic):Vnode
		return #if (js && !nodejs) untyped m(tag); #else makeVnode3(tag, null, null); #end

	public static inline function makeVnode2A(tag:Dynamic, attrs:Dynamic)
		return #if (js && !nodejs) untyped m(tag, attrs); #else makeVnode3(tag, attrs, null); #end

	public static inline function makeVnode2(tag:Dynamic, ?nodes:Dynamic):Vnode
		return #if (js && !nodejs) untyped m(tag, nodes); #else makeVnode3(tag, nodes, null); #end

	public static #if (js && !nodejs) inline #end function makeVnode3(tag:Dynamic, ?attrs:Dynamic, ?nodes:Dynamic):Vnode {
#if (js && !nodejs)
		return untyped m(tag, attrs, nodes);
#else
		var v:Vnode = { tag: tag };

		if (attrs != null && nodes == null) {
			if (Std.is(attrs, Array)) { 
				nodes = attrs;
				attrs = null;
			} else if (Std.is(attrs, String) || Std.is(attrs, Bool) || Std.is(attrs, Int) || Std.is(attrs, Float)) {
				if (tag == '<') nodes = attrs; else v.text = attrs;
				attrs = null;
			}
		}

		if (attrs != null) {
			v.attrs = attrs;
			if (Reflect.hasField(v.attrs, "key") && v.attrs.key != null) v.key = attrs.key;
		}
		v.children = nodes != null ? v.children = ithril.Attributes.attrs(nodes) : [];

		return v;
#end
	}

	public static inline function makeTrust(val)
		return #if (js && !nodejs) untyped m.trust(val); #else makeVnode3('<', null, val); #end
}

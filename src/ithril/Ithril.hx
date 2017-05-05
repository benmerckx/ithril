package ithril;

class Ithril {
	inline public static function trust(content: String) {
		#if (!nodejs && js)
		return untyped m.trust(content);
		#else
		return { tag: "<", children: content };
		#end
	}

	inline public static function redraw(?force: Bool) {
		#if (!nodejs && js)
		return untyped m.redraw(force);
		#else
		return null;
		#end
	}

	inline public static function retain() return untyped {subtree: 'retain'}
}

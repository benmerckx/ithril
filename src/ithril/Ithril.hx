package ithril;

class Ithril {
	
	inline public static function trust(content: String) {
		#if (!nodejs && js)
		return untyped m.trust(content);
		#else
		return new TrustedHTML(content);
		#end
	}
	
	inline public static function redraw(?force: Bool) {
		#if (!nodejs && js)
		return untyped m.redraw(force);
		#else
		return null;
		#end
	}
	
}

typedef TrustedHTMLAccess = TrustedHTML;

private class TrustedHTML {
	var body: String;

	public function new(body: String)
		this.body = body;

	public function toString()
		return body;
}

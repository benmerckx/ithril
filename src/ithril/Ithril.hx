package ithril;

class Ithril {
	
	public static function trust(content: String) {
		#if (!nodejs && js)
		untyped return m.trust(content);
		#end
		return new TrustedHTML(content);
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

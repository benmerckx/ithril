package ithril;

class Ithril {
	public static function trust(content: String) {
		return new TrustedHTML(content);
	}
}
package ithril;
import haxe.macro.Context;

class Ithril {
	
	public static function trust(content: String) {
		return new TrustedHTML(content);
	}
	
}
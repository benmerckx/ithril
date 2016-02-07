package ithril;

using Reflect;

class Attributes {

	public static function attrs(input: Dynamic) {
		var response = input.isFunction() ? input() : input;
		return response == null ? {} : response;
	}
	
	public static function combine(a: Dynamic, b: Dynamic) {
		a = attrs(a);
		b = attrs(b);
		for (key in a.fields()) {
			b.setField(key, a.field(key));
		}
		return b;
	}
}
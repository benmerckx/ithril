package ithril;

class Ithril {
    macro static public function view(func:haxe.macro.Expr) {
		IthrilBuilder.parseFunction(func);
		return macro ${func};
	}
}

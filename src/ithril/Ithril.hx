package ithril;

class Ithril {

#if !macro
	macro static public inline function view(func:haxe.macro.Expr) { }
#else
	macro static public inline function view(func:haxe.macro.Expr) {
		Parser.parseFunction(func);
		return func;
	}
#end

}

package;

import haxe.macro.Expr;
import haxe.macro.Context;

class TestMacro {
	
	macro public static function voidExpr(e: Expr) {
		return macro null;
	}
	
	macro public static function testExpr(a: Expr, b: Expr): Expr {
		trace(Context.currentPos());
		return macro function test(a, b): Dynamic {
			return test;
		};
	}
	
	macro public static function extraCall(call: MacroCall, a: Expr, b: Expr) {
		
	}
	
	macro public static function template(e: Expr) {
		trace(Std.string(e));
		return macro null;
	}
}
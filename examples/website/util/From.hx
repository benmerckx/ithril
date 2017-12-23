package util;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class From
{
	macro public static inline function file(path:String) return toExpr(loadFileAsString(path));

	macro public static inline function command(cmd:String, ?args:Array<String>) return toExpr(getCommandOutputAsString(cmd, args));

	public static macro inline function define(key:String, defaultValue:String = null):Expr
	{
		var value = haxe.macro.Context.definedValue(key);
		if (value == null) value = defaultValue;
		return macro $v{value};
	}

	#if macro
	static function toExpr(v:Dynamic) return Context.makeExpr(v, Context.currentPos());

	static public function loadFileAsString(path:String) return sys.io.File.getContent(Context.resolvePath(path));

	static function getCommandOutputAsString(cmd:String, ?args:Array<String>)
	{
		try
		{
			var process = new sys.io.Process(cmd, args == null ? [] : args);
			var rslt = process.stdout.readAll().toString();
			var err = process.stderr.readAll().toString();
			var exitCode = process.exitCode(true);
			if (exitCode == 0) return rslt;
			throw '($exitCode) $err';
		}
		catch (e:Dynamic)
		{
			return haxe.macro.Context.error('$e', Context.currentPos());
		}
	}

	#end
}

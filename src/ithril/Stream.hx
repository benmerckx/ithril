package ithril;

@:native('m.stream')
extern class Stream {

	public function new(?value:Dynamic);
	public static function combine(combiner:Dynamic, streams:Array<Stream>):Stream;
	public static function merge(streams:Array<Stream>):Stream;
	public static function scan(fn:Dynamic, accumulator:Dynamic, stream:Stream):Stream;
	public static function scanMerge(pairs:Array<Array<Dynamic>>, accumulator:Dynamic):Stream;
	public static var HALT:Dynamic;

	public function map(callback:Dynamic->Dynamic):Stream;
	public function end():Stream;
	public inline function apply(s:Stream):Stream { return untyped __js__('{0}["fantasy-land/ap"]({1})', this, s); }
	public inline function of(s:Stream):Stream { return untyped __js__('{0}["fantasy-land/of"]()', this); }
	public function valueOf():Dynamic;
	public function toString():String;
	public function toJSON():String;

}

package ithril;

import haxe.DynamicAccess;
import haxe.ds.Either;
#if (js && !nodejs)
import js.html.Event;
import js.html.DOMElement in Element;
import js.Promise;
import js.html.XMLHttpRequest;
#else
private typedef Event = Dynamic;
private typedef Promise<T> = Dynamic;
private typedef Element = Dynamic;
private typedef XMLHttpRequest = Dynamic;
#end

typedef Vnodes = Either<Vnode, Array<Vnode>>;

typedef RouteResolver<T:Component> = {
	@:optional function onmatch(args:DynamicAccess<String>, requestedPath:String):Either<T, Promise<T>>;
	@:optional function render(vnode:Vnode):Vnodes;
}

#if !nodejs @:native("m") extern #end
class M {
	public static function mount(element:Element, component:Class<Component>):Void #if nodejs {} #end;
	public static function route(rootElement:Element, defaultRoute:String, routes:Dynamic<Either<Class<Component>, RouteResolver<Dynamic>>>):Void #if nodejs {} #end;
	public static function parseQueryString(querystring:String):DynamicAccess<String> #if nodejs { return null; } #end;
	public static function buildQueryString(data:{}):String #if nodejs { return null; } #end;
	public static function withAttr<T, T2:Event>(attrName:String, callback:T->Void):T2->Void #if nodejs { return null; } #end;
	public static function trust(html:String):Vnode #if nodejs { return null; } #end;
	public static function fragment(attrs:{}, children:Array<Vnodes>):Vnode #if nodejs { return null; } #end;
	public static function redraw():Void #if nodejs {} #end;
	public static var version:String #if nodejs = "1.1.1" #end;

	public static inline function routeSet(route:String, ?data:{ }, ?options:{ ?replace: Bool, ?state: { }, ?title: String }):Void
		return untyped __js__("m.route.set({0}, {1}, {2})", route, data, options);

	public static inline function routeGet():String
		#if !nodejs return untyped route.get(); #else { return null; } #end

	public static inline function routePrefix(prefix:String):Void
		#if !nodejs return untyped route.prefix(prefix); #else {} #end

	public static inline function routeLink(vnode:Vnode):Event->Void
		#if !nodejs return untyped route.link(vnode); #else { return null; } #end

	public static inline function routeAttrs(vnode:Vnode):DynamicAccess<String>
		#if !nodejs return untyped __js__('{0}.attrs', vnode); #else { return null; } #end

	public static inline function routeParam(?key:String):Dynamic
		#if !nodejs return untyped route.param(key); #else { return null; } #end

	#if !nodejs
	@:overload(function(selector:Either<String, Class<Component>>):Vnodes {})
	@:overload(function(selector:Either<String, Class<Component>>, attributes:Dynamic):Vnodes {})
	public static function m(selector:Either<String, Class<Component>>, attributes:Dynamic, children:Dynamic):Vnodes;

	@:overload(function<T, T2, T3>(url:String):Promise<T> {})
	@:overload(function<T, T2, T3>(options:XHROptions<T, T2, T3>):Promise<T> {})
	public static function request<T, T2, T3>(url:String, options:XHROptions<T, T2, T3>):Promise<T>;

	@:overload(function<T>(url:String):Promise<T> {})
	@:overload(function<T, T2>(options:JSONPOptions<T, T2>):Promise<T> {})
	public static function jsonp<T, T2>(url:String, options:JSONPOptions<T, T2>):Promise<T>;
	#end
}

typedef XHROptions<T, T2, T3> = {
	@:optional var url:String;
	@:optional var method:String;
	@:optional var data:Dynamic;
	@:optional var async:Bool;
	@:optional var user:String;
	@:optional var password:String;
	@:optional var withCredentials:Bool;
	@:optional var config:XMLHttpRequest->XMLHttpRequest;
	@:optional var headers:DynamicAccess<String>;
	@:optional var type:T->Dynamic;
	@:optional var serialize:T3->String;
	@:optional var deserialize:String->T3;
	@:optional var extract:XMLHttpRequest->XHROptions<T, T2, T3>->String;
	@:optional var useBody:Bool;
	@:optional var background:Bool;
};

typedef JSONPOptions<T, T2> = {
	@:optional var url:String;
	@:optional var data:Dynamic;
	@:optional var type:T->Dynamic;
	@:optional var callbackName:String;
	@:optional var callbackKey:String;
};


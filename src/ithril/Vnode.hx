package ithril;

import haxe.extern.EitherType;
#if js 
import js.html.Element;
#end

typedef Vnode = {
	tag:Dynamic,
	?key:String,
	?attrs:Dynamic,
	?children:Array<Dynamic>,
	?text:String,
#if js
	?dom:Element,
#else
	?dom:Dynamic,
#end
	?domSize:Int,
	?state:Dynamic,
};

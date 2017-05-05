package ithril;

import haxe.extern.EitherType;
import js.html.Element;

typedef Vnode<T> = {
	tag:EitherType<String, Dynamic>,
	?key:String,
	?attrs:T,
	?children:Array<Vnode<Dynamic>>,
	?text:Dynamic,
	?dom:Element,
	?domSize:Int,
	?state:Dynamic,
};

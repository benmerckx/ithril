(function ($global) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var Type = function() { };
Type.__name__ = true;
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw new js__$Boot_HaxeError("Too many arguments");
	}
	return null;
};
var ithril_Ithril = function() { };
ithril_Ithril.__name__ = true;
var ithril_ComponentAbstract = function() {
	this.parent = null;
	this.children = [];
};
ithril_ComponentAbstract.__name__ = true;
ithril_ComponentAbstract.prototype = {
	setChildren: function(children) {
		if(children.length == 1 && ((children instanceof Array) && children.__enum__ == null)) children = children[0];
		this.children = children;
		if((children instanceof Array) && children.__enum__ == null) {
			var _g = 0;
			while(_g < children.length) {
				var child = children[_g];
				++_g;
				if(js_Boot.__instanceof(child,ithril_ComponentAbstract)) child.parent = this;
			}
		}
	}
	,__class__: ithril_ComponentAbstract
};
var Web = function() {
	this.tabs = [1,2,3,4,5];
	ithril_ComponentAbstract.call(this);
};
Web.__name__ = true;
Web.main = function() {
	m.mount(window.document.body,new Web());
};
Web.__super__ = ithril_ComponentAbstract;
Web.prototype = $extend(ithril_ComponentAbstract.prototype,{
	wrap: function() {
		return [{ tag : "!doctype", attrs : { html : true}, children : []},{ tag : "meta", attrs : { charset : "utf-8"}, children : []},{ tag : "link", attrs : { rel : "stylesheet", href : "layout.css"}, children : []},{ tag : "body", attrs : { }, children : [this.view()]},{ tag : "script", attrs : { src : "https://cdnjs.cloudflare.com/ajax/libs/mithril/0.2.0/mithril.min.js"}, children : []},{ tag : "script", attrs : { src : "main.js"}, children : []}];
	}
	,view: function() {
		var _g = this;
		var tmp;
		var _g1 = [];
		var _g11 = 0;
		var _g2 = this.tabs;
		while(_g11 < _g2.length) {
			var i = _g2[_g11];
			++_g11;
			_g1.push(ithril_ComponentCache.getComponent("ae6a6d0f2502d556900ae244abd50ece",ithril_components_Tab,["Content " + i],["Label " + i]));
		}
		tmp = _g1;
		return { tag : "div", attrs : { 'class' : "tabs-example"}, children : [ithril_ComponentCache.getComponent("b019272020bfc25b6bae861f9f18cc08",ithril_components_Tabs,[ithril_ComponentCache.getComponent("b2eff295ab0469f9b00d54a84b23ff79",ithril_components_Tab,["Tab 1"],["Tab label"]),ithril_ComponentCache.getComponent("dbf701f0ffae5a17dcd06054818cf1ad",ithril_components_Tab,["Tab 2"],["Tab label 2"])],[]),ithril_ComponentCache.getComponent("4d7bc5ea769112b163cf993e4b800760",ithril_components_Tabs,[tmp],[]),{ tag : "a", attrs : { onclick : function() {
			_g.tabs.push(1);
		}}, children : ["Add tab"]}]};
	}
	,__class__: Web
});
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		return this.rh == null?null:this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,__class__: haxe_ds_StringMap
};
var ithril_Component = function() { };
ithril_Component.__name__ = true;
var ithril_ComponentCache = function() { };
ithril_ComponentCache.__name__ = true;
ithril_ComponentCache.getComponent = function(key,type,children,state) {
	var id = "";
	if(state.length > 0 && Object.prototype.hasOwnProperty.call(state[0],"key")) id = "__key__" + Std.string(state[0].key); else {
		var count = (function($this) {
			var $r;
			var _this1 = ithril_ComponentCache.componentCount;
			$r = __map_reserved[key] != null?_this1.existsReserved(key):_this1.h.hasOwnProperty(key);
			return $r;
		}(this))?(function($this) {
			var $r;
			var _this2 = ithril_ComponentCache.componentCount;
			$r = __map_reserved[key] != null?_this2.getReserved(key):_this2.h[key];
			return $r;
		}(this)):0;
		var _this3 = ithril_ComponentCache.componentCount;
		var value = count + 1;
		if(__map_reserved[key] != null) _this3.setReserved(key,value); else _this3.h[key] = value;
		id = count == null?"null":"" + count;
		window.setTimeout(function() {
			ithril_ComponentCache.componentCount = new haxe_ds_StringMap();
		},0);
	}
	key += id;
	if(!(function($this) {
		var $r;
		var _this4 = ithril_ComponentCache.componentInstances;
		$r = __map_reserved[key] != null?_this4.existsReserved(key):_this4.h.hasOwnProperty(key);
		return $r;
	}(this))) {
		var value1 = Type.createInstance(type,[]);
		var _this5 = ithril_ComponentCache.componentInstances;
		if(__map_reserved[key] != null) _this5.setReserved(key,value1); else _this5.h[key] = value1;
	}
	var instance = (function($this) {
		var $r;
		var _this = ithril_ComponentCache.componentInstances;
		$r = __map_reserved[key] != null?_this.getReserved(key):_this.h[key];
		return $r;
	}(this));
	instance.setChildren(children);
	instance.setState.apply(instance,state);
	return instance;
};
var ithril_components_Tab = function() {
	ithril_ComponentAbstract.call(this);
};
ithril_components_Tab.__name__ = true;
ithril_components_Tab.__super__ = ithril_ComponentAbstract;
ithril_components_Tab.prototype = $extend(ithril_ComponentAbstract.prototype,{
	labelView: function() {
		var _g = this;
		var tabs = js_Boot.__cast(this.parent , ithril_components_Tabs);
		return { tag : "a", attrs : { onclick : function() {
			tabs.setSelected(_g);
		}, 'class' : tabs.isSelected(this)?"active":""}, children : [this.label]};
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "tab"}, children : [this.children]};
	}
	,setState: function(label) {
		this.label = label;
	}
	,__class__: ithril_components_Tab
});
var ithril_components_Tabs = function() {
	this.selected = 0;
	ithril_ComponentAbstract.call(this);
};
ithril_components_Tabs.__name__ = true;
ithril_components_Tabs.__super__ = ithril_ComponentAbstract;
ithril_components_Tabs.prototype = $extend(ithril_ComponentAbstract.prototype,{
	setSelected: function(tab) {
		this.selected = this.children.indexOf(tab);
	}
	,isSelected: function(tab) {
		return this.children.indexOf(tab) == this.selected;
	}
	,view: function() {
		if(this.attrs == null) this.attrs = { };
		var tmp;
		var t = this.attrs;
		t["class"] = "tabs";
		tmp = t;
		var tmp1;
		var _g = [];
		var _g1 = 0;
		var _g2 = this.children;
		while(_g1 < _g2.length) {
			var tab = _g2[_g1];
			++_g1;
			_g.push(tab.labelView());
		}
		tmp1 = _g;
		return { tag : "div", attrs : tmp, children : [{ tag : "nav", attrs : { }, children : [tmp1]},this.children[this.selected]]};
	}
	,setState: function(attrs) {
		this.attrs = attrs;
	}
	,__class__: ithril_components_Tabs
});
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
ithril_ComponentCache.componentInstances = new haxe_ds_StringMap();
ithril_ComponentCache.componentCount = new haxe_ds_StringMap();
js_Boot.__toStr = {}.toString;
Web.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

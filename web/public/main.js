(function (console, $global) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
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
var ithril_Component = function(parent) {
	this.componentCount = 0;
	this.parent = parent;
	this.componentInstances = new haxe_ds_StringMap();
};
ithril_Component.__name__ = true;
ithril_Component.prototype = {
	setChildren: function(children) {
		this.componentCount = 0;
		if(children.length == 1 && ((children instanceof Array) && children.__enum__ == null)) children = children[0];
		this.children = children;
		if((children instanceof Array) && children.__enum__ == null) {
			var _g = 0;
			while(_g < children.length) {
				var child = children[_g];
				++_g;
				if(js_Boot.__instanceof(child,ithril_Component)) child.parent = this;
			}
		}
		return this;
	}
	,setAttributes: function(attrs) {
		try {
			this.attributes.apply(this,attrs);
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
		}
		return this;
	}
	,getComponent: function(key,type) {
		key = key + this.componentCount;
		this.componentCount++;
		if(!this.componentInstances.exists(key)) {
			var value = Type.createInstance(type,[this]);
			this.componentInstances.set(key,value);
		}
		return this.componentInstances.get(key);
	}
	,__class__: ithril_Component
};
var Web = function(parent) {
	this.tabs = [1,2,3,4,5];
	ithril_Component.call(this,parent);
};
Web.__name__ = true;
Web.main = function() {
	m.mount(window.document.body,new Web());
};
Web.__super__ = ithril_Component;
Web.prototype = $extend(ithril_Component.prototype,{
	wrap: function() {
		return [{ tag : "!doctype", attrs : { html : true}, children : []},{ tag : "meta", attrs : { charset : "utf-8"}, children : []},{ tag : "link", attrs : { rel : "stylesheet", href : "layout.css"}, children : []},{ tag : "body", attrs : { }, children : [this.view()]},{ tag : "script", attrs : { src : "https://cdnjs.cloudflare.com/ajax/libs/mithril/0.2.0/mithril.min.js"}, children : []},{ tag : "script", attrs : { src : "main.js"}, children : []}];
	}
	,view: function() {
		var _g = this;
		this.componentCount = 0;
		return { tag : "div", attrs : { 'class' : "tabs-example"}, children : [this.getComponent("84a1b32d6bc8cecd034d263ad258c2df",ithril_components_Tabs).setChildren([this.getComponent("1bc9312e1079a59530c5fe84bf982262",ithril_components_Tab).setChildren(["Tab 1"]).setAttributes(["Tab label"]),this.getComponent("ff99da5ed9fa7d08cd49c1b55bc7e3bd",ithril_components_Tab).setChildren(["Tab 2"]).setAttributes(["Tab label 2"])]).setAttributes([]),this.getComponent("342e14b4a85c774ca3152dde5389686a",ithril_components_Tabs).setChildren([(function($this) {
			var $r;
			var _g1 = [];
			{
				var _g11 = 0;
				var _g2 = $this.tabs;
				while(_g11 < _g2.length) {
					var i = _g2[_g11];
					++_g11;
					_g1.push($this.getComponent("4c06af6c146acee604fd177e3b338930",ithril_components_Tab).setChildren(["Content " + i]).setAttributes(["Label " + i]));
				}
			}
			$r = _g1;
			return $r;
		}(this))]).setAttributes([]),{ tag : "a", attrs : { onclick : function() {
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
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,__class__: haxe_ds_StringMap
};
var ithril_components_Tab = function(parent) {
	ithril_Component.call(this,parent);
};
ithril_components_Tab.__name__ = true;
ithril_components_Tab.__super__ = ithril_Component;
ithril_components_Tab.prototype = $extend(ithril_Component.prototype,{
	attributes: function(label) {
		this.label = label;
	}
	,labelView: function() {
		var _g = this;
		var tabs;
		tabs = js_Boot.__cast(this.parent , ithril_components_Tabs);
		return { tag : "a", attrs : { onclick : function() {
			tabs.setSelected(_g);
		}, 'class' : tabs.isSelected(this)?"active":""}, children : [this.label]};
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "tab"}, children : [this.children]};
	}
	,__class__: ithril_components_Tab
});
var ithril_components_Tabs = function(parent) {
	this.selected = 0;
	ithril_Component.call(this,parent);
};
ithril_components_Tabs.__name__ = true;
ithril_components_Tabs.__super__ = ithril_Component;
ithril_components_Tabs.prototype = $extend(ithril_Component.prototype,{
	setSelected: function(tab) {
		this.selected = HxOverrides.indexOf(this.children,tab,0);
	}
	,isSelected: function(tab) {
		return HxOverrides.indexOf(this.children,tab,0) == this.selected;
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "tabs"}, children : [{ tag : "nav", attrs : { }, children : [(function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				var _g2 = $this.children;
				while(_g1 < _g2.length) {
					var tab = _g2[_g1];
					++_g1;
					_g.push(tab.labelView());
				}
			}
			$r = _g;
			return $r;
		}(this))]},this.children[this.selected]]};
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
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
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
js_Boot.__toStr = {}.toString;
Web.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

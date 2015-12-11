(function ($global) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	return quotes?s.split("\"").join("&quot;").split("'").join("&#039;"):s;
};
var ithril_ComponentAbstract = function() {
};
ithril_ComponentAbstract.__name__ = true;
ithril_ComponentAbstract.prototype = {
	setChildren: function(children) {
		var _g = this;
		if(children.length == 1 && ((children instanceof Array) && children.__enum__ == null)) children = children[0];
		this.children = children;
		if((children instanceof Array) && children.__enum__ == null) children.map(function(child) {
			if(js_Boot.__instanceof(child,ithril_ComponentAbstract)) child.parent = _g;
		});
	}
	,__class__: ithril_ComponentAbstract
};
var Web = function() {
	this.inputValue = "Hello";
	this.tabs = [1,2,3,4,5];
	ithril_ComponentAbstract.call(this);
};
Web.__name__ = true;
Web.main = function() {
	m.mount(window.document.body,new Web());
};
Web.__super__ = ithril_ComponentAbstract;
Web.prototype = $extend(ithril_ComponentAbstract.prototype,{
	view: function() {
		return this.body();
	}
	,body: function() {
		var _g = this;
		var tmp;
		var _g1 = [];
		var _g11 = 0;
		var _g2 = this.tabs;
		while(_g11 < _g2.length) {
			var i = _g2[_g11];
			++_g11;
			_g1.push(ithril_component_ComponentCache.getComponent_ithril_elements_Tab("78dfa01db7d14ae3d05ae0fb6338aa4f",ithril_elements_Tab,["Content " + i],["Label " + i]));
		}
		tmp = _g1;
		return { tag : "div", attrs : { 'class' : "tabs-example"}, children : [ithril_component_ComponentCache.getComponent_ithril_elements_Tabs("521277084a8d7cb0794135abf767cfdc",ithril_elements_Tabs,[ithril_component_ComponentCache.getComponent_ithril_elements_Tab("a9ded0a8a82de85494c5a3e39c8ff2bc",ithril_elements_Tab,["Tab 1"],["Tab label"]),ithril_component_ComponentCache.getComponent_ithril_elements_Tab("995eacc7873124e28de6b5106bd328d2",ithril_elements_Tab,["Tab 2"],["Tab label 2"])],[]),ithril_component_ComponentCache.getComponent_ithril_elements_Tabs("d84b9ad88b134ff93cbd77d5c9295b00",ithril_elements_Tabs,[tmp],[]),{ tag : "a", attrs : { onclick : function() {
			_g.tabs.push(_g.tabs.length + 1);
		}}, children : ["Add tab"]},{ tag : "div", attrs : { }, children : [{ tag : "h1", attrs : { }, children : [this.inputValue]},ithril_component_ComponentCache.getComponent_ithril_elements_Text("5eaa1e32a01156585ac9da8a1e265401",ithril_elements_Text,[],[{ oninput : function(e) {
			_g.inputValue = e.target.value;
		}, value : this.inputValue, multiline : true}])]}]};
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
var ithril_TrustedHTML = function(body) {
	this.body = body;
	return m.trust(body);
};
ithril_TrustedHTML.__name__ = true;
ithril_TrustedHTML.prototype = {
	__class__: ithril_TrustedHTML
};
var ithril_component_ComponentCache = function() { };
ithril_component_ComponentCache.__name__ = true;
ithril_component_ComponentCache.getComponent_ithril_elements_Text = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,type,children,state,function() {
		return new ithril_elements_Text();
	});
};
ithril_component_ComponentCache.getComponent_ithril_elements_Tabs = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,type,children,state,function() {
		return new ithril_elements_Tabs();
	});
};
ithril_component_ComponentCache.getComponent_ithril_elements_Tab = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,type,children,state,function() {
		return new ithril_elements_Tab();
	});
};
ithril_component_ComponentCache.createKey = function(key,state) {
	var id = "";
	if(state.length > 0 && Object.prototype.hasOwnProperty.call(state[0],"key")) id = "__key__" + Std.string(state[0].key); else {
		var tmp;
		var _this = ithril_component_ComponentCache.componentCount;
		if(__map_reserved[key] != null) tmp = _this.existsReserved(key); else tmp = _this.h.hasOwnProperty(key);
		var tmp1;
		if(tmp) {
			var tmp2;
			var _this1 = ithril_component_ComponentCache.componentCount;
			if(__map_reserved[key] != null) tmp2 = _this1.getReserved(key); else tmp2 = _this1.h[key];
			tmp1 = tmp2;
		} else tmp1 = 0;
		var count = tmp1;
		var _this2 = ithril_component_ComponentCache.componentCount;
		var value = count + 1;
		if(__map_reserved[key] != null) _this2.setReserved(key,value); else _this2.h[key] = value;
		id = count == null?"null":"" + count;
		if(ithril_component_ComponentCache.timeout == null) ithril_component_ComponentCache.timeout = window.setTimeout(function() {
			ithril_component_ComponentCache.componentCount = new haxe_ds_StringMap();
			ithril_component_ComponentCache.timeout = null;
		},0);
	}
	return key + id;
};
ithril_component_ComponentCache.setProps = function(instance,children,state) {
	instance.setChildren(children);
	instance.setState.apply(instance,state);
};
ithril_component_ComponentCache.getInstance = function(key,type,children,state,create) {
	key = ithril_component_ComponentCache.createKey(key,state);
	var tmp;
	var _this = ithril_component_ComponentCache.componentInstances;
	if(__map_reserved[key] != null) tmp = _this.existsReserved(key); else tmp = _this.h.hasOwnProperty(key);
	if(!tmp) {
		var value = create();
		var _this1 = ithril_component_ComponentCache.componentInstances;
		if(__map_reserved[key] != null) _this1.setReserved(key,value); else _this1.h[key] = value;
	}
	var tmp1;
	var _this2 = ithril_component_ComponentCache.componentInstances;
	if(__map_reserved[key] != null) tmp1 = _this2.getReserved(key); else tmp1 = _this2.h[key];
	var instance = tmp1;
	ithril_component_ComponentCache.setProps(instance,children,state);
	return instance;
};
var ithril_elements_Tab = function() {
	ithril_ComponentAbstract.call(this);
};
ithril_elements_Tab.__name__ = true;
ithril_elements_Tab.__super__ = ithril_ComponentAbstract;
ithril_elements_Tab.prototype = $extend(ithril_ComponentAbstract.prototype,{
	labelView: function(selected,onclick) {
		var tmp;
		var f = onclick;
		var a1 = this;
		tmp = function() {
			f(a1);
		};
		return { tag : "a", attrs : { onclick : tmp, 'class' : selected?"active":""}, children : [this.label]};
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "tab"}, children : [this.children]};
	}
	,setState: function(label) {
		this.label = label;
	}
	,__class__: ithril_elements_Tab
});
var ithril_elements_Tabs = function() {
	this.selected = 0;
	ithril_ComponentAbstract.call(this);
};
ithril_elements_Tabs.__name__ = true;
ithril_elements_Tabs.__super__ = ithril_ComponentAbstract;
ithril_elements_Tabs.prototype = $extend(ithril_ComponentAbstract.prototype,{
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
			_g.push(tab.labelView(this.isSelected(tab),$bind(this,this.setSelected)));
		}
		tmp1 = _g;
		return { tag : "div", attrs : { 'class' : "ithril"}, children : [{ tag : "div", attrs : tmp, children : [{ tag : "nav", attrs : { }, children : [tmp1]},this.children[this.selected]]}]};
	}
	,setState: function(attrs) {
		this.attrs = attrs;
	}
	,__class__: ithril_elements_Tabs
});
var ithril_elements_Text = function() {
	this.value = "";
	ithril_ComponentAbstract.call(this);
};
ithril_elements_Text.__name__ = true;
ithril_elements_Text.__super__ = ithril_ComponentAbstract;
ithril_elements_Text.prototype = $extend(ithril_ComponentAbstract.prototype,{
	setState: function(options) {
		this.options = options;
	}
	,setupMirror: function(el,isInitialized,ctx) {
		var _g = this;
		this.setHeight(el);
		if(!isInitialized) {
			var tmp;
			var f = $bind(this,this.setHeight);
			var a1 = el;
			tmp = function() {
				f(a1);
			};
			window.addEventListener("resize",tmp);
			ctx.onunload = function() {
				var tmp1;
				var f1 = $bind(_g,_g.setHeight);
				var a11 = el;
				tmp1 = function() {
					f1(a11);
				};
				window.removeEventListener("resize",tmp1);
			};
		}
	}
	,setHeight: function(mirror) {
		var area = mirror.previousSibling;
		mirror.style.width = area.offsetWidth + "px";
		area.style.height = mirror.offsetHeight + "px";
	}
	,textarea: function() {
		var _g = this;
		return { tag : "div", attrs : { }, children : [{ tag : "textarea", attrs : { oninput : function(e) {
			_g.value = e.target.value;
		}, 'class' : "field"}, children : [this.value]},{ tag : "div", attrs : { config : $bind(this,this.setupMirror), 'class' : "mirror"}, children : [new ithril_TrustedHTML(StringTools.htmlEscape(this.value).split("\n").join("<br>") + "<br>")]}]};
	}
	,input: function() {
		var _g = this;
		return { tag : "input", attrs : { oninput : function(e) {
			_g.value = e.target.value;
		}, value : this.value, 'class' : "field"}, children : []};
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "ithril"}, children : [this.options.multiline?this.textarea():this.input()]};
	}
	,__class__: ithril_elements_Text
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
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
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
ithril_component_ComponentCache.componentInstances = new haxe_ds_StringMap();
ithril_component_ComponentCache.componentCount = new haxe_ds_StringMap();
js_Boot.__toStr = {}.toString;
Web.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

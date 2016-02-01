(function ($global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
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
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
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
	this.dirty = false;
};
ithril_ComponentAbstract.__name__ = true;
ithril_ComponentAbstract.prototype = {
	setState: function(state) {
		this.state = state;
	}
	,mount: function() {
	}
	,unmount: function() {
	}
	,setChildren: function(children) {
		var _g = this;
		if(children.length == 1 && ((children[0] instanceof Array) && children[0].__enum__ == null)) children = children[0];
		this.children = children;
		if((children instanceof Array) && children.__enum__ == null) children.map(function(child) {
			if(js_Boot.__instanceof(child,ithril_ComponentAbstract)) child.parent = _g;
		});
	}
	,__class__: ithril_ComponentAbstract
};
var Web = function() {
	this.inputValue = "Hello";
	this.tabs = [1];
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
		var tmp3;
		var children1 = ["Tab 1"];
		var tmp6 = ithril_component_ComponentCache.getComponent_ithril_elements_Tab("67c459be8b5f7830987ec03794987c6f",ithril_elements_Tab,children1,"Tab label");
		tmp6.setChildren(children1);
		tmp6.setState("Tab label");
		tmp3 = tmp6;
		var tmp4;
		var children2 = ["Tab 2"];
		var tmp7 = ithril_component_ComponentCache.getComponent_ithril_elements_Tab("e24a155aa24b8d01609a48c6b02ea815",ithril_elements_Tab,children2,"Tab label 2");
		tmp7.setChildren(children2);
		tmp7.setState("Tab label 2");
		tmp4 = tmp7;
		var children = [tmp3,tmp4];
		var tmp5 = ithril_component_ComponentCache.getComponent_ithril_elements_Tabs__("a5f4e0494c6195a67aa6d128e9eac61b",ithril_elements_Tabs,children,{ });
		tmp5.setChildren(children);
		tmp5.setState({ });
		tmp = tmp5;
		var tmp1;
		var children4 = this.tabs.map(function(i) {
			var tmp8;
			var children3 = ["Content " + i];
			var tmp9 = ithril_component_ComponentCache.getComponent_ithril_elements_Tab("1756a2baa785024cb92d2b3ab095d920",ithril_elements_Tab,children3,"Label " + i);
			tmp9.setChildren(children3);
			tmp9.setState("Label " + i);
			tmp8 = tmp9;
			return tmp8;
		});
		var tmp10 = ithril_component_ComponentCache.getComponent_ithril_elements_Tabs__("e308dacbee9682ee6979e8f807c7c781",ithril_elements_Tabs,children4,{ });
		tmp10.setChildren(children4);
		tmp10.setState({ });
		tmp1 = tmp10;
		var tmp2;
		var children5 = [];
		var tmp11 = ithril_component_ComponentCache.getComponent_ithril_elements_Text("072aed1b414127bc599293610d443f3b",ithril_elements_Text,children5,{ oninput : function(e) {
			_g.inputValue = e.field.value;
		}, value : this.inputValue, multiline : true});
		tmp11.setChildren(children5);
		tmp11.setState({ oninput : function(e1) {
			_g.inputValue = e1.field.get_value();
		}, value : this.inputValue, multiline : true});
		tmp2 = tmp11;
		return { tag : "div", attrs : { 'class' : "tabs-example"}, children : [tmp,tmp1,{ tag : "a", attrs : { onclick : function() {
			_g.tabs.push(_g.tabs.length + 1);
		}}, children : ["Add tab"]},{ tag : "a", attrs : { onclick : function() {
			_g.tabs.pop();
		}}, children : ["Remove tab"]},{ tag : "div", attrs : { }, children : [{ tag : "h1", attrs : { }, children : [this.inputValue]},tmp2]}]};
	}
	,__class__: Web
});
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
haxe_ds__$StringMap_StringMapIterator.__name__ = true;
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		var tmp;
		var _this = this.map;
		var key = this.keys[this.index++];
		if(__map_reserved[key] != null) tmp = _this.getReserved(key); else tmp = _this.h[key];
		return tmp;
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
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
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,keys: function() {
		var tmp;
		var _this = this.arrayKeys();
		tmp = HxOverrides.iter(_this);
		return tmp;
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
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
	return ithril_component_ComponentCache.getInstance(key,children,state,function() {
		return new ithril_elements_Text();
	});
};
ithril_component_ComponentCache.getComponent_ithril_elements_Tabs__ = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,children,state,function() {
		return new ithril_elements_Tabs();
	});
};
ithril_component_ComponentCache.getComponent_ithril_elements_Tab = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,children,state,function() {
		return new ithril_elements_Tab();
	});
};
ithril_component_ComponentCache.createKey = function(key,state) {
	var id = "";
	if(Object.prototype.hasOwnProperty.call(state,"key")) id = "__key__" + Std.string(Reflect.field(state,"key")); else {
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
		if(ithril_component_ComponentCache.timeout == null) {
			var tmp3;
			var _this3 = ithril_component_ComponentCache.componentInstances;
			tmp3 = new haxe_ds__$StringMap_StringMapIterator(_this3,_this3.arrayKeys());
			while( tmp3.hasNext() ) {
				var component = tmp3.next();
				component.dirty = true;
			}
			ithril_component_ComponentCache.timeout = window.requestAnimationFrame(function(_) {
				ithril_component_ComponentCache.componentCount = new haxe_ds_StringMap();
				ithril_component_ComponentCache.timeout = null;
				var $it0 = ithril_component_ComponentCache.componentInstances.keys();
				while( $it0.hasNext() ) {
					var key1 = $it0.next();
					var tmp4;
					var _this4 = ithril_component_ComponentCache.componentInstances;
					if(__map_reserved[key1] != null) tmp4 = _this4.getReserved(key1); else tmp4 = _this4.h[key1];
					var component1 = tmp4;
					if(component1.dirty) {
						component1.unmount();
						ithril_component_ComponentCache.componentInstances.remove(key1);
					}
				}
			});
		}
	}
	return key + id;
};
ithril_component_ComponentCache.getInstance = function(key,children,state,create) {
	key = ithril_component_ComponentCache.createKey(key,state);
	var tmp;
	var _this = ithril_component_ComponentCache.componentInstances;
	if(__map_reserved[key] != null) tmp = _this.existsReserved(key); else tmp = _this.h.hasOwnProperty(key);
	if(!tmp) {
		var c = create();
		c.mount();
		var _this1 = ithril_component_ComponentCache.componentInstances;
		if(__map_reserved[key] != null) _this1.setReserved(key,c); else _this1.h[key] = c;
	}
	var tmp1;
	var _this2 = ithril_component_ComponentCache.componentInstances;
	if(__map_reserved[key] != null) tmp1 = _this2.getReserved(key); else tmp1 = _this2.h[key];
	var component = tmp1;
	component.dirty = false;
	return component;
};
var ithril_elements_FieldEventType = { __ename__ : true, __constructs__ : ["Change","Input","Focus","Blur"] };
ithril_elements_FieldEventType.Change = ["Change",0];
ithril_elements_FieldEventType.Change.toString = $estr;
ithril_elements_FieldEventType.Change.__enum__ = ithril_elements_FieldEventType;
ithril_elements_FieldEventType.Input = ["Input",1];
ithril_elements_FieldEventType.Input.toString = $estr;
ithril_elements_FieldEventType.Input.__enum__ = ithril_elements_FieldEventType;
ithril_elements_FieldEventType.Focus = ["Focus",2];
ithril_elements_FieldEventType.Focus.toString = $estr;
ithril_elements_FieldEventType.Focus.__enum__ = ithril_elements_FieldEventType;
ithril_elements_FieldEventType.Blur = ["Blur",3];
ithril_elements_FieldEventType.Blur.toString = $estr;
ithril_elements_FieldEventType.Blur.__enum__ = ithril_elements_FieldEventType;
var ithril_elements_Field = function() {
	ithril_ComponentAbstract.call(this);
};
ithril_elements_Field.__name__ = true;
ithril_elements_Field.__super__ = ithril_ComponentAbstract;
ithril_elements_Field.prototype = $extend(ithril_ComponentAbstract.prototype,{
	get_value: function() {
		return this.value;
	}
	,set_value: function(value) {
		return this.value = value;
	}
	,forwardListeners: function(attrs) {
		var _g = this;
		attrs.onchange = function(e) {
			_g.set_value(e.target.value);
			if(_g.state.onchange != null) _g.state.onchange({ type : ithril_elements_FieldEventType.Change, field : _g});
		};
		attrs.oninput = function(e1) {
			_g.set_value(e1.target.value);
			if(_g.state.oninput != null) _g.state.oninput({ type : ithril_elements_FieldEventType.Input, field : _g});
		};
		attrs.onfocus = function(e2) {
			if(_g.state.onfocus != null) _g.state.onfocus({ type : ithril_elements_FieldEventType.Focus, field : _g});
		};
		attrs.onblur = function(e3) {
			if(_g.state.onblur != null) _g.state.onblur({ type : ithril_elements_FieldEventType.Blur, field : _g});
		};
		return attrs;
	}
	,setState: function(state) {
		ithril_ComponentAbstract.prototype.setState.call(this,state);
		this.set_value(state.value);
	}
	,__class__: ithril_elements_Field
});
var ithril_elements_Tab = function() {
	this.random = Math.random();
	ithril_ComponentAbstract.call(this);
};
ithril_elements_Tab.__name__ = true;
ithril_elements_Tab.__super__ = ithril_ComponentAbstract;
ithril_elements_Tab.prototype = $extend(ithril_ComponentAbstract.prototype,{
	mount: function() {
		console.log("mounted tab");
	}
	,unmount: function() {
		console.log("unmounted tab");
	}
	,labelView: function(selected,onclick) {
		var tmp;
		var f = onclick;
		var a1 = this;
		tmp = function() {
			f(a1);
		};
		return { tag : "a", attrs : { onclick : tmp, 'class' : selected?"active":""}, children : [this.state]};
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "tab"}, children : [this.children,{ tag : "div", attrs : { 'class' : "random"}, children : [this.random]}]};
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
		var _g = this;
		var tmp;
		var t = this.state == null?{ }:this.state;
		t["class"] = "tabs";
		tmp = t;
		return { tag : "div", attrs : { 'class' : "ithril"}, children : [{ tag : "div", attrs : tmp, children : [{ tag : "nav", attrs : { }, children : this.children.map(function(tab) {
			return tab.labelView(_g.isSelected(tab),$bind(_g,_g.setSelected));
		})},this.children[this.selected]]}]};
	}
	,__class__: ithril_elements_Tabs
});
var ithril_elements_Text = function() {
	ithril_elements_Field.call(this);
};
ithril_elements_Text.__name__ = true;
ithril_elements_Text.__super__ = ithril_elements_Field;
ithril_elements_Text.prototype = $extend(ithril_elements_Field.prototype,{
	setupMirror: function(el,isInitialized,ctx) {
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
		var tmp;
		var t = this.forwardListeners({ });
		t["class"] = "field";
		tmp = t;
		return { tag : "div", attrs : { }, children : [{ tag : "textarea", attrs : tmp, children : [this.get_value()]},{ tag : "div", attrs : { config : $bind(this,this.setupMirror), 'class' : "mirror"}, children : [new ithril_TrustedHTML(StringTools.htmlEscape(this.get_value()).split("\n").join("<br>") + "<br>")]}]};
	}
	,input: function() {
		var tmp;
		var t = this.forwardListeners({ value : this.get_value()});
		t["class"] = "field";
		tmp = t;
		return { tag : "input", attrs : tmp, children : []};
	}
	,view: function() {
		return { tag : "div", attrs : { 'class' : "ithril"}, children : [this.state.multiline?this.textarea():this.input()]};
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

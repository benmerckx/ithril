(function (console, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	r: null
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
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
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = ["Lambda"];
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
};
var List = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,__class__: List
};
Math.__name__ = ["Math"];
var Reflect = function() { };
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
};
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && v.__enum__ == null || t == "function" && (v.__name__ || v.__ename__) != null;
};
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	b: null
	,__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	if(quotes) return s.split("\"").join("&quot;").split("'").join("&#039;"); else return s;
};
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var ithril_Ithril = function() { };
ithril_Ithril.__name__ = ["ithril","Ithril"];
var ithril_ComponentAbstract = function() {
	this.dirty = false;
	this.parent = null;
	this.stateFields = [];
};
ithril_ComponentAbstract.__name__ = ["ithril","ComponentAbstract"];
ithril_ComponentAbstract.prototype = {
	state: null
	,stateFields: null
	,children: null
	,parent: null
	,dirty: null
	,setState: function(state) {
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
	,asHTML: function(space) {
		if(space == null) space = "";
		return ithril_HTMLRenderer.render(this,space);
	}
	,__class__: ithril_ComponentAbstract
};
var CustomElement = function() {
	ithril_ComponentAbstract.call(this);
};
CustomElement.__name__ = ["CustomElement"];
CustomElement.__super__ = ithril_ComponentAbstract;
CustomElement.prototype = $extend(ithril_ComponentAbstract.prototype,{
	view: function() {
		return { tag : "div", attrs : ithril_Attributes.attrs(this.state), children : []};
	}
	,__class__: CustomElement
});
var ListComponent = function() {
	ithril_ComponentAbstract.call(this);
};
ListComponent.__name__ = ["ListComponent"];
ListComponent.__super__ = ithril_ComponentAbstract;
ListComponent.prototype = $extend(ithril_ComponentAbstract.prototype,{
	view: function() {
		return { tag : "ul", attrs : { }, children : this.children.map(function(child) {
			return { tag : "li", attrs : { }, children : [child]};
		})};
	}
	,__class__: ListComponent
});
var haxe_unit_TestCase = function() {
};
haxe_unit_TestCase.__name__ = ["haxe","unit","TestCase"];
haxe_unit_TestCase.prototype = {
	currentTest: null
	,setup: function() {
	}
	,tearDown: function() {
	}
	,print: function(v) {
		haxe_unit_TestRunner.print(v);
	}
	,assertTrue: function(b,c) {
		this.currentTest.done = true;
		if(b != true) {
			this.currentTest.success = false;
			this.currentTest.error = "expected true but was false";
			this.currentTest.posInfos = c;
			throw new js__$Boot_HaxeError(this.currentTest);
		}
	}
	,assertFalse: function(b,c) {
		this.currentTest.done = true;
		if(b == true) {
			this.currentTest.success = false;
			this.currentTest.error = "expected false but was true";
			this.currentTest.posInfos = c;
			throw new js__$Boot_HaxeError(this.currentTest);
		}
	}
	,assertEquals: function(expected,actual,c) {
		this.currentTest.done = true;
		if(actual != expected) {
			this.currentTest.success = false;
			this.currentTest.error = "expected '" + Std.string(expected) + "' but was '" + Std.string(actual) + "'";
			this.currentTest.posInfos = c;
			throw new js__$Boot_HaxeError(this.currentTest);
		}
	}
	,__class__: haxe_unit_TestCase
};
var TestHTMLRenderer = function() {
	haxe_unit_TestCase.call(this);
};
TestHTMLRenderer.__name__ = ["TestHTMLRenderer"];
TestHTMLRenderer.__super__ = haxe_unit_TestCase;
TestHTMLRenderer.prototype = $extend(haxe_unit_TestCase.prototype,{
	testBasic: function() {
		this.assertEquals("<div></div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { }, children : []}),{ fileName : "Tests.hx", lineNumber : 25, className : "TestHTMLRenderer", methodName : "testBasic"});
	}
	,testAttributes: function() {
		this.assertEquals("<div attr=\"test\"></div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { attr : "test"}, children : []}),{ fileName : "Tests.hx", lineNumber : 29, className : "TestHTMLRenderer", methodName : "testAttributes"});
	}
	,testStyleAttribute: function() {
		this.assertEquals("<div style=\"param2:test;param:value\"></div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { style : { param : "value", param2 : "test"}}, children : []}),{ fileName : "Tests.hx", lineNumber : 33, className : "TestHTMLRenderer", methodName : "testStyleAttribute"});
		this.assertEquals("<div style=\"param:value\"></div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { style : "param:value"}, children : []}),{ fileName : "Tests.hx", lineNumber : 34, className : "TestHTMLRenderer", methodName : "testStyleAttribute"});
		this.assertEquals("<div style=\"background-color:white\"></div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { style : { backgroundColor : "white"}}, children : []}),{ fileName : "Tests.hx", lineNumber : 35, className : "TestHTMLRenderer", methodName : "testStyleAttribute"});
	}
	,testChildren: function() {
		this.assertEquals("<div><div></div><div><div></div></div></div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []},{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]}]}),{ fileName : "Tests.hx", lineNumber : 39, className : "TestHTMLRenderer", methodName : "testChildren"});
	}
	,testTextnode: function() {
		this.assertEquals("<div>Test</div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { }, children : ["Test"]}),{ fileName : "Tests.hx", lineNumber : 48, className : "TestHTMLRenderer", methodName : "testTextnode"});
	}
	,testEscape: function() {
		this.assertEquals("<div attr=\"&lt;\" style=\"param:&lt;\">&lt;</div>",ithril_HTMLRenderer.render({ tag : "div", attrs : { attr : "<", style : { param : "<"}}, children : ["<"]}),{ fileName : "Tests.hx", lineNumber : 52, className : "TestHTMLRenderer", methodName : "testEscape"});
	}
	,testCustomList: function() {
		this.assertEquals("<ul><li><span>A</span></li><li><span>B</span></li><li><span>C</span></li></ul>",ithril_HTMLRenderer.render((function($this) {
			var $r;
			var children = [{ tag : "span", attrs : { }, children : ["A"]},{ tag : "span", attrs : { }, children : ["B"]},{ tag : "span", attrs : { }, children : ["C"]}];
			var tmp = ithril_component_ComponentCache.getComponent_ListComponent("5fad9d4c5a89eb88ee6c88ced2f46add",ListComponent,children,{ });
			tmp.setChildren(children);
			tmp.setState({ });
			$r = tmp;
			return $r;
		}(this))),{ fileName : "Tests.hx", lineNumber : 56, className : "TestHTMLRenderer", methodName : "testCustomList"});
	}
	,__class__: TestHTMLRenderer
});
var TestIthil = function() {
	haxe_unit_TestCase.call(this);
};
TestIthil.__name__ = ["TestIthil"];
TestIthil.__super__ = haxe_unit_TestCase;
TestIthil.prototype = $extend(haxe_unit_TestCase.prototype,{
	testBasic: function() {
		this.assert({ tag : "div", attrs : { }, children : []},{ tag : "div", attrs : { }, children : []});
	}
	,testClassname: function() {
		this.assert({ tag : "div", attrs : { 'class' : "test"}, children : []},{ tag : "div", attrs : { 'class' : "test"}, children : []});
		this.assert({ tag : "div", attrs : { 'class' : "test second"}, children : []},{ tag : "div", attrs : { 'class' : "test second"}, children : []});
		this.assert({ tag : "div", attrs : { 'class' : "test-with-hyphen"}, children : []},{ tag : "div", attrs : { 'class' : "test-with-hyphen"}, children : []});
		this.assert({ tag : "div", attrs : { 'class' : ["c1","c2"]}, children : []},{ tag : "div", attrs : { 'class' : ["c1","c2"]}, children : []});
	}
	,testId: function() {
		this.assert({ tag : "div", attrs : { 'id' : "test"}, children : []},{ tag : "div", attrs : { id : "test"}, children : []});
		this.assert({ tag : "div", attrs : { 'id' : "test-with-hyphen"}, children : []},{ tag : "div", attrs : { id : "test-with-hyphen"}, children : []});
	}
	,testChildren: function() {
		this.assert({ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]},{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]});
		this.assert({ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]}]},{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]}]});
		this.assert({ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []},{ tag : "div", attrs : { }, children : []}]},{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []},{ tag : "div", attrs : { }, children : []}]});
		this.assert({ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []},{ tag : "div", attrs : { }, children : []}]},{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []},{ tag : "div", attrs : { }, children : []}]});
		this.assert([{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]},{ tag : "div", attrs : { }, children : []}],[{ tag : "div", attrs : { }, children : [{ tag : "div", attrs : { }, children : []}]},{ tag : "div", attrs : { }, children : []}]);
	}
	,testAttribute: function() {
		this.assert({ tag : "div", attrs : { attr : "test"}, children : []},{ tag : "div", attrs : { attr : "test"}, children : []});
		this.assert({ tag : "div", attrs : { attr : "test", second : "test"}, children : []},{ tag : "div", attrs : { second : "test", attr : "test"}, children : []});
	}
	,testCallableAttribute: function() {
		var attr = function() {
			return { attr : "test"};
		};
		this.assert({ tag : "div", attrs : { attr : "test"}, children : []},{ tag : "div", attrs : ithril_Attributes.attrs(attr), children : []});
	}
	,testCombineAttributes: function() {
		this.assert({ tag : "div", attrs : { a : 1, b : 2}, children : []},{ tag : "div", attrs : ithril_Attributes.combine({ a : 1},{ b : 2}), children : []});
		this.assert({ tag : "div", attrs : { a : 1}, children : []},{ tag : "div", attrs : ithril_Attributes.combine({ a : 1},{ a : 2}), children : []});
		var attr = function() {
			return { attr : "test"};
		};
		this.assert({ tag : "div", attrs : { a : 1, attr : "test"}, children : []},{ tag : "div", attrs : ithril_Attributes.combine({ a : 1},ithril_Attributes.attrs(attr)), children : []});
		this.assert({ tag : "div", attrs : { id : "id", a : 1, attr : "test"}, children : ["ok"]},{ tag : "div", attrs : ithril_Attributes.combine({ id : "id"},ithril_Attributes.combine({ a : 1},ithril_Attributes.attrs(attr))), children : ["ok"]});
	}
	,testCombination: function() {
		this.assert({ tag : "div", attrs : { 'class' : "test", id : "test", attr : "test"}, children : []},{ tag : "div", attrs : { id : "test", 'class' : "test", attr : "test"}, children : []});
		this.assert({ tag : "div", attrs : { 'class' : "test", id : "test", attr : "test"}, children : ["a"]},{ tag : "div", attrs : { id : "test", 'class' : "test", attr : "test"}, children : ["a"]});
		this.assert({ tag : "div", attrs : { 'class' : "test", id : "test", attr : "test", attr2 : "test"}, children : []},{ tag : "div", attrs : { id : "test", 'class' : "test", attr : "test", attr2 : "test"}, children : []});
	}
	,testTextnode: function() {
		this.assert({ tag : "div", attrs : { }, children : ["Test"]},{ tag : "div", attrs : { }, children : ["Test"]});
	}
	,testAddToExistingAttributes: function() {
		var expected = { tag : "div", attrs : { attr : "test", id : "test", 'class' : "test"}, children : []};
		this.assert(expected,{ tag : "div", attrs : ithril_Attributes.combine({ id : "test", 'class' : "test"},ithril_Attributes.attrs({ attr : "test"})), children : []});
	}
	,testInlineExpression: function() {
		this.assert({ tag : "div", attrs : { }, children : ["Test"]},{ tag : "div", attrs : { }, children : ["Test"]});
	}
	,testInlineLoops: function() {
		var items = ["a","b","c"];
		this.assert({ tag : "div", attrs : { }, children : items},{ tag : "div", attrs : { }, children : (function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				while(_g1 < items.length) {
					var i = items[_g1];
					++_g1;
					_g.push(i);
				}
			}
			$r = _g;
			return $r;
		}(this))});
		this.assert({ tag : "div", attrs : { }, children : items},{ tag : "div", attrs : { }, children : (function($this) {
			var $r;
			var _g11 = [];
			{
				var _g2 = 0;
				while(_g2 < items.length) {
					var i1 = items[_g2];
					++_g2;
					_g11.push(i1);
				}
			}
			$r = _g11;
			return $r;
		}(this))});
		this.assert({ tag : "div", attrs : { }, children : [items]},{ tag : "div", attrs : { }, children : [(function($this) {
			var $r;
			var _g21 = [];
			{
				var _g3 = 0;
				while(_g3 < items.length) {
					var i2 = items[_g3];
					++_g3;
					_g21.push(i2);
				}
			}
			$r = _g21;
			return $r;
		}(this))]});
		this.assert({ tag : "div", attrs : { }, children : [items,{ tag : "div", attrs : { }, children : []}]},{ tag : "div", attrs : { }, children : [(function($this) {
			var $r;
			var _g31 = [];
			{
				var _g4 = 0;
				while(_g4 < items.length) {
					var i3 = items[_g4];
					++_g4;
					_g31.push(i3);
				}
			}
			$r = _g31;
			return $r;
		}(this)),{ tag : "div", attrs : { }, children : []}]});
	}
	,testCustomElement: function() {
		this.assert({ tag : "div", attrs : { attr : "test"}, children : []},((function($this) {
			var $r;
			var children = [];
			var tmp = ithril_component_ComponentCache.getComponent_CustomElement("24852e7a87499df9fed0a709dc7c2bad",CustomElement,children,{ attr : "test"});
			tmp.setChildren(children);
			tmp.setState({ attr : "test"});
			$r = tmp;
			return $r;
		}(this))).view());
	}
	,assert: function(o1,o2) {
		this.assertEquals(JSON.stringify(o1,null," "),JSON.stringify(o2,null," "),{ fileName : "Tests.hx", lineNumber : 222, className : "TestIthil", methodName : "assert"});
	}
	,__class__: TestIthil
});
var Tests = function() { };
Tests.__name__ = ["Tests"];
Tests.main = function() {
	var runner = new haxe_unit_TestRunner();
	runner.add(new TestIthil());
	runner.add(new TestHTMLRenderer());
	runner.run();
};
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null; else return js_Boot.getClass(o);
};
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
};
var haxe_StackItem = { __ename__ : true, __constructs__ : ["CFunction","Module","FilePos","Method","LocalFunction"] };
haxe_StackItem.CFunction = ["CFunction",0];
haxe_StackItem.CFunction.toString = $estr;
haxe_StackItem.CFunction.__enum__ = haxe_StackItem;
haxe_StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.LocalFunction = function(v) { var $x = ["LocalFunction",4,v]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
var haxe_CallStack = function() { };
haxe_CallStack.__name__ = ["haxe","CallStack"];
haxe_CallStack.getStack = function(e) {
	if(e == null) return [];
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			if(haxe_CallStack.wrapCallSite != null) site = haxe_CallStack.wrapCallSite(site);
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe_StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe_StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe_CallStack.makeStack(e.stack);
	Error.prepareStackTrace = oldValue;
	return a;
};
haxe_CallStack.exceptionStack = function() {
	return haxe_CallStack.getStack(haxe_CallStack.lastException);
};
haxe_CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe_CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe_CallStack.itemToString = function(b,s) {
	switch(s[1]) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s[2];
		b.b += "module ";
		if(m == null) b.b += "null"; else b.b += "" + m;
		break;
	case 2:
		var line = s[4];
		var file = s[3];
		var s1 = s[2];
		if(s1 != null) {
			haxe_CallStack.itemToString(b,s1);
			b.b += " (";
		}
		if(file == null) b.b += "null"; else b.b += "" + file;
		b.b += " line ";
		if(line == null) b.b += "null"; else b.b += "" + line;
		if(s1 != null) b.b += ")";
		break;
	case 3:
		var meth = s[3];
		var cname = s[2];
		if(cname == null) b.b += "null"; else b.b += "" + cname;
		b.b += ".";
		if(meth == null) b.b += "null"; else b.b += "" + meth;
		break;
	case 4:
		var n = s[2];
		b.b += "local function #";
		if(n == null) b.b += "null"; else b.b += "" + n;
		break;
	}
};
haxe_CallStack.makeStack = function(s) {
	if(s == null) return []; else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") stack.shift();
		var m = [];
		var rie10 = new EReg("^   at ([A-Za-z0-9_. ]+) \\(([^)]+):([0-9]+):([0-9]+)\\)$","");
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			if(rie10.match(line)) {
				var path = rie10.matched(1).split(".");
				var meth = path.pop();
				var file = rie10.matched(2);
				var line1 = Std.parseInt(rie10.matched(3));
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function"?haxe_StackItem.LocalFunction():meth == "Global code"?null:haxe_StackItem.Method(path.join("."),meth),file,line1));
			} else m.push(haxe_StackItem.Module(StringTools.trim(line)));
		}
		return m;
	} else return s;
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = ["haxe","IMap"];
var haxe_Log = function() { };
haxe_Log.__name__ = ["haxe","Log"];
haxe_Log.trace = function(v,infos) {
	js_Boot.__trace(v,infos);
};
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
haxe_ds__$StringMap_StringMapIterator.__name__ = ["haxe","ds","_StringMap","StringMapIterator"];
haxe_ds__$StringMap_StringMapIterator.prototype = {
	map: null
	,keys: null
	,index: null
	,count: null
	,hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	h: null
	,rh: null
	,set: function(key,value) {
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
		var _this = this.arrayKeys();
		return HxOverrides.iter(_this);
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
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe_ds_StringMap
};
var haxe_unit_TestResult = function() {
	this.m_tests = new List();
	this.success = true;
};
haxe_unit_TestResult.__name__ = ["haxe","unit","TestResult"];
haxe_unit_TestResult.prototype = {
	m_tests: null
	,success: null
	,add: function(t) {
		this.m_tests.add(t);
		if(!t.success) this.success = false;
	}
	,toString: function() {
		var buf_b = "";
		var failures = 0;
		var _g_head = this.m_tests.h;
		var _g_val = null;
		while(_g_head != null) {
			var test;
			test = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			if(test.success == false) {
				buf_b += "* ";
				if(test.classname == null) buf_b += "null"; else buf_b += "" + test.classname;
				buf_b += "::";
				if(test.method == null) buf_b += "null"; else buf_b += "" + test.method;
				buf_b += "()";
				buf_b += "\n";
				buf_b += "ERR: ";
				if(test.posInfos != null) {
					buf_b += Std.string(test.posInfos.fileName);
					buf_b += ":";
					buf_b += Std.string(test.posInfos.lineNumber);
					buf_b += "(";
					buf_b += Std.string(test.posInfos.className);
					buf_b += ".";
					buf_b += Std.string(test.posInfos.methodName);
					buf_b += ") - ";
				}
				if(test.error == null) buf_b += "null"; else buf_b += "" + test.error;
				buf_b += "\n";
				if(test.backtrace != null) {
					if(test.backtrace == null) buf_b += "null"; else buf_b += "" + test.backtrace;
					buf_b += "\n";
				}
				buf_b += "\n";
				failures++;
			}
		}
		buf_b += "\n";
		if(failures == 0) buf_b += "OK "; else buf_b += "FAILED ";
		buf_b += Std.string(this.m_tests.length);
		buf_b += " tests, ";
		if(failures == null) buf_b += "null"; else buf_b += "" + failures;
		buf_b += " failed, ";
		buf_b += Std.string(this.m_tests.length - failures);
		buf_b += " success";
		buf_b += "\n";
		return buf_b;
	}
	,__class__: haxe_unit_TestResult
};
var haxe_unit_TestRunner = function() {
	this.result = new haxe_unit_TestResult();
	this.cases = new List();
};
haxe_unit_TestRunner.__name__ = ["haxe","unit","TestRunner"];
haxe_unit_TestRunner.print = function(v) {
	var msg = js_Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) {
		msg = StringTools.htmlEscape(msg).split("\n").join("<br/>");
		d.innerHTML += msg + "<br/>";
	} else if(typeof process != "undefined" && process.stdout != null && process.stdout.write != null) process.stdout.write(msg); else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
haxe_unit_TestRunner.customTrace = function(v,p) {
	haxe_unit_TestRunner.print(p.fileName + ":" + p.lineNumber + ": " + Std.string(v) + "\n");
};
haxe_unit_TestRunner.prototype = {
	result: null
	,cases: null
	,add: function(c) {
		this.cases.add(c);
	}
	,run: function() {
		this.result = new haxe_unit_TestResult();
		var _g_head = this.cases.h;
		var _g_val = null;
		while(_g_head != null) {
			var c;
			c = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			this.runCase(c);
		}
		haxe_unit_TestRunner.print(this.result.toString());
		return this.result.success;
	}
	,runCase: function(t) {
		var old = haxe_Log.trace;
		haxe_Log.trace = haxe_unit_TestRunner.customTrace;
		var cl;
		if(t == null) cl = null; else cl = js_Boot.getClass(t);
		var fields = Type.getInstanceFields(cl);
		haxe_unit_TestRunner.print("Class: " + Type.getClassName(cl) + " ");
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var fname = f;
			var field = Reflect.field(t,f);
			if(StringTools.startsWith(fname,"test") && Reflect.isFunction(field)) {
				t.currentTest = new haxe_unit_TestStatus();
				t.currentTest.classname = Type.getClassName(cl);
				t.currentTest.method = fname;
				t.setup();
				try {
					Reflect.callMethod(t,field,[]);
					if(t.currentTest.done) {
						t.currentTest.success = true;
						haxe_unit_TestRunner.print(".");
					} else {
						t.currentTest.success = false;
						t.currentTest.error = "(warning) no assert";
						haxe_unit_TestRunner.print("W");
					}
				} catch( $e0 ) {
					haxe_CallStack.lastException = $e0;
					if ($e0 instanceof js__$Boot_HaxeError) $e0 = $e0.val;
					if( js_Boot.__instanceof($e0,haxe_unit_TestStatus) ) {
						var e = $e0;
						haxe_unit_TestRunner.print("F");
						t.currentTest.backtrace = haxe_CallStack.toString(haxe_CallStack.exceptionStack());
					} else {
					var e1 = $e0;
					haxe_unit_TestRunner.print("E");
					if(e1.message != null) t.currentTest.error = "exception thrown : " + Std.string(e1) + " [" + Std.string(e1.message) + "]"; else t.currentTest.error = "exception thrown : " + Std.string(e1);
					t.currentTest.backtrace = haxe_CallStack.toString(haxe_CallStack.exceptionStack());
					}
				}
				this.result.add(t.currentTest);
				t.tearDown();
			}
		}
		haxe_unit_TestRunner.print("\n");
		haxe_Log.trace = old;
	}
	,__class__: haxe_unit_TestRunner
};
var haxe_unit_TestStatus = function() {
	this.done = false;
	this.success = false;
};
haxe_unit_TestStatus.__name__ = ["haxe","unit","TestStatus"];
haxe_unit_TestStatus.prototype = {
	done: null
	,success: null
	,error: null
	,method: null
	,classname: null
	,posInfos: null
	,backtrace: null
	,__class__: haxe_unit_TestStatus
};
var ithril_Attributes = function() { };
ithril_Attributes.__name__ = ["ithril","Attributes"];
ithril_Attributes.attrs = function(input) {
	var response;
	if(Reflect.isFunction(input)) response = input(); else response = input;
	if(response == null) return { }; else return response;
};
ithril_Attributes.combine = function(a,b) {
	a = ithril_Attributes.attrs(a);
	b = ithril_Attributes.attrs(b);
	var _g = 0;
	var _g1 = Reflect.fields(a);
	while(_g < _g1.length) {
		var key = _g1[_g];
		++_g;
		Reflect.setField(b,key,Reflect.field(a,key));
	}
	return b;
};
var ithril_Component = function() { };
ithril_Component.__name__ = ["ithril","Component"];
var ithril_HTMLRenderer = function(space) {
	this.VOID_TAGS = ["area","base","br","col","command","embed","hr","img","input","keygen","link","meta","param","source","track","wbr","!doctype"];
	this.space = space;
};
ithril_HTMLRenderer.__name__ = ["ithril","HTMLRenderer"];
ithril_HTMLRenderer.render = function(view,space) {
	if(space == null) space = "";
	var renderer = new ithril_HTMLRenderer(space);
	return renderer.renderView(view);
};
ithril_HTMLRenderer.prototype = {
	VOID_TAGS: null
	,space: null
	,escape: function(str) {
		return StringTools.htmlEscape(str);
	}
	,createChildrenContent: function(view,level) {
		if((view.children instanceof Array) && view.children.__enum__ == null && view.children.length == 0) return "";
		return this.renderView(view.children,level);
	}
	,removeEmpty: function(n) {
		return n != "" && n != null;
	}
	,camelToDash: function(str) {
		var outStr = "";
		var _g1 = 0;
		var _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			var chr = HxOverrides.cca(str,i);
			if(chr >= 65 && chr <= 90) outStr += "-" + String.fromCharCode(chr - 65 + 97); else outStr += String.fromCharCode(chr);
		}
		return outStr;
	}
	,attribute: function(name,value) {
		var _g = this;
		if(Reflect.isFunction(value) || value == null) return "";
		if(typeof(value) == "boolean") if(value) return " " + name; else return "";
		if(name == "style") {
			if(value == "") return "";
			var styles = "";
			if(Reflect.isObject(styles)) styles = Reflect.fields(value).map(function(key) {
				var prop = Reflect.field(value,key);
				if(prop != "") return [_g.camelToDash(key).toLowerCase(),prop].join(":"); else return "";
			}).filter($bind(this,this.removeEmpty)).join(";");
			if(typeof(value) == "string") styles = value;
			if(styles != "") return " style=\"" + StringTools.htmlEscape(styles) + "\""; else return "";
		}
		return " " + (name == "className"?"class":name) + "=\"" + this.escape(value) + "\"";
	}
	,createAttrString: function(attrs) {
		var _g = this;
		if(attrs == null) return "";
		return Reflect.fields(attrs).map(function(name) {
			return _g.attribute(name,Reflect.field(attrs,name));
		}).join("");
	}
	,renderView: function(view,level) {
		if(level == null) level = 0;
		if(typeof(view) == "string" || ((view | 0) === view) || typeof(view) == "number" || typeof(view) == "boolean") return this.spacer(level) + StringTools.htmlEscape(Std.string(view)) + this.lineEnd();
		if(view == null) return "";
		if((view instanceof Array) && view.__enum__ == null) return view.map((function(f,a2) {
			return function(a1) {
				return f(a1,a2);
			};
		})($bind(this,this.renderView),level + 1)).join("");
		if(Reflect.isObject(view)) {
			var type = Type.getClass(view);
			if(type != null) {
				var fields = Type.getInstanceFields(type);
				if(Lambda.has(fields,"view")) {
					var scope;
					if(Lambda.has(fields,"controller")) scope = view.controller(); else scope = { };
					var result = this.renderView(view.view(),level);
					if(Object.prototype.hasOwnProperty.call(scope,"onunload")) scope.onunload();
					return result;
				}
			}
		}
		if(js_Boot.__instanceof(view,ithril_TrustedHTML)) return Std.string(view);
		if((function($this) {
			var $r;
			var x = view.tag.toLowerCase();
			$r = HxOverrides.indexOf($this.VOID_TAGS,x,0);
			return $r;
		}(this)) >= 0) return this.spacer(level) + "<" + Std.string(view.tag) + this.createAttrString(view.attrs) + ">" + this.lineEnd();
		var children = this.createChildrenContent(view,level + 1);
		return [this.spacer(level) + "<",view.tag,this.createAttrString(view.attrs),">" + this.lineEnd(),children,this.spacer(level) + "</",view.tag,">" + this.lineEnd()].join("");
	}
	,lineEnd: function() {
		if(this.space == "") return ""; else return "\n";
	}
	,spacer: function(level) {
		if(this.space == "") return "";
		return ((function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				while(_g1 < level) {
					var i = _g1++;
					_g.push("");
				}
			}
			$r = _g;
			return $r;
		}(this))).join(this.space);
	}
	,__class__: ithril_HTMLRenderer
};
var ithril_TrustedHTML = function(body) {
	this.body = body;
	m.trust(body);
	return;
};
ithril_TrustedHTML.__name__ = ["ithril","TrustedHTML"];
ithril_TrustedHTML.prototype = {
	body: null
	,toString: function() {
		return this.body;
	}
	,__class__: ithril_TrustedHTML
};
var ithril_component_ComponentCache = function() { };
ithril_component_ComponentCache.__name__ = ["ithril","component","ComponentCache"];
ithril_component_ComponentCache.getComponent_CustomElement = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,children,state,function() {
		return new CustomElement();
	});
};
ithril_component_ComponentCache.getComponent_ListComponent = function(key,type,children,state) {
	return ithril_component_ComponentCache.getInstance(key,children,state,function() {
		return new ListComponent();
	});
};
ithril_component_ComponentCache.createKey = function(key,state) {
	var id = "";
	if(Object.prototype.hasOwnProperty.call(state,"key")) id = "__key__" + Std.string(Reflect.field(state,"key")); else {
		var count;
		if(ithril_component_ComponentCache.componentCount.exists(key)) count = ithril_component_ComponentCache.componentCount.get(key); else count = 0;
		ithril_component_ComponentCache.componentCount.set(key,count + 1);
		if(count == null) id = "null"; else id = "" + count;
		if(ithril_component_ComponentCache.timeout == null) {
			var $it0 = ithril_component_ComponentCache.componentInstances.iterator();
			while( $it0.hasNext() ) {
				var component = $it0.next();
				component.dirty = true;
			}
			ithril_component_ComponentCache.timeout = window.requestAnimationFrame(function(_) {
				ithril_component_ComponentCache.componentCount = new haxe_ds_StringMap();
				ithril_component_ComponentCache.timeout = null;
				var $it1 = ithril_component_ComponentCache.componentInstances.keys();
				while( $it1.hasNext() ) {
					var key1 = $it1.next();
					var component1 = ithril_component_ComponentCache.componentInstances.get(key1);
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
	if(!ithril_component_ComponentCache.componentInstances.exists(key)) {
		var c = create();
		c.mount();
		ithril_component_ComponentCache.componentInstances.set(key,c);
	}
	var component = ithril_component_ComponentCache.componentInstances.get(key);
	component.dirty = false;
	return component;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	val: null
	,__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = ["js","Boot"];
js_Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js_Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js_Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js_Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js_Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
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
			haxe_CallStack.lastException = e;
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
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.__name__ = ["Array"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
if(Array.prototype.filter == null) Array.prototype.filter = function(f1) {
	var a1 = [];
	var _g11 = 0;
	var _g2 = this.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var e = this[i1];
		if(f1(e)) a1.push(e);
	}
	return a1;
};
var __map_reserved = {}
ithril_component_ComponentCache.componentInstances = new haxe_ds_StringMap();
ithril_component_ComponentCache.componentCount = new haxe_ds_StringMap();
js_Boot.__toStr = {}.toString;
Tests.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

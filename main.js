(function () { "use strict";
var View = function() { };
var Main = function() {
	m.render(window.document.getElementById("main"),this.view());
};
Main.__interfaces__ = [View];
Main.main = function() {
	new Main();
};
Main.prototype = {
	view: function() {
		var menu = [{ title : "link1", href : "/"},{ title : "link2", href : "/link2"}];
		return [{ tag : "div", attrs : { 'class' : "test"}, children : [{ tag : "h1", attrs : { }, children : ["Test template"]},{ tag : "nav", attrs : { 'class' : "main-nav"}, children : [{ tag : "ul", attrs : { }, children : [(function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				while(_g1 < menu.length) {
					var item = menu[_g1];
					++_g1;
					_g.push([{ tag : "li", attrs : { }, children : [{ tag : "a", attrs : { href : item.href}, children : [item.title]}]}]);
				}
			}
			$r = _g;
			return $r;
		}(this)),{ tag : "li", attrs : { }, children : [{ tag : "a", attrs : { href : "/"}, children : ["Home"]}]}]}]},{ tag : "div", attrs : { 'class' : "form"}, children : [{ tag : "form", attrs : { method : "post", action : "/"}, children : [{ tag : "label", attrs : { 'class' : "field"}, children : ["Your name: ",{ tag : "input", attrs : { name : "name", type : "text"}, children : []}]},{ tag : "label", attrs : { 'class' : "field", type : "text"}, children : ["Your e-mail: ",{ tag : "input", attrs : { name : "mail", type : "email"}, children : []}]},{ tag : "button", attrs : { id : "submit", type : "email"}, children : ["Submit form"]}]}]},{ tag : "footer", attrs : { id : "id", 'class' : "few more classes", type : "email"}, children : ["Footer text"]}]}];
	}
};
Main.main();
})();

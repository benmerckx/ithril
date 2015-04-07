(function () { "use strict";
var ithril = {};
ithril.View = function() { };
var Example = function() {
	m.render(window.document.getElementById("main"),this.view());
};
Example.__interfaces__ = [ithril.View];
Example.main = function() {
	new Example();
};
Example.prototype = {
	view: function() {
		var menu = [{ title : "link1", href : "/"},{ title : "link2", href : "/link2"}];
		return [{ tag : "html", attrs : { xlmns : "http://www.w3.org/1999/xhtml", lang : "en", 'xml:lang' : "en"}, children : [{ tag : "head", attrs : { }, children : [{ tag : "title", attrs : "BoBlog", children : []},{ tag : "meta", attrs : { 'http-equiv' : "Content-Type", content : "text/html; charset=utf-8"}, children : []},{ tag : "link", attrs : { rel : "stylesheet", href : "main.css", type : "text/css"}, children : []}]},{ tag : "body", attrs : { }, children : [{ tag : "div", attrs : { id : "header"}, children : [{ tag : "h1", attrs : "BoBlog", children : []},{ tag : "h2", attrs : "Bob's Blog", children : []}]},{ tag : "div", attrs : { id : "content"}, children : ["Haha",(function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				while(_g1 < menu.length) {
					var item = menu[_g1];
					++_g1;
					_g.push([{ tag : "li", attrs : item.title, children : []}]);
				}
			}
			$r = _g;
			return $r;
		}(this))]},{ tag : "div", attrs : { id : "footer"}, children : [{ tag : "p", attrs : "All content &copy; Bob", children : []}]}]}]}];
	}
};
Example.main();
})();
